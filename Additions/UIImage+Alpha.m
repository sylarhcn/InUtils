// UIImage+Alpha.m
// Created by Trevor Harmon on 9/20/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

#import "UIImage+Alpha.h"

// Private helper methods
@interface UIImage ()
- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size;
@end

@implementation UIImage (Alpha)

// Returns true if the image has an alpha layer
- (BOOL)hasAlpha {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

// Returns a copy of the given image, adding an alpha channel if it doesn't already have one
- (UIImage *)imageWithAlpha {
    if ([self hasAlpha]) {
        return self;
    }
    
    CGImageRef imageRef = self.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                          width,
                                                          height,
                                                          8,
                                                          0,
                                                          CGImageGetColorSpace(imageRef),
                                                          kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    // Draw the image into the context and retrieve the new image, which will now have an alpha layer
    CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
    UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];
    
    // Clean up
    CGContextRelease(offscreenContext);
    CGImageRelease(imageRefWithAlpha);
    
    return imageWithAlpha;
}

// Returns a copy of the image with a transparent border of the given size added around its edges.
// If the image has no alpha layer, one will be added to it.
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize {
    // If the image does not have an alpha layer, add one
    UIImage *image = [self imageWithAlpha];
    
    CGRect newRect = CGRectMake(0, 0, image.size.width + borderSize * 2, image.size.height + borderSize * 2);
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(self.CGImage),
                                                0,
                                                CGImageGetColorSpace(self.CGImage),
                                                CGImageGetBitmapInfo(self.CGImage));
    
    // Draw the image in the center of the context, leaving a gap around the edges
    CGRect imageLocation = CGRectMake(borderSize, borderSize, image.size.width, image.size.height);
    CGContextDrawImage(bitmap, imageLocation, self.CGImage);
    CGImageRef borderImageRef = CGBitmapContextCreateImage(bitmap);
    
    // Create a mask to make the border transparent, and combine it with the image
    CGImageRef maskImageRef = [self newBorderMask:borderSize size:newRect.size];
    CGImageRef transparentBorderImageRef = CGImageCreateWithMask(borderImageRef, maskImageRef);
    UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(borderImageRef);
    CGImageRelease(maskImageRef);
    CGImageRelease(transparentBorderImageRef);
    
    return transparentBorderImage;
}

// Transform the image in grayscale.
- (UIImage *)grayishImage {
//    
//    // Create a graphic context.
//    UIGraphicsBeginImageContextWithOptions(self.size, YES, 1.0);
//    CGRect imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
//    
//    // Draw the image with the luminosity blend mode.
//    // On top of a white background, this will give a black and white image.
//    [self drawInRect:imageRect blendMode:kCGBlendModeLuminosity alpha:1.0];
//    
//    // Get the resulting image.
//    UIImage *filteredImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return filteredImage;
    const int RED = 1;
    const int GREEN = 2;
    const int BLUE = 3;
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, self.size.width * self.scale, self.size.height * self.scale);
    
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image
                                                 scale:self.scale 
                                           orientation:UIImageOrientationUp];
    
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}

// Return a bitmap context using alpha/red/green/blue byte values 
CGContextRef CreateRGBABitmapContext (CGImageRef inImage) 
{
	CGContextRef context = NULL; 
	CGColorSpaceRef colorSpace; 
	void *bitmapData; 
	int bitmapByteCount; 
	int bitmapBytesPerRow;
	size_t pixelsWide = CGImageGetWidth(inImage); 
	size_t pixelsHigh = CGImageGetHeight(inImage); 
	bitmapBytesPerRow	= (pixelsWide * 4); 
	bitmapByteCount	= (bitmapBytesPerRow * pixelsHigh); 
	colorSpace = CGColorSpaceCreateDeviceRGB();
	if (colorSpace == NULL) 
	{
		fprintf(stderr, "Error allocating color space\n"); return NULL;
	}
	// allocate the bitmap & create context 
	bitmapData = malloc( bitmapByteCount ); 
	if (bitmapData == NULL) 
	{
		fprintf (stderr, "Memory not allocated!"); 
		CGColorSpaceRelease( colorSpace ); 
		return NULL;
	}
	context = CGBitmapContextCreate (bitmapData, 
                                     pixelsWide, 
                                     pixelsHigh, 
                                     8, 
                                     bitmapBytesPerRow, 
                                     colorSpace, 
                                     kCGImageAlphaPremultipliedLast);
	if (context == NULL) 
	{
		free (bitmapData); 
		fprintf (stderr, "Context not created!");
	} 
	CGColorSpaceRelease( colorSpace ); 
	return context;
}

// Return Image Pixel data as an RGBA bitmap 
unsigned char *RequestImagePixelData(UIImage *inImage) 
{
	CGImageRef img = [inImage CGImage]; 
	CGSize size = [inImage size];
	CGContextRef cgctx = CreateRGBABitmapContext(img); 
	
	if (cgctx == NULL) 
		return NULL;
	
	CGRect rect = {{0,0},{size.width, size.height}}; 
	CGContextDrawImage(cgctx, rect, img); 
	unsigned char *data = CGBitmapContextGetData (cgctx); 
	CGContextRelease(cgctx);
	return data;
}

- (UIImage*)memoryImage {
    unsigned char *imgPixel = RequestImagePixelData(self);
	CGImageRef inImageRef = [self CGImage];
	int w = CGImageGetWidth(inImageRef);
	int h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	int pixOff = 0;
	
	for(int y = 0;y< h;y++)
	{
		pixOff = wOff;
		
		for (int x = 0; x < w; x++) 
		{
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
			int m = ( red + green + blue ) / 3;
            
            imgPixel[pixOff] = m;//MIN(255, (red * 0.393) + (green * 0.769) + (blue * 0.189));
			imgPixel[pixOff+1] = m;//MIN(255, (red * 0.349) + (green * 0.686) + (blue * 0.168));
			imgPixel[pixOff+2] = m;//MIN(255, (red * 0.272) + (green * 0.534) + (blue * 0.131));
			
			pixOff += 4;
		}
		wOff += w * 4;
	}
	
	NSInteger dataLength = w*h* 4;
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
	// prep the ingredients
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	int bytesPerRow = 4 * w;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	
	// make the cgimage
	CGImageRef imageRef = CGImageCreate(w, h, 
                                        bitsPerComponent, 
                                        bitsPerPixel, 
                                        bytesPerRow, 
                                        colorSpaceRef, 
                                        bitmapInfo, 
                                        provider, NULL, NO, renderingIntent);
	
	UIImage *my_Image = [UIImage imageWithCGImage:imageRef];
	
	CFRelease(imageRef);
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
	return my_Image;
}
#pragma mark -
#pragma mark Private helper methods
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
// Creates a mask that makes the outer edges transparent and everything else opaque
// The size must include the entire mask (opaque part + transparent border)
// The caller is responsible for releasing the returned reference by calling CGImageRelease

- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Build a context that's the same dimensions as the new size
    CGContextRef maskContext = CGBitmapContextCreate(NULL,
                                                     size.width,
                                                     size.height,
                                                     8, // 8-bit grayscale
                                                     0,
                                                     colorSpace,
                                                     kCGBitmapByteOrderDefault | kCGImageAlphaNone);
    
    // Start with a mask that's entirely transparent
    CGContextSetFillColorWithColor(maskContext, [UIColor blackColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(0, 0, size.width, size.height));
    
    // Make the inner part (within the border) opaque
    CGContextSetFillColorWithColor(maskContext, [UIColor whiteColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(borderSize, borderSize, size.width - borderSize * 2, size.height - borderSize * 2));
    
    // Get an image of the context
    CGImageRef maskImageRef = CGBitmapContextCreateImage(maskContext);
    
    // Clean up
    CGContextRelease(maskContext);
    CGColorSpaceRelease(colorSpace);
    
    return maskImageRef;
}
#pragma clang diagnostic pop
@end
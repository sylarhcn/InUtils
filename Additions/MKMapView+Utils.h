//
//  MKMapView+ZoomLevel.h
//  higolf
//
//  Created by aaron yao on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

- (double)getZoomLevel;
@end
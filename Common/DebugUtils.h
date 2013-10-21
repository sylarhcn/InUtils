//
//  DebugUtils.h
//  InChengdu20
//
//  Created by aaron on 1/29/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

#ifdef DEBUG
#  define LOG(...) NSLog(__VA_ARGS__)
#  define LOGRECT(r) NSLog(@"(%.1fx%.1f)-(%.1fx%.1f)", r.origin.x, r.origin.y, r.size.width, r.size.height)
//#  define dir_rd(v)  NSLog(@"\n%@", GetRecursiveDescription(v))
//#  define dir_si(v)  NSLog(@"\n%@", GetScriptingInfoWithChildren(v))
#else
#  define LOG(...) ;
#  define LOGRECT(r) ;
#  define dir_rd(v) ;
#  define dir_si(v) ;
#endif

#define __FUNC_NAME__ NSLog(NSStringFromSelector(_cmd)); 


//extern NSString *GetRecursiveDescription(UIView *view);
//extern NSString *GetScriptingInfoWithChildren(UIView *view);

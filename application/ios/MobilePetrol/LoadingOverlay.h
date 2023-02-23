//
//  LoadingOverlay.h
//  MobilePetrol
//
//  Created by user on 10/21/13.
//  Copyright (c) 2013 foreigntree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OverlayView.h"

static OverlayView *overlayview;

@interface LoadingOverlay : NSObject

+(void)addLoadingInView:(UIView *)view;
+(void)removeLoadingFromView:(UIView *)view;

@end

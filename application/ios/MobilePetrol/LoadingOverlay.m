//
//  LoadingOverlay.m
//  MobilePetrol
//
//  Created by user on 10/21/13.
//  Copyright (c) 2013 foreigntree. All rights reserved.
//

#import "LoadingOverlay.h"

@implementation LoadingOverlay


+(void)addLoadingInView:(UIView *)view{
    
    if(!overlayview)
        overlayview =[[OverlayView alloc]   initWithFrame:CGRectMake(0, 0, 320, 520) title:@"Loading..." view:view];
    
    
    if(![overlayview isDescendantOfView:view]) {
        
        [view addSubview:overlayview];
    }

    
}

+(void)removeLoadingFromView:(UIView *)view
{
    
    if([overlayview isDescendantOfView:view]) {
        
        [overlayview removeFromSuperview];
    }
    
}

@end

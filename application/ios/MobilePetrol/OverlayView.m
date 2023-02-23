//
//  OverlayView.m
//  EzeeClick
//
//  Created by Rao on 21/01/2013.
//  Copyright (c) 2013 Arafat. All rights reserved.
//

#import "OverlayView.h"

@implementation OverlayView

- (id)initWithFrame:(CGRect)frame title:(NSString *)_title view:(UIView *)_view
{
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
        frame = CGRectMake(0, 0, 768, 975);
    self = [super initWithFrame:frame];
    if (self) {
        
        //UILabel *lblView;
        UILabel *lblTtile;
        UIView *viewActivity;
        
        self.backgroundColor=[UIColor blackColor];
        self.alpha=0.5;
        
        viewActivity=[[UIView alloc]initWithFrame:CGRectMake(120, 200, 100, 100)];
        viewActivity.backgroundColor=[UIColor blackColor];
        viewActivity.alpha=1.0;
        viewActivity.center = _view.center;
        
        [[viewActivity layer] setCornerRadius:9.0f];
        [[viewActivity layer] setMasksToBounds:YES];
        
        
        UIActivityIndicatorView *spinny = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [spinny setFrame:CGRectMake(40, 30, 20, 20)];
        // spinny.center = view_indicator.center;
        [spinny startAnimating];
        [viewActivity addSubview:spinny];
        
        
        lblTtile=[[UILabel alloc]initWithFrame:CGRectMake(10, 55, 90, 30)];
        lblTtile.backgroundColor=[UIColor clearColor];
        //lblTtile.textColor=[UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0];
        lblTtile.textColor=[UIColor whiteColor];
       // lblTtile.font=[UIFont  size:14];
        lblTtile.textAlignment=UITextAlignmentCenter;
        //lblTtile.text=@"Loading Process bar....";
        lblTtile.text=_title;
        lblTtile.lineBreakMode=UILineBreakModeTailTruncation;
        lblTtile.numberOfLines=0;
        [viewActivity addSubview:lblTtile];
        
        
        [self addSubview:viewActivity];
        
        
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

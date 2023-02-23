//
//  MobilePetrolVC.h
//  MobilePetrol
//
//  Created by user on 10/14/13.
//  Copyright (c) 2013 foreigntree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingOverlay.h"

typedef void (^RequestCompletionHandler)(NSURLResponse *response,NSData *data,NSError *error);

@interface MobilePetrolVC : UIViewController


-(NSData *)WebrequestWithParameters:(NSString *)param Url:(NSString *)url AndMethod:(NSString *)Method;

-(NSData *)WebrequestWithParameters:(NSString *)param Url:(NSString *)url Method:(NSString *)Method AndCompletionHandler:(RequestCompletionHandler)handler;

-(BOOL) checkInternetConnection;

@end

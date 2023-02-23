//
//  MobilePetrolVC.m
//  MobilePetrol
//
//  Created by user on 10/14/13.
//  Copyright (c) 2013 foreigntree. All rights reserved.
//

#import "MobilePetrolVC.h"
#import "Reachability.h"

@interface MobilePetrolVC ()

@end

@implementation MobilePetrolVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundview.png"]];
    [self.view setBackgroundColor:color];
    
}

-(NSData *)WebrequestWithParameters:(NSString *)param Url:(NSString *)url AndMethod:(NSString *)Method
{
    NSData *respdata = nil;
    

    if([Method isEqualToString:@"POST"])
    {
        
        //POST Method
        NSString *tempstr = [NSString stringWithString:param];
        NSData *tempdata = [tempstr dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSString *datalength = [ NSString stringWithFormat:@"%lu",(unsigned long)tempdata.length ];
        NSURL *uri = [NSURL URLWithString:url];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:uri];
        [urlRequest setHTTPMethod: @"POST"];
        [urlRequest setValue:datalength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded"
          forHTTPHeaderField:@"Content-Type"];
        [urlRequest setTimeoutInterval:15.0];
        [urlRequest setHTTPBody:tempdata];
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        respdata =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        
        if (response) {
            NSHTTPURLResponse* newResp = (NSHTTPURLResponse*)response;
            NSLog(@"%d", newResp.statusCode);
            
            NSString *respstr =  [[NSString alloc]initWithData:respdata encoding:NSUTF8StringEncoding];
            NSLog(@"Response string: %@", respstr);
            
            return respdata;
            
        }
        else {
            NSLog(@"No response received");
            return respdata;
        }
    }
    else
    {
        //GET Method
        NSURL *uri = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",url,param]];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:uri];
        [urlRequest setHTTPMethod: @"GET"];
        [urlRequest setTimeoutInterval:15.0];
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        respdata =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        
        if (response) {
            NSHTTPURLResponse* newResp = (NSHTTPURLResponse*)response;
            NSLog(@"%d", newResp.statusCode);
            
            NSString *respstr =  [[NSString alloc]initWithData:respdata encoding:NSUTF8StringEncoding];
            NSLog(@"Response string: %@", respstr);
            
            return respdata;
            
        }
        else {
            NSLog(@"No response received");
            return respdata;
        }

        
    }

}


-(NSData *)WebrequestWithParameters:(NSString *)param Url:(NSString *)url Method:(NSString *)Method AndCompletionHandler:(RequestCompletionHandler)handler
{
    NSData *respdata = nil;
    
    
    if([Method isEqualToString:@"POST"])
    {
        
        //POST Method
        NSString *tempstr = [NSString stringWithString:param];
        NSData *tempdata = [tempstr dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSString *datalength = [ NSString stringWithFormat:@"%lu",(unsigned long)tempdata.length ];
        NSURL *uri = [NSURL URLWithString:url];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:uri];
        [urlRequest setHTTPMethod: @"POST"];
        [urlRequest setValue:datalength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded"
          forHTTPHeaderField:@"Content-Type"];
        [urlRequest setTimeoutInterval:15.0];
        [urlRequest setHTTPBody:tempdata];
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSOperationQueue *backgroudQueue = [NSOperationQueue mainQueue];

        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:backgroudQueue
                               completionHandler:^(NSURLResponse *response,NSData *data,NSError *error)
         {
             
              if (handler) handler(response,data,error);
             
             
         }];
        
        respdata =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        
        if (response) {
            NSHTTPURLResponse* newResp = (NSHTTPURLResponse*)response;
            NSLog(@"%d", newResp.statusCode);
            
            NSString *respstr =  [[NSString alloc]initWithData:respdata encoding:NSUTF8StringEncoding];
            NSLog(@"Response string: %@", respstr);
            
            return respdata;
            
        }
        else {
            NSLog(@"No response received");
            return respdata;
        }
    }
    else
    {
        //GET Method
        NSURL *uri = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",url,param]];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:uri];
        [urlRequest setHTTPMethod: @"GET"];
        [urlRequest setTimeoutInterval:15.0];
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        respdata =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        
        if (response) {
            NSHTTPURLResponse* newResp = (NSHTTPURLResponse*)response;
            NSLog(@"%d", newResp.statusCode);
            
            NSString *respstr =  [[NSString alloc]initWithData:respdata encoding:NSUTF8StringEncoding];
            NSLog(@"Response string: %@", respstr);
            
            return respdata;
            
        }
        else {
            NSLog(@"No response received");
            return respdata;
        }
        
        
    }
    
}

-(BOOL) checkInternetConnection{
    
    BOOL isInternet = NO;
    
    Reachability* reachability = [Reachability reachabilityWithHostName:@"google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable)
    {
        isInternet =NO;
    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        isInternet = YES;
    }
    else if (remoteHostStatus == ReachableViaWiFi)
    {
        isInternet = YES;
        
    }
    return isInternet;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
//
//  ViewController.m
//  MobilePetrol
//
//  Created by user on 10/9/13.
//  Copyright (c) 2013 foreigntree. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)request:(id)sender {
    
   NSString *repath= [[NSBundle mainBundle] resourcePath];
   NSString *filepath = [repath stringByAppendingPathComponent:@"contactlist.plist"];
   // NSData *data = [NSData dataWithContentsOfFile:filepath];
    
    id plist = [[NSDictionary alloc] initWithContentsOfFile:filepath];
    
    
    NSData *xmlData = [NSPropertyListSerialization dataFromPropertyList:plist
                                                                 format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
    NSString *xml_string = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    
    NSString *tempstr = [NSString stringWithFormat:@"user_id=1223&addressbook=%@",xml_string];
    NSData *tempdata = [tempstr dataUsingEncoding:NSUTF8StringEncoding];


    NSString *datalength = [ NSString stringWithFormat:@"%lu",(unsigned long)tempdata.length ];
    
    NSString *baseurl = @"http://www.demo.foreigntree.com/mobilepetrol/api/save_addressbook.php";
    
    NSURL *url = [NSURL URLWithString:baseurl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setValue:datalength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/x-www-form-urlencoded"
      forHTTPHeaderField:@"Content-Type"];
    //[urlRequest setValue:@"1" forHTTPHeaderField:@"user_id"];
    
    [urlRequest setHTTPBody:tempdata];
    NSURLResponse *response = nil;
    NSError *error = nil;
   NSData *respdata =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    if (response) {
        NSHTTPURLResponse* newResp = (NSHTTPURLResponse*)response;
        NSLog(@"%d", newResp.statusCode);
        
      NSString *respstr =  [[NSString alloc]initWithData:respdata encoding:NSUTF8StringEncoding];
        NSLog(@"Response string: %@", respstr);

    
    }
    else {
        NSLog(@"No response received");
    }
    
}
@end

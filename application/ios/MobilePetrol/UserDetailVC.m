//
//  UserDetailVC.m
//  MobilePetrol
//
//  Created by user on 10/14/13.
//  Copyright (c) 2013 foreigntree. All rights reserved.
//

#import "UserDetailVC.h"
#import "MainVC.h"

@interface UserDetailVC ()

@end

@implementation UserDetailVC

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
    
    self.txtphoneno.delegate= self;
    self.txtemail.delegate=  self;
    self.txtlname.delegate = self;
    self.txtfname.delegate = self;
    
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    self.txtphoneno.text=  [defaults objectForKey:@"userdetail_phone"];
    self.txtemail.text=  [defaults objectForKey:@"userdetail_email"];
    self.txtlname.text = [defaults objectForKey:@"userdetail_lastname"];
    self.txtfname.text = [defaults objectForKey:@"userdetail_firstname"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logoutClicked:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"null" forKey:@"user_id"];
    [defaults setObject:@"null" forKey:@"phonebook_id"];
    [defaults setObject:@"null" forKey:@"userdetail_phone"];
    [defaults setObject:@"null" forKey:@"userdetail_email"];
    [defaults setObject:@"null" forKey:@"userdetail_lastname"];
    [defaults setObject:@"null" forKey:@"userdetail_firstname"];
    
    [defaults setBool:NO forKey:@"SetData"];
    [defaults synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)okClicked:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}
@end

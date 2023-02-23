//
//  MainVC.m
//  MobilePetrol
//
//  Created by user on 10/14/13.
//  Copyright (c) 2013 foreigntree. All rights reserved.
//

#import "MainVC.h"
#import "LoginUserVC.h"

@interface MainVC ()

@end

@implementation MainVC

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AccountTouched:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    if([[defaults objectForKey:@"user_id"] isEqualToString:@"null"])
    {
        UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginUserVC"];
        [self.navigationController pushViewController:VC animated:YES];
    
    }
    else
    {
        UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserDetailVC"];
        [self.navigationController pushViewController:VC animated:YES];
    
    }
}
- (IBAction)RestoreTouched:(id)sender {
    
    UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"RestoreVC"];
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (IBAction)backupTouched:(id)sender {
    
    UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"BackupVC"];
        [self.navigationController pushViewController:VC animated:YES];
    
}
@end

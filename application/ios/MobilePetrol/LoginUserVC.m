//
//  LoginUserVC.m
//  MobilePetrol
//
//  Created by user on 10/14/13.
//  Copyright (c) 2013 foreigntree. All rights reserved.
//

#import "LoginUserVC.h"

@interface LoginUserVC ()

@end

@implementation LoginUserVC

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
    
    self.txtpassword.delegate =self;
    self.txtusername.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginClicked:(id)sender {
    
    if(self.txtusername.text.length>0 && self.txtpassword.text.length>0)
    {
        
        if([self checkInternetConnection])
        {
            NSString *param = [NSString stringWithFormat:@"username=%@&pass=%@",self.txtusername.text,self.txtpassword.text];
            NSString *url = [NSString stringWithFormat:@"http://www.demo.foreigntree.com/mobilepetrol/api/login_user.php"];
            NSData *temp = [self WebrequestWithParameters:param Url:url AndMethod:@"POST"];
            
            NSError *error = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:temp options:0 error:&error];
            
            if (!error){
                
                if ([[dic objectForKey:@"status"] isEqualToString:@"ok"])
                {
                    
                    NSString *user_id = [dic objectForKey:@"user_id"];
                    NSString *userdetail_phone = [dic objectForKey:@"userdetail_phone"];
                    NSString *userdetail_email = [dic objectForKey:@"userdetail_email"];
                    NSString *userdetail_lastname = [dic objectForKey:@"userdetail_lastname"];
                    NSString *userdetail_firstname = [dic objectForKey:@"userdetail_firstname"];
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:user_id forKey:@"user_id"];
                    [defaults setObject:userdetail_phone forKey:@"userdetail_phone"];
                    [defaults setObject:userdetail_email forKey:@"userdetail_email"];
                    [defaults setObject:userdetail_lastname forKey:@"userdetail_lastname"];
                    [defaults setObject:userdetail_firstname forKey:@"userdetail_firstname"];
                    [defaults synchronize];
                    
                    UIViewController *VC =[self.storyboard instantiateViewControllerWithIdentifier:@"UserDetailVC"];
                    [self.navigationController pushViewController:VC animated:YES];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login Failed" message:@"Invalid username or password, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login Failed" message:@"Login is unsuccessful, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            
        }
        else
        {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Network Error!" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login Failed" message:@"Invalid username or password, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (IBAction)SignedupClicked:(id)sender {
}

#pragma Mark - Textfield Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
}
@end

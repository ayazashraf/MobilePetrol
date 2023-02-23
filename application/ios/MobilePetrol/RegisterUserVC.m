//
//  RegisterUserVC.m
//  MobilePetrol
//
//  Created by user on 10/14/13.
//  Copyright (c) 2013 foreigntree. All rights reserved.
//

#import "RegisterUserVC.h"

@interface RegisterUserVC ()

@end

@implementation RegisterUserVC

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
    self.txtcellno.delegate = self;
    self.txtcnfrmpass.delegate =self;
    self.txtpassword.delegate =self;
    self.txtemail.delegate = self;
    self.txtfname.delegate =self;
    self.txtlname.delegate = self;
    self.txtusername.delegate =self;
    
 /*   [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    */
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [self.scrollview setContentOffset:CGPointZero animated:YES];
    [self.scrollview setContentSize:CGSizeMake(self.scrollview.contentSize.width, 800)];

}
/*
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];

    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat offset = kbSize.height;
    CGPoint scrollPoint = CGPointMake(0.0, offset);
    [self.scrollview setContentOffset:scrollPoint animated:YES];
    
}
 
 */
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
- (IBAction)registerClicked:(id)sender {
    
    BOOL valid = YES;
    
    if(self.txtusername.text.length<=0||self.txtpassword.text.length<=0||self.txtemail.text.length<=0||self.txtfname.text.length<=0||self.txtlname.text.length<=0||self.txtcellno.text.length<=0)
    {
        valid = NO;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Registration Failed" message:@"Please fill all the fields, All fields are mandatory." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    if(valid)
    {
        valid = [self validateEmailWithString:self.txtemail.text];
        if(!valid)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Registration Failed" message:@"Email Address is invalid." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    if(valid)
    {
        valid = [self.txtpassword.text isEqualToString:self.txtcnfrmpass.text];
        
        if(!valid)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Registration Failed" message:@"Passwords mismatching, Please enter password correctly." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    
    //validations here
    if (valid)
    {
        
        if([self checkInternetConnection])
        {
            NSString *param = [NSString stringWithFormat:@"username=%@&password=%@&email=%@&fname=%@&lname=%@&phoneno=%@",self.txtusername.text,self.txtpassword.text,self.txtemail.text,self.txtfname.text,self.txtlname.text,self.txtcellno.text];
            NSString *url = [NSString stringWithFormat:@"http://www.demo.foreigntree.com/mobilepetrol/api/register_user.php"];
            NSData *temp = [self WebrequestWithParameters:param Url:url AndMethod:@"POST"];
            
            NSError *error = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:temp options:0 error:&error];
            
            if (!error){
                
                if ([[dic objectForKey:@"status"] isEqualToString:@"ok"])
                {
                    
                    NSString *phonebook_id = [dic objectForKey:@"phonebook_id"];
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:phonebook_id forKey:@"phonebook_id"];
                    [defaults synchronize];
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Registration Successful" message:@"Registration is successful, You can now login to use mobile petrol services." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Registration Failed" message:@"Registration is unsuccessful, please try again or use some other username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Registration Failed" message:@"Registration is unsuccessful, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
        
        
    }
    
    
}

- (IBAction)cancelClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma Mark - Textfield Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
   return [textField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
 
  //  CGPoint scrollPoint = CGPointMake(0.0, textField.frame.origin.y+textField.frame.size.height);
   // [self.scrollview setContentOffset:scrollPoint animated:YES];
}

@end

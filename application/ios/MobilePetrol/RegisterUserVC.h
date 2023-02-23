//
//  RegisterUserVC.h
//  MobilePetrol
//
//  Created by user on 10/14/13.
//  Copyright (c) 2013 foreigntree. All rights reserved.
//

#import "MobilePetrolVC.h"

@interface RegisterUserVC : MobilePetrolVC<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtusername;
@property (strong, nonatomic) IBOutlet UITextField *txtfname;
@property (strong, nonatomic) IBOutlet UITextField *txtlname;
@property (strong, nonatomic) IBOutlet UITextField *txtcellno;
@property (strong, nonatomic) IBOutlet UITextField *txtemail;
@property (strong, nonatomic) IBOutlet UITextField *txtpassword;
@property (strong, nonatomic) IBOutlet UITextField *txtcnfrmpass;
- (IBAction)registerClicked:(id)sender;
- (IBAction)cancelClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@end

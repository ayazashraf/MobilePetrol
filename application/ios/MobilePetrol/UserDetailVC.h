//
//  UserDetailVC.h
//  MobilePetrol
//
//  Created by user on 10/14/13.
//  Copyright (c) 2013 foreigntree. All rights reserved.
//

#import "MobilePetrolVC.h"

@interface UserDetailVC : MobilePetrolVC<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtfname;
@property (strong, nonatomic) IBOutlet UITextField *txtlname;
@property (strong, nonatomic) IBOutlet UITextField *txtemail;
@property (strong, nonatomic) IBOutlet UITextField *txtphoneno;

- (IBAction)logoutClicked:(id)sender;
- (IBAction)okClicked:(id)sender;
@end

//
//  LoginUserVC.h
//  MobilePetrol
//
//  Created by user on 10/14/13.
//  Copyright (c) 2013 foreigntree. All rights reserved.
//

#import "MobilePetrolVC.h"

@interface LoginUserVC : MobilePetrolVC<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtusername;
@property (strong, nonatomic) IBOutlet UITextField *txtpassword;
- (IBAction)LoginClicked:(id)sender;
- (IBAction)SignedupClicked:(id)sender;

@end

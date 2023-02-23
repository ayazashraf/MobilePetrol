//
//  RestoreVC.m
//  MobilePetrol
//
//  Created by user on 10/14/13.
//  Copyright (c) 2013 foreigntree. All rights reserved.
//

#import "RestoreVC.h"

@interface RestoreVC ()

@end

@implementation RestoreVC

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

- (IBAction)Contactclicked:(id)sender {
    
   if([self checkInternetConnection])
   {
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] isEqualToString:@"null"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"User is logged out!" message:@"User must be login, before using backup and restore services. Go to Account to login." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [LoadingOverlay addLoadingInView:self.view];
    UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactBackupsVC"];
    [self.navigationController pushViewController:VC animated:YES];
        [LoadingOverlay removeLoadingFromView:self.view];

    }
   }
    else
    {
    
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Network Error!" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    
    }
}

/*
-(void)copyContact
{
    ABAddressBookRef addressBook =ABAddressBookCreateWithOptions(NULL, NULL);
    
    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        // dispatch_release(sema);
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    
    if (accessGranted) {
        
        
        // Do whatever you need with thePeople...
        
        
        
        
        NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [arr objectAtIndex:0];
        CFErrorRef error = NULL;
        path = [path stringByAppendingPathComponent:@"contactList.plist"];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        NSArray *contactList=[[NSArray alloc]initWithArray:[dic objectForKey:@"ContactList"]];
        for(int i=0;i<contactList.count;i++)
        {
            bool flag=false;
            NSDictionary *personInfo=[[NSDictionary alloc]initWithDictionary:[contactList objectAtIndex:i]];
            ABRecordRef person=ABPersonCreate();
            
            CFArrayRef people=(ABAddressBookCopyArrayOfAllPeople(addressBook));
            for(int i=0;i<CFArrayGetCount(people);i++)
            {
                ABRecordRef ref=CFArrayGetValueAtIndex(people, i);
                NSString *persoFNname=(NSString *)CFBridgingRelease(ABRecordCopyValue(ref, kABPersonFirstNameProperty));
                NSString *persoLNname=(NSString *)CFBridgingRelease(ABRecordCopyValue(ref, kABPersonLastNameProperty));
                CFRelease(ref);
                NSString *fname=[personInfo objectForKey:@"FirstName"];
                NSString *lname=[personInfo objectForKey:@"LastName"];
                
                if([fname isEqualToString:persoFNname]&&[lname isEqualToString:persoLNname])
                {
                    flag=false;
                    break;
                }
                else
                    flag=true;
            }
            if(flag==false)
                continue;
            ABRecordSetValue(person, kABPersonFirstNameProperty, CFBridgingRetain([personInfo objectForKey:@"FirstName" ]), &error);
            ABRecordSetValue(person, kABPersonLastNameProperty, CFBridgingRetain([personInfo objectForKey:@"LastName" ]), &error);
            ABRecordSetValue(person, kABPersonOrganizationProperty, CFBridgingRetain([personInfo objectForKey:@"Organization" ]) , &error);
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString *birthdaydate=[personInfo objectForKey:@"birthday" ];
            NSDate *bday;
            bday=[formatter dateFromString:birthdaydate];
            CFDateRef birthday=CFBridgingRetain(bday);
            ABRecordSetValue(person, kABPersonBirthdayProperty, birthday, &error);
            NSArray *phonenumber=[[NSArray alloc]initWithArray:[personInfo objectForKey:@"phonenumbers"]];
            ABMultiValueRef multiPhone=ABMultiValueCreateMutable(kABMultiStringPropertyType);
            for(int i=0;i<phonenumber.count;i++)
            {
                NSDictionary *curr_phonenumber=[[NSDictionary alloc]initWithDictionary:[phonenumber objectAtIndex:i]];
                
                ABMultiValueIdentifier identifier;
                bool didenter;
                NSString *label=[curr_phonenumber objectForKey:@"label"];
                NSString *number=[curr_phonenumber objectForKey:@"number"];
                
                didenter=ABMultiValueAddValueAndLabel(multiPhone,CFBridgingRetain(number), CFBridgingRetain(label),  &identifier);
                
            }
            ABRecordSetValue(person, kABPersonPhoneProperty, multiPhone, &error);
            
            CFRelease(multiPhone);
            NSArray *emailsarr=[[NSArray alloc]initWithArray:[personInfo objectForKey:@"emails"]];
            ABMultiValueRef multiemails=ABMultiValueCreateMutable(kABPersonEmailProperty);
            
            for(int i=0;i<emailsarr.count;i++)
            {
                NSDictionary *curr_phonenumber=[[NSDictionary alloc]initWithDictionary:[emailsarr objectAtIndex:i]];
                
                ABMultiValueIdentifier identifier;
                bool didenter;
                NSString *label=[curr_phonenumber objectForKey:@"label"];
                NSString *id=[curr_phonenumber objectForKey:@"number"];
                
                didenter=ABMultiValueAddValueAndLabel(multiemails, CFBridgingRetain(id),CFBridgingRetain(label),  &identifier);
                
                
            }
            
            ABRecordSetValue(person, kABPersonEmailProperty, multiemails, &error);
            CFRelease(multiemails);
            if (error) {
                NSLog(@"Cannot Save Addressbook");
            }
            NSArray *address=[[NSArray alloc]initWithArray:[personInfo objectForKey:@"address"]];
            NSArray *addresslabel=[[NSArray alloc]initWithArray:[personInfo objectForKey:@"addresslabel"]];
            if (address) {
                
                ABMultiValueRef curr_address=ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
                for(int i=0;i<address.count;i++)
                {
                    ABMultiValueIdentifier identifier;
                    NSString *label=[addresslabel objectAtIndex:i];
                    NSDictionary *tempDict=[[NSDictionary alloc]initWithDictionary:[address objectAtIndex:i]] ;
                    bool didenter= ABMultiValueAddValueAndLabel(curr_address, CFBridgingRetain(tempDict), CFBridgingRetain(label), &identifier);
                    
                }
                ABRecordSetValue(person, kABPersonAddressProperty, curr_address, &error);
                
            }
            ABAddressBookAddRecord(addressBook, person, &error);
        }
        
        ABAddressBookSave(addressBook, &error);
        
        if(error)
            NSLog(@"Cannot Save Addressbook");
    }
}

 */
@end

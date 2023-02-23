//
//  BackupVC.m
//  MobilePetrol
//
//  Created by user on 10/14/13.
//  Copyright (c) 2013 foreigntree. All rights reserved.
//

#import "BackupVC.h"

@interface BackupVC ()

@end

@implementation BackupVC

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
    
    contacts=[[NSMutableArray alloc]init];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)fetchcontactsList
{
    
    [LoadingOverlay addLoadingInView:self.view];
    ABAddressBookRef addressBook=ABAddressBookCreateWithOptions(NULL, NULL);
    switch (ABAddressBookGetAuthorizationStatus())
    {
        case kABAuthorizationStatusNotDetermined:
        {{
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef
                                                                    error) {
                if (granted) {
                    NSLog(@"Access to the Address Book has been granted");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // completion handler can occur in a background thread and this call will update the UI on the main thread
                        [self fetchinfofromContact:ABAddressBookCreateWithOptions(NULL, NULL)];
                    });
                }
                else {
                    NSLog(@"Access to the Address Book has been denied");
                }
            });
            break;
        }
        }
        case kABAuthorizationStatusAuthorized:
        {
            NSLog(@"User has already granted access to the Address Book");
            [self fetchinfofromContact:addressBook];
            break;
        }
        case kABAuthorizationStatusRestricted:
        {
            NSLog(@"User has restricted access to Address Book possibly due to parental controls");
            break;
        }
        case kABAuthorizationStatusDenied:
        {
            NSLog(@"User has denied access to the Address Book");
            break;
        }
    }
    CFRelease(addressBook);
}


-(void)fetchinfofromContact:(ABAddressBookRef)addressBook
{
    [contacts removeAllObjects];
    CFArrayRef people=(ABAddressBookCopyArrayOfAllPeople(addressBook));
    NSInteger pplcount=ABAddressBookGetPersonCount(addressBook);
    //  [contacts addObjectsFromArray:people];
    
    count=pplcount;
    for (int i=0; i<count; i++) {
        ABRecordRef ref=CFArrayGetValueAtIndex(people, i);
        NSMutableDictionary *ContactDetails=[[NSMutableDictionary alloc]init];
        NSString *personName=(NSString *)CFBridgingRelease(ABRecordCopyValue(ref, kABPersonFirstNameProperty));
        [ContactDetails setObject:personName forKey:@"FirstName"];
        personName=(NSString *)CFBridgingRelease(ABRecordCopyValue(ref, kABPersonLastNameProperty));
        [ContactDetails setObject:personName forKey:@"LastName"];
        personName=(NSString *)CFBridgingRelease(ABRecordCopyValue(ref, kABPersonJobTitleProperty));
        if(!personName)
            personName=@"";
        [ContactDetails setObject:personName forKey:@"JobTitle"];
        personName=(NSString *)CFBridgingRelease(ABRecordCopyValue(ref, kABPersonOrganizationProperty));
        if(!personName)
            personName=@"";
        [ContactDetails setObject:personName forKey:@"Organization"];
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSDate *bday=CFBridgingRelease(ABRecordCopyValue(ref, kABPersonBirthdayProperty));
        
        if(!bday)
            personName=@"";
        else
            personName=[formatter stringFromDate:bday];
        
        
        
        [ContactDetails setObject:personName forKey:@"birthday"];
        
        NSMutableArray *phoneNumbers=[[NSMutableArray alloc]init];
        
        ABMultiValueRef phones = ABRecordCopyValue(ref, kABPersonPhoneProperty);
        for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
        {
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
            CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phones, j);
            NSString *phoneLabel =(NSString*) CFBridgingRelease(ABAddressBookCopyLocalizedLabel(locLabel));
            //CFRelease(phones);
            NSString *phoneNumber = (NSString *)CFBridgingRelease(phoneNumberRef);
            CFRelease(phoneNumberRef);
            CFRelease(locLabel);
            NSLog(@"  - %@ (%@)", phoneNumber, phoneLabel);
            NSMutableDictionary *dicT=[[NSMutableDictionary alloc]init];
            [dicT setObject:phoneLabel forKey:@"label"];
            [dicT setObject:phoneNumber forKey:@"number"];
            [phoneNumbers addObject:dicT];
        }
        [ContactDetails setObject:phoneNumbers forKey:@"phonenumbers"];
        
        NSMutableArray *emailsarr=[[NSMutableArray alloc]init];
        
        ABMultiValueRef email = ABRecordCopyValue(ref, kABPersonEmailProperty);
        for(CFIndex j = 0; j < ABMultiValueGetCount(email); j++)
        {
            CFStringRef emailref = ABMultiValueCopyValueAtIndex(email, j);
            CFStringRef emaillocLabel = ABMultiValueCopyLabelAtIndex(email, j);
            NSString *emailLabel =(NSString*) CFBridgingRelease(ABAddressBookCopyLocalizedLabel(emaillocLabel));
            //CFRelease(phones);
            NSString *emailId = (NSString *)CFBridgingRelease(emailref);
            NSMutableDictionary *emails=[[NSMutableDictionary alloc]init];
            [emails setObject:emailLabel forKey:@"label"];
            [emails setObject:emailId forKey:@"number"];
            [emailsarr addObject:emails];
            
        }
        NSMutableArray *addresslabel=[[NSMutableArray alloc]init];
        
        ABMultiValueRef adress = ABRecordCopyValue(ref, kABPersonAddressProperty);
        for(CFIndex j=0;j<ABMultiValueGetCount(adress);j++)
        {
            
            CFStringRef addressloclabel=ABMultiValueCopyLabelAtIndex(adress, j);
            NSString *addressLabel=(NSString *)CFBridgingRelease(ABAddressBookCopyLocalizedLabel(addressloclabel));
            [addresslabel addObject:addressLabel];
        }
        
        NSArray *address=(NSArray *)CFBridgingRelease(ABMultiValueCopyArrayOfAllValues(ABRecordCopyValue(ref, kABPersonAddressProperty)));
        
        
        if(address)
        {
            [ContactDetails setObject:address forKey:@"address"];
            [ContactDetails setObject:addresslabel forKey:@"addresslabel"];
        }
        [ContactDetails setObject:emailsarr forKey:@"emails"];
        
        [contacts addObject:ContactDetails];
    }
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:@"contactList.plist"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    
    
    [dic setObject:contacts forKey:@"ContactList"];
    
    //NSString *test=@"Jason Brody";
    bool success=[dic writeToFile:path atomically:YES];
    if(success)
        NSLog(@"Write To File Successfull");
        
}


- (IBAction)btnContacts:(id)sender {
    
    [LoadingOverlay addLoadingInView:self.view];

    if([self checkInternetConnection])
    {
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] isEqualToString:@"null"])
    {
        
        [LoadingOverlay removeLoadingFromView:self.view];

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"User is logged out!" message:@"User must be login, before using backup and restore services. Go to Account to login." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

        return;
    }
    else
    {
        NSLog(@"pehly");
    [self fetchcontactsList];
    [self UploadRequest];
        NSLog(@"badme");
        [LoadingOverlay removeLoadingFromView:self.view];
    
    }
    }
    else
    {
        
        [LoadingOverlay removeLoadingFromView:self.view];

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Network Error!" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
  
    
}

-(void)UploadRequest{
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:@"contactList.plist"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        
        
    }
    else{
        [LoadingOverlay removeLoadingFromView:self.view];

        //alert upload nahi hosakta becouse file nahi he
        return;
    }
    
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id plist = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    
    NSData *xmlData = [NSPropertyListSerialization dataFromPropertyList:plist
                                                                 format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
    NSString *xml_string = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    
    NSString *tempstr = [NSString stringWithFormat:@"user_id=%@&addressbook=%@",[defaults objectForKey:@"user_id"],xml_string];
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
        NSError *error = nil;
      NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:respdata options:0 error:&error];
        if (!error) {
            if( [[dic objectForKey:@"status"] isEqualToString:@"ok"])
            {
               // [LoadingOverlay removeLoadingFromView:self.view];

                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Backup operation Successful!" message:@"Your contacts has been successfully stored on cloud, you can use this backup in future." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            
            }
            else
            {
                [LoadingOverlay removeLoadingFromView:self.view];

            }
        }
        else
        {
            [LoadingOverlay removeLoadingFromView:self.view];

        }
        
        
    }
    else {
        [LoadingOverlay removeLoadingFromView:self.view];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Network Error!" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"No response received");
    }


}
@end

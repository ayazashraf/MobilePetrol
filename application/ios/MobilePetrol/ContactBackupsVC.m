//
//  ContactBackupsVC.m
//  MobilePetrol
//
//  Created by user on 10/19/13.
//  Copyright (c) 2013 foreigntree. All rights reserved.
//

#import "ContactBackupsVC.h"

@interface ContactBackupsVC ()

@end

@implementation ContactBackupsVC
@synthesize tableview,backupdatetimeArray,backupidArray;

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
    
    [self.tableview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundview.png"]]];
    [self.tableview setDelegate:self];
    [self.tableview setDataSource:self];
    backupidArray =[[NSMutableArray alloc]init];
    backupdatetimeArray =[[NSMutableArray alloc]init];
    
    [self webRequest];
    

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Marks - Tableview Datasource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return backupidArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell  =[tableview dequeueReusableCellWithIdentifier:@"contactcell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contactcell"];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    cell.textLabel.text = [backupdatetimeArray objectAtIndex:indexPath.row];

    NSString *tempdetail =[NSString stringWithFormat:@"%@ %@",[defaults objectForKey:@"userdetail_firstname"], [defaults objectForKey:@"userdetail_lastname"]];
    cell.detailTextLabel.text = tempdetail;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if([self checkInternetConnection])
    {
        [LoadingOverlay addLoadingInView:self.view];

    NSString *param = [NSString stringWithFormat:@"backup_id=%@",[backupidArray objectAtIndex:indexPath.row]];
    NSString *url = [NSString stringWithFormat:@"http://www.demo.foreigntree.com/mobilepetrol/api/get_addressbook.php"];
    NSData *temp = [self WebrequestWithParameters:param Url:url AndMethod:@"GET"];
    
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:temp options:0 error:&error];
    
    if (!error){
        
        if ([[dic objectForKey:@"status"] isEqualToString:@"ok"])
        {
            
            NSString *fileurl = [dic objectForKey:@"fileurl"];
            
            NSURL *url = [[NSURL alloc]initWithString:fileurl];
            [self copyContact:url];
            [LoadingOverlay removeLoadingFromView:self.view];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Operation Successful" message:@"Your contacts has bee successfully restored to this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];

       
        }
        else
        {
            [LoadingOverlay removeLoadingFromView:self.view];

            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login Failed" message:@"Login is unsuccessful, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login Failed" message:@"Login is unsuccessful, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    

    
    [tableview deselectRowAtIndexPath:indexPath animated:YES];
        
        
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Network Error!" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }

}

-(void)copyContact:(NSURL *)url
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
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfURL:url];
        
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

-(void)webRequest
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] isEqualToString:@"null"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"User is logged out!" message:@"User must be login, before using backup and restore services." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
        
    
    NSString *param = [NSString stringWithFormat:@"user_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]];
    NSString *url = [NSString stringWithFormat:@"http://www.demo.foreigntree.com/mobilepetrol/api/get_addressbooks.php"];
    NSData *temp = [self WebrequestWithParameters:param Url:url AndMethod:@"GET"];
    
    NSError *error = nil;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:temp options:0 error:&error];
    
    if (!error){
        
        
        backupidArray =[[NSMutableArray alloc]init];
        backupdatetimeArray =[[NSMutableArray alloc]init];
        
        for (NSDictionary *dic in arr) {
            
            NSString *backup_id = [dic objectForKey:@"backup_id"];
            NSString *backup_datetime = [dic objectForKey:@"backup_datetime"];
            
        [backupidArray addObject:backup_id];
        [backupdatetimeArray addObject:backup_datetime];
        
        }
        if(backupidArray.count<=0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert Message!" message:@"No backup present for contacts on cloud for this user." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        [self.tableview reloadData];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error Message!" message:@"Some error occur while communication, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    


}


@end

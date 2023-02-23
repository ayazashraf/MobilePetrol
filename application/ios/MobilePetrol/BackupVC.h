//
//  BackupVC.h
//  MobilePetrol
//
//  Created by user on 10/14/13.
//  Copyright (c) 2013 foreigntree. All rights reserved.
//

#import "MobilePetrolVC.h"
#import <AddressBook/AddressBook.h>

@interface BackupVC : MobilePetrolVC
{
        int count;
        NSMutableArray *contacts;
}
    
- (IBAction)btnContacts:(id)sender;
-(void) fetchcontactsList;
-(void) fetchinfofromContact:(ABAddressBookRef)addressBook;
@end

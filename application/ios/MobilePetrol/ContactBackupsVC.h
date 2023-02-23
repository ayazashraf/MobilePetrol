//
//  ContactBackupsVC.h
//  MobilePetrol
//
//  Created by user on 10/19/13.
//  Copyright (c) 2013 foreigntree. All rights reserved.
//

#import "MobilePetrolVC.h"
#import <AddressBook/AddressBook.h>

@interface ContactBackupsVC : MobilePetrolVC<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *backupidArray;
@property (nonatomic,strong)NSMutableArray *backupdatetimeArray;

-(void)copyContact:(NSURL *)url;
@end

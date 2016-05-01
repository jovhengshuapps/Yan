//
//  DrawerTableViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 3/31/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "DrawerTableViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"


@interface DrawerTableViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation DrawerTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:0.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8.0f, 28.0f, 190.0f, 184.0f)];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20.0f, 20.0f, view.frame.size.width, view.frame.size.height - 44.0f);
        [button setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [button setContentMode:UIViewContentModeTopLeft];
        [button addTarget:self.frostedViewController action:@selector(hideMenuViewController) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        
        UIView *bottomBorderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, view.frame.size.height - 2.0f, view.frame.size.width, 1.0f)];
        bottomBorderView.backgroundColor = UIColorFromRGB(0x898989);
        [view addSubview:bottomBorderView];
        
        [view addSubview:button];
    
        view;
    });

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    _titlesArray = @[([self userLoggedIn])?@"LOGOUT":@"LOGIN",
                     @"SETTINGS",
                     @"FAVORITES",
                     @"RECENT"];
    
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    UIView *bottomBorderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, cell.contentView.frame.size.height - 1.0f, cell.contentView.frame.size.width, 1.0f)];
    bottomBorderView.backgroundColor = UIColorFromRGB(0x898989);
    [cell.contentView addSubview:bottomBorderView];
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.frostedViewController hideMenuViewController];
    
    if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"LOGIN"]) {
        [self.frostedViewController.contentViewController performSegueWithIdentifier:@"showLogin" sender:self];
    }
    else if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"LOGOUT"]) {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Logout"] message:@"Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Account"];
            
            NSError *error = nil;
            
            NSArray *result = [context executeFetchRequest:request error:&error];
            
            
            for (Account *account in result) {
                [context deleteObject:account];
            }
            
            error = nil;
            if ([context save:&error]) {
                //            [[GIDSignIn sharedInstance] signOut];
                //            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
                //            [login logOut];
                return;
            }
        }];
        [alert addAction:actionNO];
        [alert addAction:actionYES];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return _titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:[_titlesArray objectAtIndex:indexPath.row] attributes:TextAttributes(@"LucidaGrande", 0x333333, 20.0f)];
    
    return cell;
}



- (Account*) userLoggedIn {
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Account"];
    
    NSError *error = nil;
    
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (result.count) {
        return ((Account*)result[0]);
    }
    
    return nil;
    
}

@end
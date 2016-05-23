//
//  ShareTableViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 10/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "ShareTableViewController.h"

@interface ShareTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelTableNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelRestaurant;

@end

@implementation ShareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.labelRestaurant.text = [NSString stringWithFormat:@"at %@",_restaurant];
    self.labelTableNumber.text = _tableNumber;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:@"POST ON FACEBOOK"];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)postOnFacebook:(id)sender {
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        // TODO: publish content.
        
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentDescription = [NSString stringWithFormat:@"We are at table %@ at %@",_tableNumber, _restaurant];
        content.contentTitle = @"Share a Table";
        content.contentURL = [NSURL URLWithString:_restaurantURL];//[NSURL URLWithString:@"http://yan.bilinear.ph"];
        
        //    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
        //    dialog.fromViewController = self;
        //    dialog.shareContent = content;
        //    dialog.mode = FBSDKShareDialogModeShareSheet;
        //    [dialog show];
        //
        
        FBSDKShareAPI *share = [FBSDKShareAPI shareWithContent:content delegate:self];
        [share share];
    } else {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        loginManager.loginBehavior = FBSDKLoginBehaviorWeb;
        [loginManager logInWithPublishPermissions:@[@"publish_actions"]
                               fromViewController:self
                                          handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                              //TODO: process error or result.
                                          }];
    }

    
}
- (IBAction)cancelPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    
}


@end

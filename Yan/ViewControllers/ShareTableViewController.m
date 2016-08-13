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
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBox;

@end

@implementation ShareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.labelRestaurant.text = [NSString stringWithFormat:@"at %@",_restaurant];
    self.labelTableNumber.text = @"";
    self.imageViewBox.image = self.imageLogo;
    self.imageViewBox.contentMode = UIViewContentModeScaleAspectFit;
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
        content.contentDescription = [NSString stringWithFormat:@"We are dining at %@.\n\n Join us! Download Yan! now.", _restaurant];
        content.contentTitle = @"Yan!";
        content.contentURL = [NSURL URLWithString:_restaurantURL];
        content.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,_imageLogoURL]];
        
            FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
           dialog.fromViewController = self;
            dialog.shareContent = content;
        dialog.delegate = self;
           dialog.mode = FBSDKShareDialogModeFeedWeb;
            [dialog show];
        
        
//        FBSDKShareAPI *share = [FBSDKShareAPI shareWithContent:content delegate:self];
//        [share share];
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
    
    AlertView *alert = [[AlertView alloc] initAlertWithMessage:@"Successfully shared restaurant on Facebook." delegate:self buttons:nil];
//    [alert showAlertView];
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    
    AlertView *alert = [[AlertView alloc] initAlertWithMessage:@"Failed to shared restaurant on Facebook." delegate:self buttons:nil];
//    [alert showAlertView];
}


@end

//
//  MainLoginViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/7/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "MainLoginViewController.h"

@interface  MainLoginViewController ()

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccount *facebookAccount;
@property (assign, nonatomic) BOOL isFacebookAvailable;

@end

@implementation MainLoginViewController

-(IBAction)facebook:(id)sender {
    
}



//-(IBAction)facebook:(id)sender {
//    _accountStore = [[ACAccountStore alloc]init];
//    ACAccountType *FBaccountType= [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
//    
//    NSString *key = @"451805654875339";
//    NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:key,ACFacebookAppIdKey,@[@"email"],ACFacebookPermissionsKey, nil];
//    
//    [self.accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB completion:
//     ^(BOOL granted, NSError *e) {
//         if (granted)
//         {
//             NSArray *accounts = [self.accountStore accountsWithAccountType:FBaccountType];
//             //it will always be the last object with single sign on
//             _facebookAccount = [accounts lastObject];
//             
//             
//             ACAccountCredential *facebookCredential = [self.facebookAccount credential];
//             NSString *accessToken = [facebookCredential oauthToken];
//             NSLog(@"Facebook Access Token: %@", accessToken);
//             
//             
//             NSLog(@"facebook account =%@",self.facebookAccount);
//             
//             [self get];
//             
//             _isFacebookAvailable = YES;
//         } else
//         {
//             //Fail gracefully...
//             NSLog(@"error getting permission yupeeeeeee %@",e);
//             sleep(10);
//             NSLog(@"awake from sleep");
//             _isFacebookAvailable = NO;
//             
//         }
//     }];
//    
//    
//    
//}
//
//-(void)checkfacebookstatus
//{
//    if (!_isFacebookAvailable)
//    {
////        [self checkFacebook];
//        _isFacebookAvailable = YES;
//    }
//    else
//    {
//        printf("Get out from our game");
//    }
//}
//
//
//-(void)get
//{
//    
//    NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
//    
//    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:requestURL parameters:nil];
//    request.account = self.facebookAccount;
//    
//    [request performRequestWithHandler:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
//        
//        if(!error)
//        {
//            
//            NSDictionary *list =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//            
//            NSLog(@"Dictionary contains: %@", list );
//            
//            
//            
//            
////            self.globalmailID   = [NSString stringWithFormat:@"%@",[list objectForKey:@"email"]];
////            NSLog(@"global mail ID : %@",globalmailID);
//            
//            
//            NSString *fbname = [NSString stringWithFormat:@"%@",[list objectForKey:@"name"]];
//            NSLog(@"faceboooookkkk name %@",fbname);
//            
//            
//            
//            
//            if([list objectForKey:@"error"]!=nil)
//            {
//                [self attemptRenewCredentials];
//            }
//            dispatch_async(dispatch_get_main_queue(),^{
//                
//            });
//        }
//        else
//        {
//            //handle error gracefully
//            NSLog(@"error from get%@",error);
//            //attempt to revalidate credentials
//        }
//        
//    }];
//    
//    self.accountStore = [[ACAccountStore alloc]init];
//    ACAccountType *FBaccountType= [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
//    
//    NSString *key = @"451805654875339";
//    NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:key,ACFacebookAppIdKey,@[@"friends_videos"],ACFacebookPermissionsKey, nil];
//    
//    
//    [self.accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB completion:
//     ^(BOOL granted, NSError *e) {}];
//    
//}
//
//
//
//
//-(void)accountChanged:(NSNotification *)notification
//{
//    [self attemptRenewCredentials];
//}
//
//-(void)attemptRenewCredentials
//{
//    [self.accountStore renewCredentialsForAccount:(ACAccount *)self.facebookAccount completion:^(ACAccountCredentialRenewResult renewResult, NSError *error){
//        if(!error)
//        {
//            switch (renewResult) {
//                case ACAccountCredentialRenewResultRenewed:
//                    NSLog(@"Good to go");
//                    [self get];
//                    break;
//                case ACAccountCredentialRenewResultRejected:
//                    NSLog(@"User declined permission");
//                    break;
//                case ACAccountCredentialRenewResultFailed:
//                    NSLog(@"non-user-initiated cancel, you may attempt to retry");
//                    break;
//                default:
//                    break;
//            }
//            
//        }
//        else{
//            //handle error gracefully
//            NSLog(@"error from renew credentials%@",error);
//        }
//    }];
//}

@end

//
//  CoreViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 3/31/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"

@interface CoreViewController ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *titleBarView;

@end

@implementation CoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.title = @"Yan";
    
    //Setup Title Bar
    _titleBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.bounds.size.width, self.navigationController.navigationBar.frame.size.height)];
    _titleBarView.backgroundColor = UIColorFromRGB(0x333333);
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _titleBarView.frame.size.width, _titleBarView.frame.size.height)];
    
    _titleLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:@"..." attributes:TextAttributes(@"LucidaGrande", (0xFFFFFF), 24.0f)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleBarView addSubview:_titleLabel];
    [self.navigationController.navigationBar addSubview:_titleBarView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self hideTitleBar];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void) showTitleBar:(NSString*)title {
    _titleBarView.hidden = NO;
    _titleLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:title attributes:TextAttributes(@"LucidaGrande", (0xFFFFFF), 24.0f)];
}

- (void) hideTitleBar {
    _titleBarView.hidden = YES;
}

-(void) openMenu {
    
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
    
}

- (BOOL) userLoggedIn {
    // This should return the user details not just a boolean
    return NO;
}
@end

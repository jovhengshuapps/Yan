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

@end

@implementation CoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.title = @"Yan";
    
    //Setup Title Bar
    UIView *titleBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.bounds.size.width, self.navigationController.navigationBar.frame.size.height)];
    titleBarView.backgroundColor = UIColorFromRGB(0x333333);
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleBarView.frame.size.width, titleBarView.frame.size.height)];
    
    _titleLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:@"..." attributes:TextAttributes(@"LucidaGrande", (0xFFFFFF), 24.0f)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleBarView addSubview:_titleLabel];
    [self.navigationController.navigationBar addSubview:titleBarView];
    
    
    
    UIBarButtonItem *menuBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"app-menu.png"] style:UIBarButtonItemStyleDone target:self action:@selector(openMenu)];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Yan"];
    [item setLeftBarButtonItem:menuBarItem];
    
    [self.navigationController.navigationBar setItems:[NSArray arrayWithObjects:item, nil] animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _titleLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:title attributes:TextAttributes(@"LucidaGrande", (0xFFFFFF), 24.0f)];
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
@end

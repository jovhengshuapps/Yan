//
//  TableNumberViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 08/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "TableNumberViewController.h"

@interface TableNumberViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelNumber;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIStepper *stepperControl;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation TableNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.labelNumber.text = _tableNumber;
    
    self.stepperControl.value = [_tableNumber doubleValue];
    
    UITapGestureRecognizer *tapClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeViewAndSetNumber)];
    tapClose.numberOfTapsRequired = 1;
    tapClose.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapClose];
    
    UIPanGestureRecognizer *panView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.containerView addGestureRecognizer:panView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) closeViewAndSetNumber {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate setTableNumber:self.labelNumber.text];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)stepperIsPressed:(id)sender {
    self.labelNumber.text = [NSString stringWithFormat:@"%.0f",_stepperControl.value];
}

-(void)handlePan:(UIPanGestureRecognizer *)gesture {
    
    
    UIView *viewToDrag = _containerView;

    CGPoint translation = [gesture translationInView:viewToDrag.superview]; // get the movement delta
    
    CGRect movedFrame = CGRectOffset(viewToDrag.frame, translation.x, translation.y); // this is the new (moved) frame
    
    CGRect yourPermissibleMargin = CGRectMake(10.0f, 50.0f, self.view.bounds.size.width - 20.0f, self.view.bounds.size.height - 100.0f);
    if (CGRectContainsRect(yourPermissibleMargin, movedFrame)) {
        CGPoint newCenter = CGPointMake(CGRectGetMidX(movedFrame), CGRectGetMidY(movedFrame));
        viewToDrag.center = newCenter; // Move your view
    }
    
    if (viewToDrag.center.y < self.view.bounds.size.height - 200.0f) {
        [self closeViewAndSetNumber];
    }
}

@end

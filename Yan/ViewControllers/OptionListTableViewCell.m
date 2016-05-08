//
//  OptionListTableViewCell.m
//  Yan
//
//  Created by Joshua Jose Pecson on 05/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "OptionListTableViewCell.h"
#import "Config.h"

@interface OptionListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonChoices;
@property (strong, nonatomic) CustomPickerViewController *detailController;
@end

@implementation OptionListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _labelTitle.text = _optionLabel;
    [_buttonChoices setTitle:_optionChoices[0] forState:UIControlStateNormal];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buttonChoicesPressed:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                 bundle:nil];
    _detailController = (CustomPickerViewController *)[storyboard instantiateViewControllerWithIdentifier:@"pickerView"];
    _detailController.delegatePicker = self;
    _detailController.choices = @[];
    
    _detailController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _detailController.modalPresentationStyle = UIModalPresentationPopover;
    _detailController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionLeft;
    
    [_detailController presentViewController:_detailController animated:YES completion:^{
        
    }];
    
//    _popoverController = [[UIPopoverController alloc] initWithContentViewController:detailController];
//    
//    _popoverController.popoverContentSize = KEYWINDOW.bounds.size;
//    UIButton *button = (UIButton*)sender;
//    [self.popoverController presentPopoverFromRect:button.bounds inView:self.contentView
//                          permittedArrowDirections:UIPopoverArrowDirectionAny
//                                          animated:YES];
//    
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    if ([segue.identifier isEqualToString:@"displayPickerChoices"]) {
//        _picker = (CustomPickerViewController *)segue.destinationViewController;
//        _picker.delegatePicker = self;
//        _picker.choices = @[];
//        
//        // This is the important part
//        UIPopoverPresentationController *popPC = _picker.popoverPresentationController;
//        popPC.delegate = self;
//    }
//}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (void)selectedItem:(NSString *)item {
    
    [_detailController dismissViewControllerAnimated:YES completion:^{
        [_buttonChoices setTitle:item forState:UIControlStateNormal];
    }];
}

@end

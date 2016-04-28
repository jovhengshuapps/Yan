//
//  MenuListViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 26/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "MenuListViewController.h"

@interface MenuListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *menuListTable;

@end

@implementation MenuListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.menuListTable reloadData];
    
    self.menuListTable.contentSize = CGSizeMake(self.menuListTable.contentSize.width, self.menuListTable.contentSize.height + 110.0f); //allowance for the menu and checkout
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

# pragma mark Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"menuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [detailButton addTarget:self action:@selector(detailButtonTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [detailButton setImage:[UIImage imageNamed:@"plus-icon-resized"] forState:UIControlStateNormal];
        [detailButton setFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        cell.accessoryView = detailButton;
    }
    
    NSDictionary *item = _menuList[indexPath.row];
    NSString *text = [NSString stringWithFormat:@"%@ PHP%@",[item[@"name"] uppercaseString],item[@"price"]];
    
    CGFloat nameSize = [self tableView:tableView heightForRowAtIndexPath:indexPath] - 20.0f;
    CGFloat priceSize = nameSize / 2.0f;
    
    NSArray *components = [text componentsSeparatedByString:@" PHP"];
    NSRange nameRange = [text rangeOfString:[components objectAtIndex:0]];
    NSRange priceRange = [text rangeOfString:[components objectAtIndex:1]];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attrString beginEditing];
    [attrString addAttribute: NSFontAttributeName
                       value:[UIFont fontWithName:@"LucidaGrande" size:nameSize]
                       range:nameRange];
    
    [attrString addAttribute: NSFontAttributeName
                       value:[UIFont fontWithName:@"LucidaGrande" size:priceSize]
                       range:priceRange];
    
    [attrString endEditing];
    
    cell.textLabel.attributedText = attrString;
    
    return cell;
}

- (void) detailButtonTapped: (UIControl *) button withEvent: (UIEvent *) event
{
    NSIndexPath * indexPath = [_menuListTable indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: _menuListTable]];
    if ( indexPath == nil )
        return;
    
    [_menuListTable.delegate tableView: _menuListTable accessoryButtonTappedForRowWithIndexPath: indexPath];
}

# pragma mark Delegate
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    //add to order list
    
    NSLog(@"accessory:[%li / %li]",(long)indexPath.section, (long)indexPath.row);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //open menu detail
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.delegate selectedItem:_menuList[indexPath.row]];
    
    
}
@end

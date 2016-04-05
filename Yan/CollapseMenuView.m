//
//  CollapseMenuView.m
//  Yan
//
//  Created by IOS Developer on 05/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CollapseMenuView.h"
#import "Config.h"

@interface CollapseMenuView ()


@property (strong, nonatomic) UIView *topBar;
@property (strong, nonatomic) UITableView *menuTableView;
@property (strong, nonatomic) UIView *parentView;
@property (strong, nonatomic) UIView *viewBackground;
@property (assign, nonatomic) CGFloat positionYShown;
@property (assign, nonatomic) CGFloat positionYHidden;
@property (assign, nonatomic) CGFloat sizeHeightShown;
@property (assign, nonatomic) CGFloat sizeHeightHidden;

@end

@implementation CollapseMenuView

- (instancetype) initWithPosition:(CollapseMenuViewPosition) position{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _delegate = nil;
    _arrayContent = @[];
        
    _sectionHeaders = @[];
    
    _position = position;
    _cellHeight = 44.0f;
    
    _positionYHidden = KEYWINDOW.bounds.size.height - _cellHeight;
    _positionYShown = 30.0f + 44.0f;
    
    _sizeHeightHidden = _cellHeight;
    _sizeHeightShown = KEYWINDOW.bounds.size.height - _positionYShown;
    
    self.frame = CGRectMake(10.0f, _positionYHidden, KEYWINDOW.bounds.size.width - 20.0f, _sizeHeightHidden);
    
    self.backgroundColor = [UIColor clearColor];
    
    [self setupTable];
    
    return self;
}

- (void) setupTable {
    
    _topBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, _cellHeight)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor colorWithWhite:0.3f alpha:0.3f]];
    [button addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Main Menu" forState:UIControlStateNormal];
    
    [button setFrame:_topBar.frame];
    [_topBar addSubview:button];
    
    _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, _topBar.frame.size.height, self.frame.size.width, self.frame.size.height - _topBar.bounds.size.height) style:UITableViewStylePlain];
    
    _menuTableView.delegate = self;
    _menuTableView.dataSource = self;
    _menuTableView.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.3f];
    
    [self addSubview:_topBar];
    [self addSubview:_menuTableView];
    
    
}

- (void) showMenu {
    
    _viewBackground = [[UIView alloc] initWithFrame:KEYWINDOW.bounds];
    _viewBackground.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.1f];
    _viewBackground.alpha = 0.0f;
    [_parentView addSubview:_viewBackground];
    
    
    [UIView animateWithDuration:0.3f animations:^{
        _viewBackground.alpha = 1.0f;
        
        CGRect frame = self.frame;
        frame.origin.y = _positionYShown;
        frame.size.height = _sizeHeightShown;
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [_menuTableView reloadData];
    }];
}

- (void) hideMenu {
    [UIView animateWithDuration:0.3f animations:^{
        _viewBackground.alpha = 0.0f;
        
        CGRect frame = self.frame;
        frame.origin.y = _positionYHidden;
        frame.size.height = _sizeHeightHidden;
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        [_viewBackground removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    _parentView = newSuperview;
}


#pragma mark UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrayContent.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = (NSString*)[self.arrayContent[(NSUInteger)section] allKeys][(NSUInteger)section];
    NSArray *subSections = [self.arrayContent[(NSUInteger) section] objectForKey:key];
    
    NSUInteger numberOfRows = subSections.count; // For second level section headers
    NSLog(@"111111numberOfRows:%lu",(unsigned long)numberOfRows);
    for (NSInteger i = 0; i < numberOfRows; i++) {
        NSString *subSectionKey = (NSString*)[subSections[i] allKeys][i];
        NSArray *rows = [subSections[i] objectForKey:subSectionKey];
        numberOfRows += rows.count; // For actual table rows
        
        NSLog(@"22222222numberOfRows:%lu",(unsigned long)numberOfRows);
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *sectionItems = self.arrayContent[(NSUInteger) indexPath.section];
    NSMutableArray *sectionHeaders = self.sectionHeaders[(NSUInteger) indexPath.section];
    NSIndexPath *itemAndSubsectionIndex = [self computeItemAndSubsectionIndexForIndexPath:indexPath];
    NSUInteger subsectionIndex = (NSUInteger) itemAndSubsectionIndex.section;
    NSInteger itemIndex = itemAndSubsectionIndex.row;
    
    if (itemIndex < 0) {
        // Section header
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SECTION_HEADER_CELL" forIndexPath:indexPath];
        cell.textLabel.text = sectionHeaders[subsectionIndex];
        return cell;
    } else {
        // Row Item
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ROW_CONTENT_CELL" forIndexPath:indexPath];
        cell.textLabel.text = sectionItems[subsectionIndex][itemIndex];
        return cell;
    }
}

- (NSIndexPath *)computeItemAndSubsectionIndexForIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *sectionItems = self.arrayContent[(NSUInteger) indexPath.section];
    NSInteger itemIndex = indexPath.row;
    NSUInteger subsectionIndex = 0;
    for (NSUInteger i = 0; i < sectionItems.count; ++i) {
        // First row for each section item is header
        --itemIndex;
        // Check if the item index is within this subsection's items
        NSArray *subsectionItems = sectionItems[i];
        if (itemIndex < (NSInteger) subsectionItems.count) {
            subsectionIndex = i;
            break;
        } else {
            itemIndex -= subsectionItems.count;
        }
    }
    return [NSIndexPath indexPathForRow:itemIndex inSection:subsectionIndex];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.arrayContent[(NSUInteger)section] allKeys][(NSUInteger)section];
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

@end

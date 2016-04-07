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
@property (strong, nonatomic) UIButton *topBarButton;
@property (strong, nonatomic) UITableView *menuTableView;
@property (strong, nonatomic) UIView *parentView;
@property (strong, nonatomic) UIView *viewBackground;
@property (assign, nonatomic) CGFloat positionYShown;
@property (assign, nonatomic) CGFloat positionYHidden;
@property (assign, nonatomic) CGFloat sizeHeightShown;
@property (assign, nonatomic) CGFloat sizeHeightHidden;
@property (strong, nonatomic) NSMutableDictionary *subSections;
@property (strong, nonatomic) NSMutableDictionary *sectionRows;
@property (strong, nonatomic) NSMutableDictionary *subSectionsItems;
@property (strong, nonatomic) NSMutableDictionary *expandedSectionRows;
@property (strong, nonatomic) NSMutableDictionary *collapsedSectionRows;

@end

@implementation CollapseMenuView

- (instancetype) initWithPosition:(CollapseMenuViewPosition) position{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _delegate = nil;
    _content = @{};
    
    _subSections = [NSMutableDictionary new];
    _sectionRows = [NSMutableDictionary new];
    _subSectionsItems = [NSMutableDictionary new];
    
    // section has key "section" and rows have "rows"
    _expandedSectionRows = [NSMutableDictionary new];
    _collapsedSectionRows = [NSMutableDictionary new];
    
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

- (void)willMoveToSuperview:(UIView *)newSuperview {
    _parentView = newSuperview;

}

- (void) setupTable {
    
    _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 0.0f) style:UITableViewStylePlain];
    
    _menuTableView.delegate = self;
    _menuTableView.dataSource = self;
    _menuTableView.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.3f];
    
    
    _topBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, _cellHeight)];
    
    _topBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topBarButton setBackgroundColor:[UIColor colorWithWhite:0.3f alpha:0.3f]];
    [_topBarButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [_topBarButton setTitle:@"MAIN MENU" forState:UIControlStateNormal];
    
    [_topBarButton setFrame:_topBar.frame];
    [_topBar addSubview:_topBarButton];
    
    
    [self addSubview:_topBar];
    [self addSubview:_menuTableView];
    
    
}

- (void) showMenu {
    
    _viewBackground = [[UIView alloc] initWithFrame:KEYWINDOW.bounds];
    _viewBackground.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.1f];
    _viewBackground.alpha = 0.0f;
    [_parentView addSubview:_viewBackground];
    
    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenu)];
    [_viewBackground addGestureRecognizer:tapBackground];
    
    [UIView animateWithDuration:0.2f animations:^{
        _viewBackground.alpha = 1.0f;
        
        CGRect frame = self.frame;
        frame.origin.y = _positionYShown;
        frame.size.height = _sizeHeightShown;
        self.frame = frame;
        
        frame = _menuTableView.frame;
        frame.size.height = _sizeHeightShown - _topBar.frame.size.height;
        _menuTableView.frame = frame;
        
        frame = _topBar.frame;
        frame.origin.y = _sizeHeightShown - _topBar.frame.size.height;
        _topBar.frame = frame;
        
    } completion:^(BOOL finished) {
        [self.delegate collapsedMenuShown:YES];
        [_topBarButton addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
        [_menuTableView reloadData];
    }];
}

- (void) hideMenu {
    
    
    [UIView animateWithDuration:0.2f animations:^{
        _viewBackground.alpha = 0.0f;
        
        CGRect frame = self.frame;
        frame.origin.y = _positionYHidden;
        frame.size.height = _sizeHeightHidden;
        self.frame = frame;
        
        frame = _menuTableView.frame;
        frame.size.height = 0.0f;
        _menuTableView.frame = frame;
        
        frame = _topBar.frame;
        frame.origin.y = 0.0f;
        _topBar.frame = frame;
        
    } completion:^(BOOL finished) {
        [self.delegate collapsedMenuShown:NO];
        [_topBarButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
        [_viewBackground removeFromSuperview];
    }];
}

- (void) showSection:(UIButton*)button {
    
}

#pragma mark UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.content allKeys].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSUInteger numberOfRows = 0;
    NSString *key = (NSString*)[self.content allKeys][(NSUInteger)section];
    if ([[self.content objectForKey:key] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *subSections = (NSDictionary*)[self.content objectForKey:key];
        [_subSections setObject:[subSections allKeys] forKey:key];
        
        numberOfRows = [subSections allKeys].count; // For second level section headers
        NSUInteger sectionIndex = 0;
        NSMutableArray *tempArray = [NSMutableArray new];
        for (NSInteger i = 0; i < [subSections allKeys].count; i++) {
            NSString *subSectionKey = (NSString*)[subSections allKeys][i];
            NSArray *rows = [subSections objectForKey:subSectionKey];
            [_subSectionsItems setObject:rows forKey:subSectionKey];
            [tempArray addObject:subSectionKey];
            [tempArray addObjectsFromArray:rows];
            sectionIndex = rows.count;
            numberOfRows += rows.count; // For actual table rows
            
        }
        [_sectionRows setObject:tempArray forKey:key];
    }
    else if ([[self.content objectForKey:key] isKindOfClass:[NSArray class]]) {
        numberOfRows = ((NSArray*)[self.content objectForKey:key]).count;
    }
    
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *key = (NSString*)[self.content allKeys][(NSUInteger)indexPath.section];
    if ([[self.content objectForKey:key] isKindOfClass:[NSArray class]]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ROW_CONTENT_CELL"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ROW_CONTENT_CELL"];
        }
        cell.textLabel.text = ((NSArray*)[self.content objectForKey:key])[indexPath.row];
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.1f];
        return cell;
    }
    else if ([[self.content objectForKey:key] isKindOfClass:[NSDictionary class]]) {
        BOOL isSubSection = NO;
        if ([[_subSections objectForKey:key] containsObject:[_sectionRows objectForKey:key][indexPath.row]]) {
            isSubSection = YES;
        }
        
        if (isSubSection) {
            // Section header
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SECTION_HEADER_CELL"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SECTION_HEADER_CELL"];
            }
            cell.textLabel.text = [_sectionRows objectForKey:key][indexPath.row];
            cell.contentView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.1f];
            return cell;
        } else {
            // Row Item
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ROW_CONTENT_CELL"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ROW_CONTENT_CELL"];
            }
            cell.textLabel.text = [_sectionRows objectForKey:key][indexPath.row];
            cell.contentView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.1f];
            return cell;
        }
    }
    
    return nil;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (NSString*)[self.content allKeys][(NSUInteger)section];
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = (NSString*)[self.content allKeys][(NSUInteger)indexPath.section];
    
    if ([[self.content objectForKey:key] isKindOfClass:[NSDictionary class]]) {
        BOOL isSubSection = NO;
        if ([[_subSections objectForKey:key] containsObject:[_sectionRows objectForKey:key][indexPath.row]]) {
            isSubSection = YES;
        }
        
        if (isSubSection) {
            // Section header
            return 1;
        } else {
            // Row Item
            return 2;
        }
    }
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = (NSString*)[self.content allKeys][(NSUInteger)indexPath.section];
    BOOL isSubSection = NO;
    if ([[_subSections objectForKey:key] containsObject:[_sectionRows objectForKey:key][indexPath.row]]) {
        isSubSection = YES;
    }
    
    if (isSubSection) {
        // Section header
//        return 1;
    } else {
        // Row Item
//        return 2;
    }
    return _cellHeight;
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.delegate selectedIndex:indexPath.row];
}

#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = 40;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
}



@end

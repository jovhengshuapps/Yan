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
@property (strong, nonatomic) UIView *viewBackground;
@property (assign, nonatomic) CGFloat positionYShown;
@property (assign, nonatomic) CGFloat positionYHidden;
@property (assign, nonatomic) CGFloat sizeHeightShown;
@property (assign, nonatomic) CGFloat sizeHeightHidden;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSMutableArray *expandedSectionRows;
@property (strong, nonatomic) NSMutableArray *collapsedSectionRows;
@property (assign, nonatomic) CGFloat cellHeight;

@end

@implementation CollapseMenuView


- (instancetype) initWithContent:(NSDictionary*)datasource screenSize:(CGSize)screenSize {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    
    _delegate = nil;
    _content = @{};
    
    _expandedSectionRows = [NSMutableArray new];
    _collapsedSectionRows = [NSMutableArray new];
    
    
    _cellHeight = 44.0f;
    
    _positionYHidden = screenSize.height - _cellHeight;
    
    _positionYShown = screenSize.height - _cellHeight;
    
    _sizeHeightHidden = _cellHeight;
    _sizeHeightShown = screenSize.height - _positionYShown;
    
    
    self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    
    
    _content = nil;
    _content = [NSDictionary dictionaryWithDictionary:datasource];
    
    _sections = [NSArray arrayWithArray:[_content allKeys]];
    [_collapsedSectionRows setArray:_sections];
    
    _positionYShown -= (_cellHeight * _collapsedSectionRows.count);
    
    _sizeHeightShown = screenSize.height - _positionYShown;
    
    self.frame = CGRectMake(0.0f, _positionYShown, screenSize.width, _sizeHeightShown);
    
    [self setupTable];
    [_menuTableView reloadData];
    
    return self;
}

- (void) setupTable {
    
    _topBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, _cellHeight)];
    
    _topBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topBarButton setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
    [_topBarButton addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
    [_topBarButton setTitle:@"MAIN MENU" forState:UIControlStateNormal];
    [_topBarButton setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [_topBarButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateHighlighted];
    
    _topBarButton.titleLabel.font = [UIFont fontWithName:@"LucidaGrande" size:_cellHeight/3.0f];
    
    _topBarButton.layer.borderColor = UIColorFromRGB(0xFFFFFF).CGColor;
    _topBarButton.layer.borderWidth = 1.0f;
    
    [_topBarButton setFrame:_topBar.frame];
    [_topBar addSubview:_topBarButton];
    
    [self addSubview:_topBar];
    
    _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, _topBar.bounds.size.height, self.frame.size.width, _sizeHeightShown - _topBar.frame.size.height) style:UITableViewStylePlain];
    
    _menuTableView.delegate = self;
    _menuTableView.dataSource = self;
    _menuTableView.backgroundColor = [UIColor clearColor];
    _menuTableView.bounces = NO;
    
    [self addSubview:_menuTableView];
    
    
}

- (void) showMenu {
    
//    NSLog(@"showMenu[%lu / %lu]",(unsigned long)_collapsedSectionRows.count,(unsigned long)_expandedSectionRows.count);
    
    [UIView animateWithDuration:0.2f animations:^{
        
        
        CGRect frame = self.frame;
        frame.origin.y = _positionYShown;
        frame.size.height = _sizeHeightShown;
        self.frame = frame;
        
        frame = _topBar.frame;
        frame.origin.y = 0.0f;
        _topBar.frame = frame;
        
        frame = _menuTableView.frame;
        frame.origin.y = _topBar.frame.size.height;
        frame.size.height = _sizeHeightShown - _topBar.frame.size.height;
        _menuTableView.frame = frame;
        
        
    } completion:^(BOOL finished) {
//        NSLog(@"completed SHOW");
        [self.delegate collapsedMenuShown:YES];
        [_topBarButton addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
        [_menuTableView reloadData];
    }];
    
}

- (void) hideMenu {
    
//    NSLog(@"hideMenu[%lu / %lu]",(unsigned long)_collapsedSectionRows.count,(unsigned long)_expandedSectionRows.count);
    
    [UIView animateWithDuration:0.2f animations:^{
        if ([_expandedSectionRows count] == 0) {
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
            [self.delegate collapsedMenuShown:NO];
        }
        else {
            
            CGRect frame = self.frame;
            frame.origin.y = _positionYShown;
            frame.size.height = _sizeHeightShown;
            self.frame = frame;
            
            frame = _topBar.frame;
            frame.origin.y = 0.0f;
            _topBar.frame = frame;
            
            frame = _menuTableView.frame;
            frame.origin.y = _topBar.frame.size.height;
            frame.size.height = _sizeHeightShown - _topBar.frame.size.height;
            _menuTableView.frame = frame;
            [_expandedSectionRows removeAllObjects];
            [_collapsedSectionRows setArray:_sections];
        }
        
    } completion:^(BOOL finished) {
        
        
//        NSLog(@"completed HIDE");
        if ([_expandedSectionRows count] == 0) {
            [_topBarButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            [_topBarButton addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
        }
        [_menuTableView reloadData];

    }];
}

- (void) showSection:(UIButton*)button {
    NSInteger section = button.tag;

    NSString *selectedSection = _sections[section];
    
    while ([_collapsedSectionRows containsObject:selectedSection]) {
        [_collapsedSectionRows removeObjectIdenticalTo:selectedSection];
    }
    
    [_expandedSectionRows addObject:selectedSection];
    
//    [_collapsedSectionRows removeAllObjects];
//    [_expandedSectionRows addObjectsFromArray:_sections];
    
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = self.frame;
        frame.origin.y = 30.0f + 44.0f;//top
        frame.size.height = _windowSize.height - (30.0f + 44.0f);
        self.frame = frame;
        
        frame = _menuTableView.frame;
        frame.origin.y = 0.0f;
        frame.size.height = self.frame.size.height - _topBar.frame.size.height;
        _menuTableView.frame = frame;
        
        frame = _topBar.frame;
        frame.origin.y = self.frame.size.height - _topBar.frame.size.height;
        _topBar.frame = frame;
        
    } completion:^(BOOL finished) {
        [self.menuTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
        
    }];
    
    
    
    
}

- (void) hideSection:(UIButton*)button {
    NSInteger section = button.tag;

    NSString *selectedSection = _sections[section];
    
    while ([_expandedSectionRows containsObject:selectedSection]) {
        [_expandedSectionRows removeObjectIdenticalTo:selectedSection];
    }
    
    [_collapsedSectionRows addObject:selectedSection];

    
//    [_expandedSectionRows removeAllObjects];
//    [_collapsedSectionRows addObjectsFromArray:_sections];
    
    
    [UIView animateWithDuration:0.2f animations:^{
        
        if ([_expandedSectionRows count] == 0) {
            CGRect frame = self.frame;
            frame.origin.y = _positionYShown;
            frame.size.height = _sizeHeightShown;
            self.frame = frame;
            
            frame = _topBar.frame;
            frame.origin.y = 0.0f;
            _topBar.frame = frame;
            
            frame = _menuTableView.frame;
            frame.origin.y = _topBar.frame.size.height;
            frame.size.height = self.frame.size.height - _topBar.frame.size.height;
            _menuTableView.frame = frame;
        }
        
        
    } completion:^(BOOL finished) {
        [self.menuTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
        
    }];
    
}


#pragma mark UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSUInteger numberOfRows = 0;
    NSString *key = (NSString*)[self.content allKeys][(NSUInteger)section];
    
    numberOfRows = ((NSArray*)[self.content objectForKey:key]).count;
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *key = (NSString*)_sections[(NSUInteger)indexPath.section];
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ROW_CONTENT_CELL"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ROW_CONTENT_CELL"];
            cell.contentView.backgroundColor = UIColorFromRGB(0xDFDFDF);
            cell.layer.borderWidth = 0.5f;
            cell.layer.borderColor = UIColorFromRGB(0xFFFFFF).CGColor;
            cell.textLabel.backgroundColor = [UIColor clearColor];
        }
    
    
    if ([_collapsedSectionRows containsObject:_sections[indexPath.section]]) {
        return cell;
    }
    
    NSDictionary *item = ((NSArray*)[self.content objectForKey:key])[indexPath.row];
    NSString *text = [NSString stringWithFormat:@"%@ PHP%@",[item[@"name"] uppercaseString],item[@"price"]];
    
    CGFloat nameSize = _cellHeight - 10.0f;
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



- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _cellHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    
    if ([_collapsedSectionRows containsObject:_sections[indexPath.section]]) {
        return 0;
    }
    return _cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, _cellHeight)];
    
    [button setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
    [button setTitle:[_sections[section] uppercaseString] forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateHighlighted];
    [button setTag:section];
    button.layer.borderColor = UIColorFromRGB(0xFFFFFF).CGColor;
    button.layer.borderWidth = 1.0f;
    button.titleLabel.font = [UIFont fontWithName:@"LucidaGrande" size:_cellHeight - 10.0f];
    
    if ([_collapsedSectionRows containsObject:_sections[section]]) {
        [button addTarget:self action:@selector(showSection:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([_expandedSectionRows containsObject:_sections[section]]) {
        [button addTarget:self action:@selector(hideSection:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return button;
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.delegate selectedIndex:indexPath.row];
}

#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}



@end

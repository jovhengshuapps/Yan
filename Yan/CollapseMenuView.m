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
//@property (strong, nonatomic) NSMutableDictionary *subSections;
//@property (strong, nonatomic) NSMutableDictionary *sectionRows;
//@property (strong, nonatomic) NSMutableDictionary *subSectionsItems;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSMutableArray *expandedSectionRows;
@property (strong, nonatomic) NSMutableArray *collapsedSectionRows;

@end

@implementation CollapseMenuView

- (instancetype) initWithPosition:(CollapseMenuViewPosition) position{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _delegate = nil;
    _content = @{};
    
//    _subSections = [NSMutableDictionary new];
//    _sectionRows = [NSMutableDictionary new];
//    _subSectionsItems = [NSMutableDictionary new];
    
    // section has key "section" and rows have "rows"
    _expandedSectionRows = [NSMutableArray new];
    _collapsedSectionRows = [NSMutableArray new];
    
    
    _position = position;
    _cellHeight = 44.0f;
    
    _positionYHidden = KEYWINDOW.bounds.size.height - _cellHeight;
//    _positionYShown = 30.0f + 44.0f;
    
    _positionYShown = KEYWINDOW.bounds.size.height - _cellHeight;
    
    _sizeHeightHidden = _cellHeight;
    _sizeHeightShown = KEYWINDOW.bounds.size.height - _positionYShown;
    
//    self.frame = CGRectMake(10.0f, _positionYHidden, KEYWINDOW.bounds.size.width - 20.0f, _sizeHeightHidden);
    
    self.frame = CGRectMake(0.0f, _positionYHidden, KEYWINDOW.bounds.size.width, _sizeHeightHidden);
    
    self.backgroundColor = [UIColor clearColor];
    
    [self setupTable];
    
    return self;
}

- (instancetype) initWithPosition:(CollapseMenuViewPosition)position content:(NSDictionary*)datasource {
    self = [self initWithPosition:position];
    if (!self) {
        return nil;
    }
    
    _content = nil;
    _content = [NSDictionary dictionaryWithDictionary:datasource];
    
    _sections = [NSArray arrayWithArray:[_content allKeys]];
    [_collapsedSectionRows setArray:_sections];
    
    _positionYShown -= (_cellHeight * _collapsedSectionRows.count);
    
    _sizeHeightShown = KEYWINDOW.bounds.size.height - _positionYShown;
    
    self.frame = CGRectMake(0.0f, _positionYShown, KEYWINDOW.bounds.size.width, _sizeHeightShown);
    
    [_menuTableView reloadData];
    
    return self;
}

- (void) setupTable {
    
    _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 0.0f) style:UITableViewStylePlain];
    
    _menuTableView.delegate = self;
    _menuTableView.dataSource = self;
    _menuTableView.backgroundColor = [UIColor clearColor];
    
    
    _topBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, _cellHeight)];
    
    _topBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topBarButton setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.2f]];
    [_topBarButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [_topBarButton setTitle:@"MAIN MENU" forState:UIControlStateNormal];
    
    _topBarButton.titleLabel.font = [UIFont fontWithName:@"LucidaGrande" size:_cellHeight/3.0f];
    
    _topBarButton.layer.borderColor = UIColorFromRGB(0xFFFFFF).CGColor;
    _topBarButton.layer.borderWidth = 1.0f;
    
    [_topBarButton setFrame:_topBar.frame];
    [_topBar addSubview:_topBarButton];
    
    CGRect frame = _menuTableView.frame;
    frame.size.height = _sizeHeightShown - _topBar.frame.size.height;
    _menuTableView.frame = frame;
    
    
    [self addSubview:_topBar];
    [self addSubview:_menuTableView];
    
    
}

- (void) showMenu {
    
//    [UIView animateWithDuration:0.2f animations:^{
//        
//        CGRect frame = self.frame;
//        frame.origin.y = _positionYShown;
//        frame.size.height = _sizeHeightShown;
//        self.frame = frame;
//        
//        frame = _menuTableView.frame;
//        frame.size.height = _sizeHeightShown - _topBar.frame.size.height;
//        _menuTableView.frame = frame;
//        
//        frame = _topBar.frame;
//        frame.origin.y = _sizeHeightShown - _topBar.frame.size.height;
//        _topBar.frame = frame;
//        
//    } completion:^(BOOL finished) {
//        [self.delegate collapsedMenuShown:YES];
//        [_topBarButton addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
//        [_menuTableView reloadData];
//    }];
    
    
    
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
        [self.delegate collapsedMenuShown:YES];
        [_topBarButton addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
        [_menuTableView reloadData];
    }];
    
}

- (void) hideMenu {
    
    
    [UIView animateWithDuration:0.2f animations:^{
        
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

    }];
}

- (void) showSection:(UIButton*)button {
    NSInteger section = button.tag;
    
    NSString *selectedSection = _sections[section];
    
    while ([_collapsedSectionRows containsObject:selectedSection]) {
        [_collapsedSectionRows removeObjectIdenticalTo:selectedSection];
    }
    
    [_expandedSectionRows addObject:selectedSection];
    
    [self.menuTableView reloadData];
    
    
}

- (void) hideSection:(UIButton*)button {
    NSInteger section = button.tag;
    
    NSString *selectedSection = _sections[section];
    
    while ([_expandedSectionRows containsObject:selectedSection]) {
        [_expandedSectionRows removeObjectIdenticalTo:selectedSection];
    }
    
    [_collapsedSectionRows addObject:selectedSection];
    
    [self.menuTableView reloadData];
}


#pragma mark UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSUInteger numberOfRows = 0;
    NSString *key = (NSString*)[self.content allKeys][(NSUInteger)section];
//    if ([[self.content objectForKey:key] isKindOfClass:[NSDictionary class]]) {
//        NSDictionary *subSections = (NSDictionary*)[self.content objectForKey:key];
//        [_subSections setObject:[subSections allKeys] forKey:key];
//        
//        numberOfRows = [subSections allKeys].count; // For second level section headers
//        NSUInteger sectionIndex = 0;
//        NSMutableArray *tempArray = [NSMutableArray new];
//        for (NSInteger i = 0; i < [subSections allKeys].count; i++) {
//            NSString *subSectionKey = (NSString*)[subSections allKeys][i];
//            NSArray *rows = [subSections objectForKey:subSectionKey];
//            [_subSectionsItems setObject:rows forKey:subSectionKey];
//            [tempArray addObject:subSectionKey];
//            [tempArray addObjectsFromArray:rows];
//            sectionIndex = rows.count;
//            numberOfRows += rows.count; // For actual table rows
//            
//        }
//        [_sectionRows setObject:tempArray forKey:key];
//    }
//    else if ([[self.content objectForKey:key] isKindOfClass:[NSArray class]]) {
        numberOfRows = ((NSArray*)[self.content objectForKey:key]).count;
//    }
    
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *key = (NSString*)_sections[(NSUInteger)indexPath.section];
//    if ([[self.content objectForKey:key] isKindOfClass:[NSArray class]]) {
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
//    }
//    else if ([[self.content objectForKey:key] isKindOfClass:[NSDictionary class]]) {
//        BOOL isSubSection = NO;
//        if ([[_subSections objectForKey:key] containsObject:[_sectionRows objectForKey:key][indexPath.row]]) {
//            isSubSection = YES;
//        }
//        
//        if (isSubSection) {
//            // Section header
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SECTION_HEADER_CELL"];
//            if (cell == nil) {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SECTION_HEADER_CELL"];
//            }
//            cell.textLabel.text = [_sectionRows objectForKey:key][indexPath.row];
//            cell.contentView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.1f];
//            return cell;
//        } else {
//            // Row Item
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ROW_CONTENT_CELL"];
//            if (cell == nil) {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ROW_CONTENT_CELL"];
//            }
//            cell.textLabel.text = [_sectionRows objectForKey:key][indexPath.row];
//            cell.contentView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.1f];
//            return cell;
//        }
//    }
//    
//    return nil;
}



- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *key = (NSString*)[self.content allKeys][(NSUInteger)indexPath.section];
//    
//    if ([[self.content objectForKey:key] isKindOfClass:[NSDictionary class]]) {
//        BOOL isSubSection = NO;
//        if ([[_subSections objectForKey:key] containsObject:[_sectionRows objectForKey:key][indexPath.row]]) {
//            isSubSection = YES;
//        }
//        
//        if (isSubSection) {
//            // Section header
//            return 1;
//        } else {
//            // Row Item
//            return 2;
//        }
//    }
//    
//    return 0;
    
    
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _cellHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *key = (NSString*)[self.content allKeys][(NSUInteger)indexPath.section];
//    BOOL isSubSection = NO;
//    if ([[_subSections objectForKey:key] containsObject:[_sectionRows objectForKey:key][indexPath.row]]) {
//        isSubSection = YES;
//    }
//    
//    if (isSubSection) {
//        // Section header
////        return 1;
//    } else {
//        // Row Item
////        return 2;
//    }
    
    
    if ([_collapsedSectionRows containsObject:_sections[indexPath.section]]) {
        return 0;
    }
    return _cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, _cellHeight)];
    
    [button setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.1f]];
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
//    CGFloat sectionHeaderHeight = 40;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
}



@end

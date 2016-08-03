//
//  DayTableViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 09/06/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "DayTableViewController.h"

@interface DayTableViewController ()
@property (strong, nonatomic) NSMutableArray *dayList;
@end

@implementation DayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Available Days";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.dayList = [NSMutableArray array];
    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDate *currentDate = [NSDate date];
//    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:currentDate]; // Get necessary date components
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
//    
//    NSLog(@"%li / %li / %li / %li",(long)[components month],(long)[components day],(long)[components year],(long)[components weekday]);
//    
//    for (NSInteger day = 1; day <= 7; day++) {
//        components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:currentDate];
//        if (day == [components weekday]) {
//            BOOL available = NO;
//            for (NSString *allowedDays in self.availableDays) {
//                
//                if (day == [self weekdayIntegerFromName:allowedDays]) {
//                    available = YES;
//                }
//            }
//            
//            [self.dayList addObject:@{@"day":[self weekdayNameFromInteger:day],@"date":[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:currentDate]], @"available":[NSNumber numberWithBool:available]}];
//        }
//        else if (day > [components weekday]) {
//            NSInteger difference = day - [components weekday];
//            
//            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
//            dayComponent.day = difference;
//            
//            NSCalendar *theCalendar = [NSCalendar currentCalendar];
//            NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
//            
//            BOOL available = NO;
//            for (NSString *allowedDays in self.availableDays) {
//                
//                if (day == [self weekdayIntegerFromName:allowedDays]) {
//                    available = YES;
//                }
//            }
//            
//            [self.dayList addObject:@{@"day":[self weekdayNameFromInteger:day],@"date":[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:nextDate]], @"available":[NSNumber numberWithBool:available]}];
//        }
//        else {
//            NSInteger difference = day - [components weekday];
//            
//            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
//            dayComponent.day = difference;
//            
//            NSCalendar *theCalendar = [NSCalendar currentCalendar];
//            NSDate *prevDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
//            
//            [self.dayList addObject:@{@"day":[self weekdayNameFromInteger:day],@"date":[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:prevDate]], @"available":@0}];
//        }
//    }
    
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE|MMM dd, yyyy"];
    for (NSInteger day = 0; day < 7; day++) {
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = day;
        
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:currentDate options:0];

//        NSLog(@"### DATE:%@",[dateFormatter stringFromDate:nextDate]);
        
        BOOL available = NO;
        NSString *isDayAvailable = [[dateFormatter stringFromDate:nextDate] componentsSeparatedByString:@"|"][0];
        for (NSString *allowedDay in self.availableDays) {
            if ([isDayAvailable isEqualToString:allowedDay]) {
                available = YES;
                break;
            }
        }
        
        [self.dayList addObject:@{@"day":isDayAvailable,@"date":[NSString stringWithFormat:@"%@",[[dateFormatter stringFromDate:nextDate] componentsSeparatedByString:@"|"][1]], @"available":[NSNumber numberWithBool:available]}];
        
        
//        if (day == [components weekday]) {
//            BOOL available = NO;
//            for (NSString *allowedDays in self.availableDays) {
//                
//                if (day == [self weekdayIntegerFromName:allowedDays]) {
//                    available = YES;
//                }
//            }
//            
//            [self.dayList addObject:@{@"day":[self weekdayNameFromInteger:day],@"date":[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:currentDate]], @"available":[NSNumber numberWithBool:available]}];
//        }
//        else if (day > [components weekday]) {
//            NSInteger difference = day - [components weekday];
//            
//            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
//            dayComponent.day = difference;
//            
//            NSCalendar *theCalendar = [NSCalendar currentCalendar];
//            NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
//
//            BOOL available = NO;
//            for (NSString *allowedDays in self.availableDays) {
//                
//                if (day == [self weekdayIntegerFromName:allowedDays]) {
//                    available = YES;
//                }
//            }
//            
//            [self.dayList addObject:@{@"day":[self weekdayNameFromInteger:day],@"date":[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:nextDate]], @"available":[NSNumber numberWithBool:available]}];
//        }
//        else {
//            NSInteger difference = day - [components weekday];
//            
//            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
//            dayComponent.day = difference;
//            
//            NSCalendar *theCalendar = [NSCalendar currentCalendar];
//            NSDate *prevDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
//            
//            [self.dayList addObject:@{@"day":[self weekdayNameFromInteger:day],@"date":[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:prevDate]], @"available":@0}];
//        }
    }
    
}

- (NSInteger) weekdayIntegerFromName:(NSString*)day {
    if ([day isEqualToString:@"Sunday"]) {
        return 1;
    }
    else if ([day isEqualToString:@"Monday"]) {
        return 2;
    }
    else if ([day isEqualToString:@"Tuesday"]) {
        return 3;
    }
    else if ([day isEqualToString:@"Wednesday"]) {
        return 4;
    }
    else if ([day isEqualToString:@"Thursday"]) {
        return 5;
    }
    else if ([day isEqualToString:@"Friday"]) {
        return 6;
    }
    else if ([day isEqualToString:@"Saturday"]) {
        return 7;
    }
    return 1;
}

- (NSString*) weekdayNameFromInteger:(NSInteger)day {
    switch (day) {
        case 1:
            return @"Sunday";
            break;
        case 2:
            return @"Monday";
            break;
        case 3:
            return @"Tuesday";
            break;
        case 4:
            return @"Wednesday";
            break;
        case 5:
            return @"Thursday";
            break;
        case 6:
            return @"Friday";
            break;
        case 7:
            return @"Saturday";
            break;
            
        default:
            return @"Sunday";
            break;
    }
}

- (NSString*) monthNameFromInteger:(NSInteger)month {
    switch (month) {
        case 1:
            return @"Jan";
            break;
        case 2:
            return @"Feb";
            break;
        case 3:
            return @"Mar";
            break;
        case 4:
            return @"Apr";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"June";
            break;
        case 7:
            return @"July";
            break;
        case 8:
            return @"Aug";
            break;
        case 9:
            return @"Sept";
            break;
        case 10:
            return @"Oct";
            break;
        case 11:
            return @"Nov";
            break;
        case 12:
            return @"Dec";
            break;
            
        default:
            return @"Jan";
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dayList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont fontWithName:@"LucidaGrande" size:20.0f];
        cell.detailTextLabel.font = [UIFont fontWithName:@"LucidaGrande" size:12.0f];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.userInteractionEnabled = YES;
    }
    
    cell.textLabel.text = _dayList[indexPath.row][@"day"];
    cell.detailTextLabel.text = _dayList[indexPath.row][@"date"];
    
    if ([_dayList[indexPath.row][@"available"] boolValue] == NO) {
        cell.textLabel.textColor = [UIColor grayColor];
        cell.userInteractionEnabled = NO;
        cell.contentView.backgroundColor = UIColorFromRGB(0xC9C9C9);
    }
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegatePicker selectedDay:(NSDictionary*)_dayList[indexPath.row]];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

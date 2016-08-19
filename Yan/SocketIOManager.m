//
//  SocketIOManager.m
//  Yan
//
//  Created by Joshua Jose Pecson on 18/08/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "SocketIOManager.h"
#import "Yan-Swift.h"

@interface SocketIOManager ()
@property (strong,nonatomic) SocketIOClient* socket;

@end

@implementation SocketIOManager

+ (id)sharedInstance {
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static SocketIOManager *_sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[SocketIOManager alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (SocketIOClient *)socket {
    
    
    if (!_socket) {
        NSURL* url = [[NSURL alloc] initWithString:@"http://192.168.1.7:3000"];
        _socket = [[SocketIOClient alloc] initWithSocketURL:url options:@{@"log": @YES, @"forcePolling": @YES}];
        
        [_socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"socket connected");
        }];
//        [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
//            NSLog(@"socket connected");
//            [socket emit:@"connectUser" withItems:@[account.username]];
//        }];
//
//        [socket on:@"currentAmount" callback:^(NSArray* data, SocketAckEmitter* ack) {
//            double cur = [[data objectAtIndex:0] floatValue];
//            
//            [socket emitWithAck:@"canUpdate" withItems:@[@(cur)]](0, ^(NSArray* data) {
//                [socket emit:@"update" withItems:@[@{@"amount": @(cur + 2.50)}]];
//            });
//            
//            [ack with:@[@"Got your currentAmount, ", @"dude"]];
//        }];
//        
//        [socket connect];
    }
    return _socket;
}


- (void) establishConnection {
    [self.socket connect];
}

- (void) closeConnection {
    [self.socket disconnect];
}

- (void) connectToServerWithNickname:(NSString*)name restaurant:(NSString*) restaurant table:(NSString*)table {
    [self.socket emit:@"connectUser" withItems:@[@{@"username":name,@"restaurant_id":restaurant,@"table_number":table}]];

    
}

- (void) exitToServerWithNickname:(NSString*)name restaurant:(NSString*) restaurant table:(NSString*)table {
    [self.socket emit:@"exitUser" withItems:@[@{@"username":name,@"restaurant_id":restaurant,@"table_number":table}]];
}


@end

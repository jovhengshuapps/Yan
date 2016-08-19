//
//  SocketIOManager.h
//  Yan
//
//  Created by Joshua Jose Pecson on 18/08/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketIOManager : NSObject

+ (id) sharedInstance;

- (void) establishConnection;
- (void) closeConnection;
- (void) connectToServerWithNickname:(NSString*)name restaurant:(NSString*) restaurant table:(NSString*)table;
- (void) exitToServerWithNickname:(NSString*)name restaurant:(NSString*) restaurant table:(NSString*)table;
@end

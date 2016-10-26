//
//  QRReaderViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 01/06/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"
#import "QRCodeReaderDelegate.h"

@interface QRReaderViewController : CoreViewController <QRCodeReaderDelegate, CLLocationManagerDelegate>

@end

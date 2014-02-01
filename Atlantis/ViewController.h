//
//  ViewController.h
//  Atlantis
//
//  Created by Kevin Burg on 1/31/14.
//  Copyright (c) 2014 Tartanhacks2014. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreBluetooth/CoreBluetooth.h>
#import "TransferService.h"

@interface ViewController : UIViewController //<CBPeripheralManagerDelegate>



@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *foundLabel;



@end

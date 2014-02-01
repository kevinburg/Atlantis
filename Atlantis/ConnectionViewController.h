//
//  ConnectionViewController.h
//  Atlantis
//
//  Created by Kevin Burg on 2/1/14.
//  Copyright (c) 2014 Tartanhacks2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *connectionLabel;
@property NSString *connectionLabelText;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;

@end

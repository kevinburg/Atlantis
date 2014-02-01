//
//  ConnectionViewController.h
//  Atlantis
//
//  Created by Kevin Burg on 2/1/14.
//  Copyright (c) 2014 Tartanhacks2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionViewController : UIViewController

@property NSString *connectionLabelText;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;

@property NSString *id;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *heightLabel;
@property (strong, nonatomic) IBOutlet UILabel *hairColor;
@property (strong, nonatomic) IBOutlet UILabel *majorLabel;

@end

//
//  LoginViewController.h
//  Atlantis
//
//  Created by Kevin Burg on 1/31/14.
//  Copyright (c) 2014 Tartanhacks2014. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController 

@property (strong, nonatomic) FBLoginView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *buttonClicked;
@property NSDictionary *userInfo;

@end

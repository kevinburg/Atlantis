//
//  LoginViewController.m
//  Atlantis
//
//  Created by Kevin Burg on 1/31/14.
//  Copyright (c) 2014 Tartanhacks2014. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.readPermissions = @[@"basic_info", @"email", @"user_likes"];
    loginView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loggedInToAtlantis)
                                                 name:@"LoggedInNotification"
                                               object:nil];
}

#pragma mark - Login
- (void)loggedInToAtlantis
{
    // This function is called once the user logs into Atlantis
    [self performSegueWithIdentifier:@"FromLoginSegue" sender:self];
}


- (IBAction)buttonClicked:(id)sender {
        if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
            NSLog(@"FaceBook token closed & cleared -- probably not good that they got here.");
            [FBSession.activeSession closeAndClearTokenInformation];
        } else {
            NSLog(@"OPEN!");
            [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                               allowLoginUI:YES
                                          completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                              AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                                              [appDelegate sessionStateChanged:session state:state error:error];
                                              
                                          }];
        }

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FromLoginSegue"]) {
        
    } else {
        NSLog(@"Invalid segue attempted from JettaLoginViewController. ");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  LoginViewController.m
//  Atlantis
//
//  Created by Kevin Burg on 1/31/14.
//  Copyright (c) 2014 Tartanhacks2014. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "ViewController.h"

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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.readPermissions = @[@"basic_info", @"email", @"user_likes"];
    loginView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loggedInToAtlantis:)
                                                 name:@"LoggedInNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registerForAtlantis:)
                                                 name:@"RegisterNotification"
                                               object:nil];
}

#pragma mark - Login
- (void)loggedInToAtlantis:(NSNotification *)anote
{
    // This function is called once the user logs into Atlantis
    self.id = [anote userInfo];
    [self performSegueWithIdentifier:@"FromLoginSegue" sender:self];
    
}

- (void)registerForAtlantis:(NSNotification *)anote
{
    self.id = [anote userInfo];
    [self performSegueWithIdentifier:@"RegisterSegue" sender:self];
    
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
        ViewController * con = [segue destinationViewController];
        con.id = self.id;
        NSLog(@"REG_VIEW_CON_VIEW");
        NSLog(self.id);
    } else {
        if ([segue.identifier isEqualToString:@"RegisterSegue"]) {
            RegisterViewController * con = [segue destinationViewController];
            con.id = self.id;
            NSLog(@"LOGIN_VIEW_CON_REG");
            NSLog(self.id);
        } else {
            NSLog(@"Invalid segue attempted from JettaLoginViewController. ");
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

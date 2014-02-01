//
//  AppDelegate.m
//  Atlantis
//
//  Created by Kevin Burg on 1/31/14.
//  Copyright (c) 2014 Tartanhacks2014. All rights reserved.
//

#import "AppDelegate.h"
#import "ServerComm.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBLoginView class];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    // Code from https://developers.facebook.com/docs/ios/login-tutorial
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info", @"user_likes"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    
    // Override point for customization after application launch.
    return YES;
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // Session opened successfully
    if (!error && state == FBSessionStateOpen) {
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed) {
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error) {
        
        // Error requires user action outside of the app
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES) {
            NSLog(@"Technically should notify user, error");
        } else {
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                // User cancelled - no action
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
                // Handle session closures outside of the app
                NSLog(@"session expire");
            } else {
                // Default handling
                NSDictionary *errorInfo = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                NSLog(@"Error with default handling, code: %@", [errorInfo objectForKey:@"message"]);
            }
        }
        
        // Clear token
        [FBSession.activeSession closeAndClearTokenInformation];
        [self userLoggedOut];
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    // This function is called when the user logs in
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        [self setMe:result];
        
        // Then get the profile picture
        [FBRequestConnection startWithGraphPath:@"me?fields=picture.type(large)"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  [self.me setValue:result[@"picture"][@"data"][@"url"] forKey:@"pictureURL"];
                                  // Get cover photo
                                  [FBRequestConnection startWithGraphPath:@"me?fields=cover"
                                                        completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                            [self.me setValue:result[@"source"] forKey:@"coverURL"];
                                                            // Now get their likes
                                                            [FBRequestConnection startWithGraphPath:@"me?fields=likes.limit(5)"
                                                                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                                                    
                                                                                      [self.me setValue:result[@"likes"][@"data"] forKey:@"likesArrayOfDicts"];
                                                                                      [self finishLoggingIn];
                                                                                  }];
                                                            
                                                        }];
                                  
                                  
                              }];
        
    }];
    return;
}

- (void)finishLoggingIn
{
    
    
    [self setLoggedIn:YES];
    
    self.name = [[NSString alloc] init];
    self.name = self.me[@"name"];
    //NSLog(self.name);
    
    
/*
    // Send json to server
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://atlantis-server.hiroku/FakeURL"]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse *response;
    NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    NSLog(@"Reply: %@", theReply);
    */
    
    
    
    
    ServerComm *serverComm = [[ServerComm alloc] init];
    
    if ([serverComm loginUser:self.me] == 0) {
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoggedInNotification"
                                                        object:self
                                                      userInfo:self.me];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RegisterNotification"
                                            object:self userInfo:self.me];
    }

    return;
}

- (void)userLoggedOut
{
    // This function is called when the user logs out
    [self setLoggedIn:NO];
    [self setMe:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoggedOutNotification"
                                                        object:self
                                                      userInfo:self.me];
    return;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

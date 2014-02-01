//
//  ServerComm.m
//  Atlantis
//
//  Created by Kevin Burg on 1/31/14.
//  Copyright (c) 2014 Tartanhacks2014. All rights reserved.
//

#import "ServerComm.h"
#import "AppDelegate.h"

@implementation ServerComm

static NSString *SERVER_URL = @"http://atlantis-server.herokuapp.com";

//Return 0 if user is already registered.
//Otherwise, return 1 and user will be directed to registration.
- (int)loginUser:(NSDictionary *)userData
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/", SERVER_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                        timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:response1 options:kNilOptions error:&error];
    
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    }
    else {
        NSLog(@"Array: %@", jsonArray);
    }
    
    return 1;
}

@end

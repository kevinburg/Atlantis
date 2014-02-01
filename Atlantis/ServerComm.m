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
        NSLog(@"register result: %@", jsonArray[0][@"id"]);
    }
    
    self.fbUser = userData;
    
    //check jsonArray
    if (true) {
        return 1;
    } else {
        return 0;
    }
}

-(void)registerUser:(NSString *)firstName :(NSString *)lastName {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/adduser", SERVER_URL]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSString *userString = [NSString stringWithFormat:@"firstName=%@&lastName=%@&id=%@", firstName, lastName, self.fbUser[@"id"]];
    NSData *jsonData = [userString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:nil];
    return;
}

@end

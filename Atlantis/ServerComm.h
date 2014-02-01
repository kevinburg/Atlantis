//
//  ServerComm.h
//  Atlantis
//
//  Created by Kevin Burg on 1/31/14.
//  Copyright (c) 2014 Tartanhacks2014. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DataCompletionBlock) (NSData *);

@interface ServerComm : NSObject

@property (strong, nonatomic) NSDictionary *fbUser;

- (int)loginUser:(NSDictionary *)userData;

-(void)registerUser:(NSString *)firstName :(NSString *)lastName;

@end

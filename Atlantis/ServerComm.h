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

- (int)loginUser:(NSDictionary *)userData;

@end

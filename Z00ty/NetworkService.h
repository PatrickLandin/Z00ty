//
//  NetworkService.h
//  Z00ty
//
//  Created by Patrick Landin on 2/24/15.
//  Copyright (c) 2015 pLandin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkService : NSObject

+(id)sharedService;

-(void) requestAccessToken:(void (^) (NSString *token))completionHandler;

-(void) handleCallBackURL:(NSData *)image;


@end

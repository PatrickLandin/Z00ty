//
//  MainViewServiceController.h
//  Z00ty
//
//  Created by RYAN CHRISTENSEN on 2/24/15.
//  Copyright (c) 2015 pLandin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainViewServiceController : NSObject

-(void)postPhoneID:(void (^) (NSURL *url, NSString *error))completionHandler;
+(id)sharedService;
-(void)fetchPhotoForHome:(void (^) (NSURL *url, NSString* error))completionHandler;
-(void)postVotes:(void (^) (NSURL *url, NSString *error))completionHandler;
@end

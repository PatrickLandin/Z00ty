//
//  NetworkService.m
//  Z00ty
//
//  Created by Patrick Landin on 2/24/15.
//  Copyright (c) 2015 pLandin. All rights reserved.
//

#import "NetworkService.h"

@implementation NetworkService

+(id)sharedService {
  static NetworkService *mySharedService;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    mySharedService = [[NetworkService alloc] init];
  });
  return mySharedService;
}


@end

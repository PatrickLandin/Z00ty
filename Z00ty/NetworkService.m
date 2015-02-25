//
//  NetworkService.m
//  Z00ty
//
//  Created by Patrick Landin on 2/24/15.
//  Copyright (c) 2015 pLandin. All rights reserved.
//

#import "NetworkService.h"
#import <UIKit/UIKit.h>

@implementation NetworkService

+(id)sharedService {
  static NetworkService *mySharedService;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    mySharedService = [[NetworkService alloc] init];
  });
  return mySharedService;
}

//-(void) requestAccessToken:(void (^) (NSString *token))completionHandler {
//  NSString *urlString = @"http://zooty.herokuapp.com/api/v1/home?phoneID=";
//  
//  NSString *myDevice = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//  urlString = [urlString stringByAppendingString: myDevice];
//}

-(void) postImage:(NSData *)image {
  
  NSString *post = @"http://zooty.herokuapp.com/api/v1/upload?token=";
  post = [post stringByAppendingString:@"token"];
  NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[image length]];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setURL:[NSURL URLWithString:post]];
  [request setHTTPMethod:@"POST"];
  [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
  [request setValue:@"image/png" forHTTPHeaderField:@"Current-Type"];
  [request setHTTPBody:image];

  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Errory times");
      
      } else {
      
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSInteger statusCode = httpResponse.statusCode;
      NSLog(@"%ld", (long)statusCode);
    }
  }];
  [dataTask resume];
}


@end

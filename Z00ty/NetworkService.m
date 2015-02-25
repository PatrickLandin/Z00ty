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

-(void) requestAccessToken {
  NSString *urlString = @"http://zooty.herokuapp.com/api/v1/home?phoneID=";
  urlString = [urlString stringByAppendingString: @""];

}

-(void) handleCallBackURL:(NSData *)image {
  
  NSString *post = @"http://zooty.herokuapp.com/api/v1/upload";
  NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
  NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:"]]];
  [request setHTTPMethod:@"POST"];
  [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
  [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
  [request setHTTPBody:postData];

  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Error");
    } else {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSInteger statusCode = httpResponse.statusCode;
    switch (statusCode) {
      case 200 ... 299: {
        NSLog(@"200");
        break;
      }
      default:
        NSLog(@"%ld",(long)statusCode);
        break;
      }
    }
  }];
  [dataTask resume];
}


@end

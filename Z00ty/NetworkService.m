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

-(void) requestAccessToken {
  NSString *urlString = @"http://zooty.herokuapp.com/api/v1/home?phoneID=";
  urlString = [urlString stringByAppendingString: @""];

}

-(void) handleCallBackURL:(NSData *)image {
  
  NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
  NSString *post = @"http://zooty.herokuapp.com/api/v1/upload";
  //NSString *stringToData = [[NSString alloc] initWithData:image encoding:NSASCIIStringEncoding];
  NSError *jsonError;
  

  
  NSData *data = [image base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
 
  NSString *stringToData = [image base64EncodedStringWithOptions:0];
  NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[data length]];
  
  NSDictionary *photoFile = @{@"photoFile" : stringToData};
   NSData *jsonData = [NSJSONSerialization dataWithJSONObject:photoFile options:0 error:&jsonError];
  
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setURL:[NSURL URLWithString:post]];
  [request setHTTPMethod:@"POST"];
  [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [request setHTTPBody:jsonData];
  [request setValue:token forHTTPHeaderField:@"token"];

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

//
//  MainViewServiceController.m
//  Z00ty
//
//  Created by RYAN CHRISTENSEN on 2/24/15.
//  Copyright (c) 2015 pLandin. All rights reserved.
//

#import "MainViewServiceController.h"
#import "ImageViewController.h"

@implementation MainViewServiceController

+(id)sharedService {
  static MainViewServiceController *mySharedService;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
  mySharedService = [[MainViewServiceController alloc] init];
});
return mySharedService;
}

-(void)postPhoneID:(void (^) (NSURL *url, NSString *error))completionHandler {
  NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
  NSString *authURL = @"http://zooty.herokuapp.com/api/v1";
  authURL = [authURL stringByAppendingString:@"/home/"];
  authURL = [authURL stringByAppendingString:uniqueIdentifier];
  NSURL *url = [NSURL URLWithString:authURL];
  //NSLog(@"%@", url);
  
  NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] initWithURL: url];
  //[postRequest setURL:[NSURL URLWithString:@"POST"]];
  postRequest.HTTPMethod = @"POST";
  //[postRequest setHTTPMethod: @"POST"];
  
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionTask *dataTask = [session dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
    //NSLog(@"%@",response);
    
    NSError *responseError;
    
    NSDictionary *tokenResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&responseError];
    [tokenResponse objectForKey:@"token"];
    
    NSArray *components = [[tokenResponse description] componentsSeparatedByString:@"= \""];
    NSString *token = components.lastObject;
    NSArray *otherComponents = [[token description] componentsSeparatedByString:@"\""];
    NSString *finalToken = otherComponents.firstObject;
    NSLog(@"this is a token %@?", tokenResponse);
    
    if (error) {
      completionHandler(nil, @"could not complete task");
    } else {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger statusCode = httpResponse.statusCode;
        NSLog(@"Get token status code %ld", (long)statusCode);
      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
      [userDefaults setObject:finalToken forKey:@"token"];
      [userDefaults synchronize];
      
      NSLog(@"bob %@", [userDefaults objectForKey:@"token"]);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      
    });
  }];
  [dataTask resume];
}

-(void) postStringForImage:(NSData *)image {
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *token = [userDefaults stringForKey:@"token"];
  
//  NSError *error;
//  NSDictionary *jsonImage = [NSJSONSerialization JSONObjectWithData:image options:0 error:&error];
  
  NSString *post = @"http://zooty.herokuapp.com/api/v1/upload";
  NSURL *serverURL = [[NSURL alloc] initWithString:post];
  
  NSString* bodyString = [NSString stringWithFormat:@"{\"photoFile\":\"%@\"}", image];
  NSData* bodyData = [bodyString dataUsingEncoding:(NSUTF8StringEncoding)];
  
  NSUInteger length  = bodyData.length;
  NSLog(@"Body String : %@", bodyString);
  NSLog(@"data length: %lu", length);
  
  NSMutableURLRequest* postRequest = [[NSMutableURLRequest alloc] initWithURL:serverURL];
  postRequest.HTTPMethod = @"POST";
  NSString* lengthString = [NSString stringWithFormat:@"%lu", length];
  [postRequest setValue:lengthString forHTTPHeaderField:@"Content-Length"];
  [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  postRequest.HTTPBody = bodyData;
  [postRequest setValue:token forHTTPHeaderField:@"token"];
  
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionTask *dataTask = [session dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
    if (error) {
      NSLog(@"Errory times");
      
    } else {
      
      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
      NSInteger statusCode = httpResponse.statusCode;
      NSLog(@"Post image status code: %ld", (long)statusCode);
    }
  }];
  [dataTask resume];
}
  
@end


//  NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[image length]];
//  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//  [request setURL:[NSURL URLWithString:post]];
//  [request setHTTPMethod:@"POST"];
//  [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//  [request setValue:@"application/json" forHTTPHeaderField:@"Current-Type"];
//  [request setHTTPBody:image];
//  [request setValue:token forHTTPHeaderField:@"token"];


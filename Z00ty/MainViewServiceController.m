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

NSString *photoId = @"";

-(void)postPhoneID:(void (^) (NSURL *url, NSString *error))completionHandler {
  NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
  NSString *authURL = @"http://zooty.herokuapp.com/api/v1";
  authURL = [authURL stringByAppendingString:@"/home/"];
  authURL = [authURL stringByAppendingString:uniqueIdentifier];
  NSURL *url = [NSURL URLWithString:authURL];
  NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] initWithURL: url];
  postRequest.HTTPMethod = @"POST";

  
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionTask *dataTask = [session dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
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
        NSLog(@"statusCode for token %ld", (long)statusCode);
      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
      [userDefaults setObject:finalToken forKey:@"token"];
      [userDefaults synchronize];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
    });
  }];
  [dataTask resume];
}

-(void)fetchPhotoForHome:(void (^) (NSURL *url, NSString* error))completionHandler {
  NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
  NSString *token = [userDefaults objectForKey:@"token"];
  NSString *url = @"http://zooty.herokuapp.com/api/v1/stats";
  NSURL *tokenURL = [[NSURL alloc] initWithString:url];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:tokenURL];
  request.HTTPMethod = @"GET";
  [request setValue:token forHTTPHeaderField:@"token"];
  
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSLog(@"%@",response);
    NSError *errorResponse;
    
    NSArray *images = [NSJSONSerialization JSONObjectWithData:data options:0 error:&errorResponse];
    
    NSLog(@"images %@", images);

    
    //single out image in images
    //display that image in imageView
    //store the displayed image _uid in a global variable
    //create bodyString
    //set _uid global variable in body string
    //set photoURL in body string
    //set up as current + new
    //set down as current + new
    
    //[{_uid:adsfdsaf, photoUrl:www.bob.com, up:0, down,0}, {_uid.....}]
    
    if (error) {
      completionHandler(nil, @"$hit didnt work...");
    } else {
      NSHTTPURLResponse *httpRespone = (NSHTTPURLResponse *)response;
      NSInteger statusCode = httpRespone.statusCode;
      NSLog(@"status code for image %ld", (long)statusCode);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      photoId = images[0][@"_id"];
      NSLog(@"%@", photoId);

    });
  }];
  [dataTask resume];
}

-(void)postVotes:(void (^) (NSURL *url, NSString *error))completionHandler {
  
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults stringForKey:@"token"];
    NSString *post = @"http://zooty.herokuapp.com/api/v1/vote/";
    post = [post stringByAppendingString:photoId];

    NSURL *serverURL = [NSURL URLWithString:post];
    NSLog(@"server url: %@",photoId);
    NSString* bodyString = [NSString stringWithFormat:@"{\"photoID\":%@,\"photoUrl\":%@, \"up\":\"%@\",\"down\":%@\"}", @"1", @"2", @"3", @"4"];
  
    NSData* bodyData = [bodyString dataUsingEncoding:(NSUTF8StringEncoding)];
    NSUInteger length  = bodyData.length;
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
        NSLog(@"Post votes status code: %ld", (long)statusCode);
      }
    }];
    [dataTask resume];
  }

  

  
  
  
  
  
  
  
//  //NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
//  //NSString *token = [userDefaults objectForKey:@"token"];
//  NSString *url = @"http://zooty.herokuapp.com/api/v1/vote";
//  //url = [url stringByAppendingString:photoId];
//  NSURL *tokenURL = [[NSURL alloc] initWithString:url];
//  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:tokenURL];
//  request.HTTPMethod = @"POST";
//  
//  NSURLSession *session = [NSURLSession sharedSession];
//  NSURLSessionTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//    
//    NSError *errorResponse;
//    
//    NSDictionary *votes = [NSJSONSerialization JSONObjectWithData:data options:0 error:&errorResponse];
//    [votes objectForKey:@"token"];
//    
//    NSLog(@"images %@", votes);
//    if (error) {
//      completionHandler(nil, @"$hit didnt work...");
//    } else {
//      NSHTTPURLResponse *httpRespone = (NSHTTPURLResponse *)response;
//      NSInteger statusCode = httpRespone.statusCode;
//      NSLog(@"statusCode for votes %ld", (long)statusCode);
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//    });
//  }];
//  [dataTask resume];
//}

@end

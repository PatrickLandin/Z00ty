//
//  ImageService.m
//  Zooty
//
//  Created by Patrick Landin on 2/23/15.
//  Copyright (c) 2015 pLandin. All rights reserved.
//

#import "ImageService.h"
#import <UIKit/UIKit.h>

@implementation ImageService

+(id)sharedService {
  static ImageService *mySharedService;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    mySharedService = [[ImageService alloc] init];
  });
  return mySharedService;
}


-(UIImage *) adjustImage:(UIImage *)image toSmallerSize:(CGSize)newSize {
  
  NSLog(@"Image made smaller");
  
  UIGraphicsBeginImageContext(newSize);
  [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
  
}

-(NSData *) convertImageToData:(UIImage *)image {
  
  NSLog(@"Converted image to data");

  UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
  NSData *imageData = UIImagePNGRepresentation(smallImage);
  
  return imageData;
}


@end

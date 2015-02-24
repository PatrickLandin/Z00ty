//
//  ImageService.h
//  Zooty
//
//  Created by Patrick Landin on 2/23/15.
//  Copyright (c) 2015 pLandin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageService : NSObject

+(id)sharedService;

-(UIImage *) adjustImage:(UIImage *)image toSmallerSize:(CGSize)newSize;

-(UIImage *) convertImageToData:(UIImage *)image;

@end

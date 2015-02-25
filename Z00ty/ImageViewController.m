//
//  ImageViewController.m
//  Zooty
//
//  Created by Patrick Landin on 2/23/15.
//  Copyright (c) 2015 pLandin. All rights reserved.
//

#import "ImageViewController.h"


@interface ImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageViewController

+(CAGradientLayer *) brownGradient {
  UIColor *colorOne = [UIColor colorWithRed:0.77 green:0.68 blue:0.5623 alpha:1];
  UIColor *colorTwo = [UIColor colorWithRed:0.5 green:0.4112 blue:0.295 alpha:1];
  UIColor *colorThree = [UIColor colorWithRed:0.26 green:0.1742 blue:0.062 alpha:1];
  
  NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, nil];
  
  NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
  NSNumber *stopTwo = [NSNumber numberWithFloat:0.80];
  NSNumber *stopThree = [NSNumber numberWithFloat:1.0];
  
  NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, nil];
  
  CAGradientLayer *headerLayer = [CAGradientLayer layer];
  headerLayer.colors = colors;
  headerLayer.locations = locations;
  
  return headerLayer;
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
  [self.imageView layer].masksToBounds = true;
  [self.imageView layer].cornerRadius = 30;
  
  
  CAGradientLayer *bgLayer = [ImageViewController brownGradient];
  bgLayer.frame = self.view.bounds;
  [self.view.layer insertSublayer:bgLayer atIndex:0];
}

- (IBAction)yesButton:(id)sender {
  __weak ImageViewController *weakSelf = self;
  [UIView animateWithDuration:0.5 animations:^{
    weakSelf.imageView.center = CGPointMake(weakSelf.view.frame.size.width, -weakSelf.view.frame.size.height);
  }];
}

- (IBAction)noButton:(id)sender {
  __weak ImageViewController *weakSelf = self;
  [UIView animateWithDuration:0.5 animations:^{
    weakSelf.imageView.center = CGPointMake(-weakSelf.view.frame.size.width, -weakSelf.view.frame.size.height);
  }];
}


@end

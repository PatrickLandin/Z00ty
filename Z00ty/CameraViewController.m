//
//  CameraViewController.m
//  Zooty
//
//  Created by Patrick Landin on 2/23/15.
//  Copyright (c) 2015 pLandin. All rights reserved.
//

#import "CameraViewController.h"
#import "ImageService.h"
#import <UIKit/UIKit.h>
#import "NetworkService.h"

@interface CameraViewController () <UITabBarControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation CameraViewController

-(void)viewWillAppear:(BOOL)animated {
  
// [[ImageService sharedService] requestAccessToken:^(NSString *token) {
//   NSLog(@"Token method has done a thing");
// }];
  
  
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion: NULL];
    
  } else {
    NSLog(@"No camera in da simulator");
  }
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.tabBarController.delegate = self;
  
    // Do any additional setup after loading the view.
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  
  UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
  
  [[ImageService sharedService] adjustImage:chosenImage toSmallerSize:CGSizeMake(300, 300)];
  NSData *imageData = UIImagePNGRepresentation(chosenImage);
  
  // Send this image somewhere
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  
  [picker dismissViewControllerAnimated:YES completion:NULL];
  [self.tabBarController setSelectedIndex:1];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

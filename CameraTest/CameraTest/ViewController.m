//
//  ViewController.m
//  CameraTest
//
//  Created by Iman Zarrabian on 26/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, weak) IBOutlet UIImageView *resultView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createAndInitializePicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createAndInitializePicker {
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;

        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        self.imagePicker.mediaTypes = availableMediaTypes;
    }
    else {
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        self.imagePicker.mediaTypes = availableMediaTypes;
    }
}

- (IBAction)displayCamera:(id)sender {
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}


#pragma mark - UIImagPickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self.imagePicker dismissViewControllerAnimated:YES completion:^{
        self.resultView.image = info[UIImagePickerControllerEditedImage];

    }];
}
@end

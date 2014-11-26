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
        
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.showsCameraControls = NO;

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
    //[self presentViewController:self.imagePicker animated:YES completion:nil];
    [self addChildViewController:self.imagePicker];
    [self.view addSubview:self.imagePicker.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView *viewToAdd = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, self.view.frame.size.height/2, 30.0, 30.0)];
        viewToAdd.backgroundColor = [UIColor redColor];
        
        [self.view addSubview:viewToAdd];
        
        [UIView animateWithDuration:6.0 animations:^{
            viewToAdd.frame = CGRectOffset(viewToAdd.frame, -self.view.frame.size.width, 0);
        }];
    });
    
}


#pragma mark - UIImagPickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.resultView.image = info[UIImagePickerControllerEditedImage];

//    [self.imagePicker dismissViewControllerAnimated:YES completion:^{
//    }];
    
    [self.imagePicker removeFromParentViewController];
    [self.imagePicker.view removeFromSuperview];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.imagePicker removeFromParentViewController];
    [self.imagePicker.view removeFromSuperview];
}
@end

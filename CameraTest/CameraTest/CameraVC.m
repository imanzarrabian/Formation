//
//  CameraVC.m
//  CameraTest
//
//  Created by Iman Zarrabian on 26/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import "CameraVC.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>

@interface CameraVC()
@property (nonatomic, weak) IBOutlet UIView *cameraVew;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, weak) IBOutlet UIImageView *resultImageView;
@property (nonatomic, strong) NSData *imageData;
@end

@implementation CameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configueSession];
}

- (IBAction)dismissVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)configueSession {
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetMedium];
    
    //Creating device
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //Creating device input
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if ([self.session canAddInput:deviceInput]) {
        [self.session addInput:deviceInput];
    
        //Live Camera feed
        AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        self.cameraVew.layer.masksToBounds = YES;
        self.cameraVew.layer.cornerRadius = self.cameraVew.frame.size.width/4.0;
        [previewLayer setFrame:self.cameraVew.frame];
        [self.cameraVew.layer insertSublayer:previewLayer atIndex:0];
        
        
        //Configuring Output
        self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
        [self.stillImageOutput setOutputSettings:outputSettings];
        [self.session addOutput:self.stillImageOutput];
    }
}

- (IBAction)startCamera:(id)sender {
    [self.session startRunning];
}

- (IBAction)shootPhoto:(id)sender {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         
         if (exifAttachments) {
             self.imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
             self.resultImageView.image = [[UIImage alloc] initWithData:self.imageData];
         } else {
             NSLog(@"NO EXIF ATTACHMENTS");
         }
     }];
}

@end

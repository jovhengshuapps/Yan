//
//  ScanLogoViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/20/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "ScanLogoViewController.h"
#import "OrderMenuViewController.h"
#import <ImageIO/ImageIO.h>

@interface ScanLogoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCamera;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSnapshot;
@property (strong,nonatomic) UIImagePickerController *picker;
@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) AVCaptureSession *session;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UILabel *labelInstructions;
@property (weak, nonatomic) IBOutlet UIButton *buttonContinue;


@end

@implementation ScanLogoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        
//        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                              message:@"Device has no camera"
//                                                             delegate:self
//                                                    cancelButtonTitle:@"OK"
//                                                    otherButtonTitles: nil];
//        
//        [myAlertView show];
//        
//    }
//    else {
//        _picker = [[UIImagePickerController alloc] init];
//        _picker.delegate = self;
//        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        _picker.cameraOverlayView = KEYWINDOW;
//        _picker.navigationBarHidden = NO;
//        _picker.showsCameraControls = NO;
//        
//        [self presentViewController:_picker animated:YES completion:^{
//            
//        }];
//        
//    }
}

-(void) viewDidAppear:(BOOL)animated
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    else {
        [self startCamera];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) startCamera {
    _imageViewCamera.image = nil;
    _imageViewCamera.hidden = NO;
    _imageViewSnapshot.image = nil;
    _imageViewSnapshot.hidden = YES;
    _buttonContinue.hidden = YES;
    _labelInstructions.text = @"* The Restaurant logo should be somewhere nearby.";
    _imageButton.enabled = YES;
    [_imageButton addTarget:self action:@selector(captureNow) forControlEvents:UIControlEventTouchUpInside];
    [_session stopRunning];
    for (AVCaptureConnection *connection in _stillImageOutput.connections)
    {
        [_session removeConnection:connection];
    }
    
    [_session removeOutput:_stillImageOutput];
    _session = nil;
    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = AVCaptureSessionPresetHigh;
    
    CALayer *viewLayer = _imageViewCamera.layer;
    NSLog(@"viewLayer = %@", viewLayer);
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    
    captureVideoPreviewLayer.frame = _imageViewCamera.bounds;
    [_imageViewCamera.layer addSublayer:captureVideoPreviewLayer];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [_session addInput:input];
    
    for (AVCaptureConnection *connection in _stillImageOutput.connections)
    {
        [connection setEnabled:NO];
    }
    _stillImageOutput = nil;
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
//    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
//    [_stillImageOutput setOutputSettings:outputSettings];
//    [_session addOutput:_stillImageOutput];
    
    _stillImageOutput.outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG};
    
    if ([_session canAddOutput:_stillImageOutput]) {
        [_session addOutput:_stillImageOutput];
    }
    
    
    [_session startRunning];
}

-(void) captureNow
{
    _imageButton.enabled = NO;
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    NSLog(@"about to request a capture from: %@", _stillImageOutput.outputSettings);
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
             // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
         }
         else
             NSLog(@"no attachments");
         
         if (imageSampleBuffer) {
             
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
             UIImage *image = [[UIImage alloc] initWithData:imageData];
             
             _imageViewSnapshot.image = image;
             _imageViewSnapshot.hidden = NO;
             _imageViewCamera.hidden = YES;
             
             [_session stopRunning];
             
             
             _imageButton.enabled = YES;
             [_imageButton addTarget:self action:@selector(startCamera) forControlEvents:UIControlEventTouchUpInside];
             _buttonContinue.hidden = NO;
             _labelInstructions.text = @"Tap here to Continue.";
         }
     }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        [self proceedToOrderViewMenu];
    }];
    
}

- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self proceedToOrderViewMenu];
}
- (IBAction)scanLogo:(id)sender {
    //scan logo algorithm
    NSLog(@"yoh");
    [self proceedToOrderViewMenu];
}

- (void)proceedToOrderViewMenu {
    OrderMenuViewController *orderMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"orderMenu"];
    [self.navigationController pushViewController:orderMenu animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

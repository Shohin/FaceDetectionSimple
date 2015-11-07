//
//  ViewController.m
//  FaceDetectionSimple
//
//  Created by Admin on 10/26/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "ViewController.h"
#import <CoreImage/CoreImage.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController ()
{
    CIDetector *detector;
}

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)camera:(id)sender
{
    UIImagePickerController *_faceControlImagePicker = [[UIImagePickerController alloc] init];
    _faceControlImagePicker.delegate = self;
    _faceControlImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _faceControlImagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    
    [self presentViewController:_faceControlImagePicker animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        //imgvprofileImage.image = image;
        //[self detectForFacesInUIImage:[UIImage imageNamed:@"image00.jpg"]];
        [self detectImage:image];
//        [self detectForFaces:image.CGImage orientation:image.imageOrientation];
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}

- (void) detectForFaces:(CGImageRef)facePicture orientation:(UIImageOrientation)orientation {
    
    
    CIImage* image = [CIImage imageWithCGImage:facePicture];
    
    CIContext *context = [CIContext contextWithOptions:nil];                    // 1
    NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyLow };      // 2
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:context
                                              options:opts];                    // 3
    
    int exifOrientation;
    switch (orientation) {
        case UIImageOrientationUp:
            exifOrientation = 1;
            break;
        case UIImageOrientationDown:
            exifOrientation = 3;
            break;
        case UIImageOrientationLeft:
            exifOrientation = 8;
            break;
        case UIImageOrientationRight:
            exifOrientation = 6;
            break;
        case UIImageOrientationUpMirrored:
            exifOrientation = 2;
            break;
        case UIImageOrientationDownMirrored:
            exifOrientation = 4;
            break;
        case UIImageOrientationLeftMirrored:
            exifOrientation = 5;
            break;
        case UIImageOrientationRightMirrored:
            exifOrientation = 7;
            break;
        default:
            break;
    }
    
    
    opts = @{ CIDetectorImageOrientation :[NSNumber numberWithInt:exifOrientation
                                           ] };
    
    NSArray *features = [detector featuresInImage:image options:opts];
    
    if ([features count] > 0) {
        CIFaceFeature *face = [features lastObject];
        NSLog(@"%@", NSStringFromCGRect(face.bounds));
    }
}

- (void)detectImage:(UIImage *)img
{
    detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    
    NSDate *date = [NSDate date];
    
    NSArray *features = [detector featuresInImage:
                         [[CIImage alloc] initWithCGImage:img.CGImage]];
    
    NSTimeInterval ti = fabs([date timeIntervalSinceNow]);
    
    NSLog(@"%@", [NSString stringWithFormat:@"Time: %0.3f\nFaces: %lu",ti,(unsigned long)[features count]]);
    
//    UIGraphicsBeginImageContext(imageView.image.size);
//    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    CGContextDrawImage(ctx, CGRectMake(0, 0, imageView.image.size.width, imageView.image.size.height), imageView.image.CGImage);
//    
//    
//    for (CIFeature *feature in features)
//    {
//        CGRect r = feature.bounds;
//        
//        CGContextSetStrokeColor(ctx, CGColorGetComponents([UIColor yellowColor].CGColor));
//        CGContextSetLineWidth(ctx, 1.0f);
//        
//        CGContextBeginPath(ctx);
//        CGContextAddRect(ctx, r);
//        CGContextClosePath(ctx);
//        CGContextStrokePath(ctx);
//        
//    }
//    imageView.image = [UIImage imageWithCGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage scale:1.0f orientation:UIImageOrientationDownMirrored];
//    UIGraphicsEndImageContext();
    
}

@end


#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

typedef void(^QRCallback)(NSString *error, NSString *url);

@interface QRViewController: UIViewController<AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, copy)QRCallback callback;

@end

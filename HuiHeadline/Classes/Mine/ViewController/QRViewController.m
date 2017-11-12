
#import "QRViewController.h"
#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define WIDTH_BUTTON 25
#define SCALE_PX SCREEN_WIDTH / 710

@interface QRViewController ()
@property (nonatomic, retain) UIView *scanRectView;
@property (nonatomic ,retain) AVCaptureDevice *device;
@property (nonatomic, retain) AVCaptureDeviceInput *input;
@property (nonatomic, retain) AVCaptureMetadataOutput *output;
@property (nonatomic, retain) AVCaptureSession *session;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *preView;

@property (nonatomic, strong) NSTimer *timer;

///网格的imgview
@property (nonatomic, strong) UIImageView *scanView;
///我的二维码label
@property (nonatomic, strong) UILabel *messageLabel;

///记录向上滑动最小边界
@property (nonatomic, assign) CGFloat minY;
///记录向下滑动最大边界
@property (nonatomic, assign) CGFloat maxY;
///扫描区域图片
@property (nonatomic, strong) UIImageView *imageV;
///扫描区域的横线是否是应该向上跑动
//@property (nonatomic, assign) BOOL shouldUp;
//记录闪光灯状态
@property (nonatomic, assign) BOOL isLight;

@property (nonatomic, copy) NSString *message;


@end

@implementation QRViewController

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self sweepView];
    
    [self.session startRunning];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _isLight = NO;
    
    
    
    
}
- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.session stopRunning];
}

///扫描时从上往下跑动的线以及提示语
- (void)scanningAnimationWith:(CGRect)rect {
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat with = rect.size.width;
    CGFloat height = rect.size.height;
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, with, 3)];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"qr_scan_line" ofType:@"png"];
    self.imageV.image = [UIImage imageWithContentsOfFile:imagePath];
//    self.shouldUp = NO;
     self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(repeatAction) userInfo:nil repeats:YES];
    
    [self.view addSubview:self.imageV];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y + height, with, 30)];
    label.text = @"将二维码图片对准扫描框即可自动扫描";
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
    
    
}


//定时器
- (void)repeatAction {
    CGFloat speed = 1.0;
//    if (self.shouldUp == NO) {
    
//    self.scanView.hidden = NO;
    self.imageV.frame = CGRectMake(CGRectGetMinX(self.imageV.frame), CGRectGetMinY(self.imageV.frame) + speed, CGRectGetWidth(self.imageV.frame), CGRectGetHeight(self.imageV.frame));
    self.scanView.frame = CGRectMake(self.scanView.frame.origin.x,self.scanView.frame.origin.y + speed, self.scanView.frame.size.width, self.scanView.frame.size.height);
    
    
    
    if (CGRectGetMaxY(self.imageV.frame) >= self.maxY) {
        //归位
        self.imageV.frame = CGRectMake(CGRectGetMinX(self.scanRectView.frame), self.scanRectView.frame.origin.y, CGRectGetWidth(self.imageV.frame), CGRectGetHeight(self.imageV.frame));
        CGFloat height = 550 *SCALE_PX + 16;
        _scanView.frame = CGRectMake(-8, -height + 18, height, height);
        [self.scanRectView addSubview:_scanView];

        
        
    }

}

///获取扫描区域的坐标
- (void)getCGRect:(CGRect)rect {
    CGFloat x = CGRectGetMinX(rect);
    CGFloat y = CGRectGetMinY(rect);
    CGFloat w = CGRectGetWidth(rect);
    CGFloat h = CGRectGetHeight(rect);
    [self creatFuzzyViewWith:CGRectMake(0, 0, SCREEN_WIDTH, y)];
    [self creatFuzzyViewWith:CGRectMake(0, y, x, h)];
    [self creatFuzzyViewWith:CGRectMake(x + w, y, SCREEN_WIDTH - x - w, h)];
    [self creatFuzzyViewWith:CGRectMake(0, y + h, SCREEN_WIDTH, SCREEN_HEIGHT - h - y)];
}

///创建扫描区域之外的模糊效果
- (void)creatFuzzyViewWith :(CGRect)rect {
    UIView *view11 = [[UIView alloc] initWithFrame:rect];
    view11.backgroundColor = [UIColor blackColor];
    view11.alpha = 0.65;
    [self.view addSubview:view11];
}

- (void)sweepView {
    ///获取摄像设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    ///创建输入流
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    ///创建输出流
    self.output = [[AVCaptureMetadataOutput alloc]init];
    ///设置代理,在主线程里面刷新
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    ///初始化连接对象
    self.session = [[AVCaptureSession alloc]init];
    ///高质量采集率
    [self.session setSessionPreset:(SCREEN_HEIGHT<500?AVCaptureSessionPreset640x480:AVCaptureSessionPresetHigh)];
    ///链接对象添加输入流和输出流
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    ///AVMetadataMachineReadableCodeObject对象从QR码生成返回这个常数作为他们的类型
    ///设置扫码支持的编码格式(设置条码和二维码兼容扫描)
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    ///自定义取景框
    CGSize windowSize = [UIScreen mainScreen].bounds.size;
    CGSize scanSize = CGSizeMake(550 * SCALE_PX, 550 * SCALE_PX);
    CGRect scanRect = CGRectMake((windowSize.width-scanSize.width)/2, (128 + 146) * SCALE_PX, scanSize.width, scanSize.height);
    
    /**
     *  横线开始上下滑动
     */
    [self scanningAnimationWith:scanRect];
    //创建周围模糊区域
    [self getCGRect:scanRect];
    self.minY = CGRectGetMinY(scanRect);
    self.maxY = CGRectGetMaxY(scanRect);
    
    
    //计算rectOfInterest 注意x,y交换位置 镜像？
    scanRect = CGRectMake(scanRect.origin.y/windowSize.height, scanRect.origin.x/windowSize.width, scanRect.size.height/windowSize.height,scanRect.size.width/windowSize.width);
    
    
    self.output.rectOfInterest = scanRect;
    
    self.scanRectView = [UIView new];
    [self.view addSubview:self.scanRectView];
    self.scanRectView.frame = CGRectMake(0, 0, scanSize.width, scanSize.height);
    self.scanRectView.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), (128 + 146 + 550 / 2) * SCALE_PX);
//    self.scanRectView.layer.borderColor = 1;
    self.output.rectOfInterest = scanRect;
    self.preView = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preView.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preView.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:self.preView atIndex:0];
    
    
    UIButton *leftBtn = [UIButton new];
    leftBtn.frame = CGRectMake(20, 30, WIDTH_BUTTON, WIDTH_BUTTON);
    
    [leftBtn addTarget:self action:@selector(calcelBack) forControlEvents:UIControlEventTouchUpInside];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"btn_back_without_bg" ofType:@"png"];
    UIImage * img = [UIImage imageWithContentsOfFile:imagePath];
    [leftBtn setImage:img forState:UIControlStateNormal];
    [self.view addSubview:leftBtn];
    
    UIButton *flashButton = [UIButton new];
    flashButton.frame = CGRectMake(MaxX(self.imageV) - WIDTH_BUTTON / 2, CGRectGetMinY(leftBtn.frame), WIDTH_BUTTON, WIDTH_BUTTON);
    [flashButton addTarget:self action:@selector(changeLight:) forControlEvents:UIControlEventTouchUpInside];
    NSString *imagePath1 = [[NSBundle mainBundle] pathForResource:@"闪光灯-关" ofType:@"png"];
    UIImage * imgFlash = [UIImage imageWithContentsOfFile:imagePath1];
    [flashButton setImage:imgFlash forState:UIControlStateNormal];
    [self.view addSubview:flashButton];
    
    
    //网格
    NSString *pathscan = [[NSBundle mainBundle] pathForResource:@"qrcode-res/Scanning" ofType:@"png"];
    UIImageView *scanView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:pathscan]];
    
    
    CGFloat height = 550 *SCALE_PX + 16;
    scanView.frame = CGRectMake(-8, -height + 18, height, height);
    [self.scanRectView addSubview:scanView];
    self.scanRectView.clipsToBounds = YES;
    self.scanView = scanView;
    

    CGFloat pad = 0.0;

    UIImageView *backImgV = [[UIImageView alloc] initWithFrame:CGRectMake(X(self.scanRectView) - pad, Y(self.scanRectView) - pad, W(self.scanRectView) + 2 * pad, H(self.scanRectView) + 2 * pad)];
    backImgV.image = [[UIImage imageNamed:@"qr_scan_frame"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    [self.view addSubview:backImgV];
    
    
    [self initMessageLabel];
    
    
    
}

- (void)calcelBack {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

//我的二维码label + 后面的图片
- (void)initMessageLabel {
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scanRectView.frame) + 48 *SCALE_PX + 30 + 118 * SCALE_PX ,400 *SCALE_PX,30 * SCALE_PX)];
    
    
    self.messageLabel.text = _message;
    
    
    self.messageLabel.textAlignment = 2;
    self.messageLabel.font = [UIFont systemFontOfSize:35 * SCALE_PX];
    self.messageLabel.textColor = [UIColor whiteColor];
    

    [self.view addSubview:self.messageLabel];
    
    if ([self.messageLabel.text isEqual: @""]) {
        self.messageLabel.userInteractionEnabled = NO;
        
    } else {
        UIImageView *weiImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.messageLabel.frame) + 16 * SCALE_PX, CGRectGetMinY(self.messageLabel.frame), 30* SCALE_PX, 30* SCALE_PX)];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"qrcode-res/2weima" ofType:@"png"];
        weiImg.image = [UIImage imageWithContentsOfFile:path];
        [self.view addSubview:weiImg];
        
    }
    
    
}



- (void)changeLight:(UIButton *)sender {
    if (_isLight == NO) {
        [self turnOnLed];
        _isLight = YES;
        [sender setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"闪光灯-开" ofType:@"png"]] forState:UIControlStateNormal];
    } else {
        [self turnOffLed];
        _isLight = NO;
        [sender setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"闪光灯-关" ofType:@"png"]] forState:UIControlStateNormal];
    }
    
}

-(void)turnOffLed {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}

-(void)turnOnLed {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOn];
        [device unlockForConfiguration];
    }
}

- (void)openAlbum{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePickerController.delegate = self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:true completion:nil];
    CIDetector* det = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    UIImage* img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    CIImage* ciImg = [[CIImage alloc]initWithImage:img];
    NSArray* features = [det featuresInImage:ciImg];
    NSObject* first = features.firstObject;
    if (first){
        CIQRCodeFeature* fet = (CIQRCodeFeature *)first;
        
        
        self.callback(nil,fet.messageString);
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }else{
        
        self.callback(@"扫描失败",nil);
    }
}



- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    ///系统处于铃声模式下扫描到结果会调用"卡擦"声音;
    AudioServicesPlaySystemSound(1305);
    ///系统处于震动模式扫描到结果会震动一下;
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    //为零表示没有捕捉到信息,返回重新捕捉
    if (metadataObjects.count == 0) {
        
        
        return;
    }
    //不为零则为捕捉并成功存储了二维码
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject *currentMetadataObject = metadataObjects.firstObject;
        
//        NSLog(@"%@", currentMetadataObject.stringValue);
        [self.timer invalidate]; //停止计时器
        
        
        [self dismissViewControllerAnimated:NO completion:^{
            self.callback(nil,currentMetadataObject.stringValue);
        }];

    }
}

@end


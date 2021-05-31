//
//  SuprAdBannerViewController.m
//  GoogleMediation
//
//  Created by JustinTsou on 2021/4/23.
//

#import "SuprAdBannerViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <AotterTrek-iOS-SDK/AotterTrek-iOS-SDK.h>

static NSString *const TestSuprAdUnit_BottomBanner = @"ca-app-pub-8836593984677243/5995562909";

@interface SuprAdBannerViewController ()<GADNativeAdLoaderDelegate>
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (atomic, strong) GADAdLoader *adLoader;
@property (nonatomic, strong) GADNativeAd *gADUnifiedSuprAd_BottomBanner;
@property (nonatomic, strong) UIView *suprAdBackgroundView;
@end

@implementation SuprAdBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupGADAdLoader];
}

#pragma mark : Button Action GADAdLoader

- (IBAction)tapRefreshButton:(UIButton *)sender {
    [self adLoaderLoadRequest];
}

#pragma mark : Setup GADAdLoader

- (void)setupGADAdLoader {

    self.adLoader = [[GADAdLoader alloc]initWithAdUnitID: TestSuprAdUnit_BottomBanner
                                      rootViewController: self
                                                 adTypes: @[kGADAdLoaderAdTypeNative]
                                                 options: @[]];
    
    self.adLoader.delegate = self;

    [self adLoaderLoadRequest];
}

- (void)adLoaderLoadRequest {
    [self.adLoader loadRequest:[GADRequest request]];
}

#pragma mark - GADUnifiedNativeAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAd:(GADNativeAd *)nativeAd {

    if (nativeAd != nil) {

        if ([[nativeAd.extraAssets allKeys]containsObject:@"trekAd"]) {
            NSString *adType = nativeAd.extraAssets[@"trekAd"];
            
            if ([adType isEqualToString:@"suprAd"]) {
                // Get nativeAd
                _gADUnifiedSuprAd_BottomBanner = nativeAd;
                
                
                // Setup Banner UI
                if ([[_gADUnifiedSuprAd_BottomBanner.extraAssets allKeys]containsObject:@"adSizeWidth"] &&
                    [[_gADUnifiedSuprAd_BottomBanner.extraAssets allKeys]containsObject:@"adSizeHeight"]) {
                    
                    // get ad prefered AdSize
                    NSString *width = _gADUnifiedSuprAd_BottomBanner.extraAssets[@"adSizeWidth"];
                    NSString *height = _gADUnifiedSuprAd_BottomBanner.extraAssets[@"adSizeHeight"];
                    double adSizeWidth = [width doubleValue];
                    double adSizeHeight = [height doubleValue];
                    
                    CGFloat viewWidth = UIScreen.mainScreen.bounds.size.width;
                    CGFloat viewHeight = viewWidth * adSizeHeight/adSizeWidth;
                    int adheight = (int)viewHeight;
                    CGSize preferedMediaViewSize = CGSizeMake(viewWidth, adheight);
                    
                    [self setupSuprAdBackgroundView:_gADUnifiedSuprAd_BottomBanner preferedMediaViewSize:preferedMediaViewSize];
                }
            }
        }
    }
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Error Message:%@",error.description);
}


#pragma mark - Private Method

- (void)setupSuprAdBackgroundView:(GADNativeAd *)nativeAd preferedMediaViewSize:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    _suprAdBackgroundView = [[UIView alloc]initWithFrame:rect];
    
    [self.view addSubview:_suprAdBackgroundView];
    [_suprAdBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [_suprAdBackgroundView.heightAnchor constraintEqualToConstant:size.height].active = YES;
    [_suprAdBackgroundView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
    [_suprAdBackgroundView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:0].active = YES;
    [_suprAdBackgroundView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:0].active = YES;
    
    
    GADMediaView *gADMediaView = [[GADMediaView alloc]initWithFrame:CGRectZero];
    gADMediaView.mediaContent = nativeAd.mediaContent;
    [_suprAdBackgroundView addSubview:gADMediaView];

    [gADMediaView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [gADMediaView.topAnchor constraintEqualToAnchor:_suprAdBackgroundView.topAnchor constant:0].active = YES;
    [gADMediaView.bottomAnchor constraintEqualToAnchor:_suprAdBackgroundView.bottomAnchor constant:0].active = YES;
    [gADMediaView.leftAnchor constraintEqualToAnchor:_suprAdBackgroundView.leftAnchor constant:0].active = YES;
    [gADMediaView.rightAnchor constraintEqualToAnchor:_suprAdBackgroundView.rightAnchor constant:0].active = YES;
}

@end

//
//  AotterTrekGADMediatedSuprAd.h
//  GoogleMediation
//
//  Created by JustinTsou on 2020/12/14.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

#if AotterServiceTestRunning
    #import "TKAdSuprAd.h"
    #import "TKNativeAdConstant.h"
#elif AotterServiceTestV8
    #import "TKAdSuprAd.h"
    #import "TKNativeAdConstant.h"
#else
    #import <AotterTrek-iOS-SDK/AotterTrek-iOS-SDK.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface AotterTrekGADMediatedSuprAd : NSObject<GADMediationNativeAd>

- (instancetype _Nullable )initWithTKSuprAd:(nonnull TKAdSuprAd *)suprAd withAdPlace:(NSString *)adPlace withAdSize:(CGSize)preferedAdSize;

@end

NS_ASSUME_NONNULL_END

//
//  TrekNativeAdTableViewCell.h
//  GoogleMediation
//
//  Created by JustinTsou on 2020/12/10.
//

#import <UIKit/UIKit.h>
#import <AotterTrek-iOS-SDK/AotterTrek-iOS-SDK.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <SDWebImage/SDWebImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrekNativeAdTableViewCell : UITableViewCell

@property(nonatomic, strong) GADNativeAdView *nativeAdView;

- (void)setGADNativeAdData:(GADNativeAd *)nativeAd;

@end

NS_ASSUME_NONNULL_END

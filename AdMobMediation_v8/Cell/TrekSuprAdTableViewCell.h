//
//  TrekSuprAdTableViewCell.h
//  GoogleMediation
//
//  Created by JustinTsou on 2020/12/10.
//

#import <UIKit/UIKit.h>
#import <AotterTrek-iOS-SDK/AotterTrek-iOS-SDK.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrekSuprAdTableViewCell : UITableViewCell

- (void)setGADNativeAdData:(GADNativeAd *)nativeAd withViewSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END

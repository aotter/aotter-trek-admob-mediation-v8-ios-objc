//
//  TrekNativeAdTableViewCell.m
//  GoogleMediation
//
//  Created by JustinTsou on 2020/12/10.
//

#import "TrekNativeAdTableViewCell.h"

@implementation TrekNativeAdTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGADNativeAdData:(GADNativeAd *)nativeAd {
    
    NSArray *nibObjects =
    [[NSBundle mainBundle] loadNibNamed:@"UnifiedNativeAdView" owner:nil options:nil];
    [self setAdView:[nibObjects firstObject]];

    [((UIImageView *)self.nativeAdView.iconView) sd_setImageWithURL:nativeAd.icon.imageURL placeholderImage:nil];
    ((UILabel *)self.nativeAdView.headlineView).text = nativeAd.headline;
    ((UILabel *)self.nativeAdView.bodyView).text = nativeAd.body;
    ((UILabel *)self.nativeAdView.advertiserView).text = nativeAd.advertiser;
    self.nativeAdView.nativeAd = nativeAd;

    [self addSubview:self.nativeAdView];
}

- (void)setAdView:(GADNativeAdView *)view {
    // Remove previous ad view.
    [self.nativeAdView removeFromSuperview];
    self.nativeAdView = view;
    
    // Add new ad view and set constraints to fill its container.
    [self addSubview:view];
    [self.nativeAdView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_nativeAdView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_nativeAdView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_nativeAdView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDictionary]];
}

@end

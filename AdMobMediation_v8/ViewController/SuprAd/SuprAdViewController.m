//
//  SuprAdViewController.m
//  GoogleMediation
//
//  Created by JustinTsou on 2021/4/23.
//

#import "SuprAdViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <AotterTrek-iOS-SDK/AotterTrek-iOS-SDK.h>

#import "TrekSuprAdTableViewCell.h"

static NSInteger googleMediationSuprAdPosition = 8;

static NSString *const TestSuprAdUnit = @"You Supr ad unit";

@interface SuprAdViewController ()<GADNativeAdLoaderDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    GADNativeAd *_gADUnifiedSuprAd;
    UIView *_suprAdView;
}

@property UIRefreshControl *refreshControl;
@property (atomic, strong) GADAdLoader *adLoader;

@property (weak, nonatomic) IBOutlet UITableView *suprAdTableView;

@end

@implementation SuprAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableVie];
    [self setupRefreshControl];
    
    [self setupGADAdLoader];
}

#pragma mark : Setup TableView

- (void)setupTableVie {
    self.suprAdTableView.dataSource = self;
    self.suprAdTableView.delegate = self;
    
    
    [self.suprAdTableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    
    [self.suprAdTableView registerNib:[UINib nibWithNibName:@"TrekSuprAdTableViewCell" bundle:nil] forCellReuseIdentifier:@"TrekSuprAdTableViewCell"];
}

- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc]init];
    
    [self.refreshControl addTarget:self action:@selector(onRefreshTable) forControlEvents:UIControlEventValueChanged];
    [self.suprAdTableView addSubview:self.refreshControl];
}

#pragma mark : Setup GADAdLoader

- (void)setupGADAdLoader {

    self.adLoader = [[GADAdLoader alloc]initWithAdUnitID: TestSuprAdUnit
                                      rootViewController: self
                                                 adTypes: @[kGADAdLoaderAdTypeNative]
                                                 options: @[]];
    
    self.adLoader.delegate = self;

    [self adLoaderLoadRequest];
}

- (void)adLoaderLoadRequest {
    [self.adLoader loadRequest:[GADRequest request]];
}

#pragma mark - Action

- (void)onRefreshTable {
    [self.refreshControl beginRefreshing];

    if (_gADUnifiedSuprAd) {
        _gADUnifiedSuprAd =nil;
    }
    
    [self adLoaderLoadRequest];
    
    [self.refreshControl endRefreshing];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == googleMediationSuprAdPosition) {
        if(_gADUnifiedSuprAd != nil) {
            TrekSuprAdTableViewCell *trekSuprAdTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"TrekSuprAdTableViewCell" forIndexPath:indexPath];
            
            if ([[_gADUnifiedSuprAd.extraAssets allKeys]containsObject:@"adSizeWidth"] &&
                [[_gADUnifiedSuprAd.extraAssets allKeys]containsObject:@"adSizeHeight"]) {
                
                // get ad prefered AdSize
                NSString *width = _gADUnifiedSuprAd.extraAssets[@"adSizeWidth"];
                NSString *height = _gADUnifiedSuprAd.extraAssets[@"adSizeHeight"];
                double adSizeWidth = [width doubleValue];
                double adSizeHeight = [height doubleValue];

                CGFloat viewWidth = UIScreen.mainScreen.bounds.size.width;
                CGFloat viewHeight = viewWidth * adSizeHeight/adSizeWidth;
                int adheight = (int)viewHeight;
                CGSize preferedMediaViewSize = CGSizeMake(viewWidth, adheight);
                
                [trekSuprAdTableViewCell setGADNativeAdData:_gADUnifiedSuprAd withViewSize:preferedMediaViewSize];
            }
            
            return trekSuprAdTableViewCell;
        }
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [[NSString alloc]initWithFormat:@"index:%ld",(long)indexPath.row];
    return  cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == googleMediationSuprAdPosition) {
        if ([[_gADUnifiedSuprAd.extraAssets allKeys]containsObject:@"adSizeWidth"] &&
            [[_gADUnifiedSuprAd.extraAssets allKeys]containsObject:@"adSizeHeight"]) {
            
            // get ad prefered AdSize
            NSString *width = _gADUnifiedSuprAd.extraAssets[@"adSizeWidth"];
            NSString *height = _gADUnifiedSuprAd.extraAssets[@"adSizeHeight"];
            double adSizeWidth = [width doubleValue];
            double adSizeHeight = [height doubleValue];

            CGFloat viewWidth = UIScreen.mainScreen.bounds.size.width;
            CGFloat viewHeight = viewWidth * adSizeHeight/adSizeWidth;
            
            return _gADUnifiedSuprAd == nil ? 0:viewHeight;
        }
    }
    
    return 80;
}


#pragma mark : ScrlloView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_gADUnifiedSuprAd != nil) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SuprAdScrolled"
                                                           object:self
                                                         userInfo:nil];
    }
}


#pragma mark - GADNativeAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAd:(GADNativeAd *)nativeAd {

    // Delegate 回來的 nativeAd 已經可以接取到自己的 Custom Ad View，
    // 這部分可以將 nativeAd 放到 CustomTableViewCell 去接資料

    if (nativeAd != nil) {

        if ([[nativeAd.extraAssets allKeys]containsObject:@"trekAd"]) {
            NSString *adType = nativeAd.extraAssets[@"trekAd"];

            if ([adType isEqualToString:@"suprAd"]) {
                _gADUnifiedSuprAd = nativeAd;
            }
        }
    }

    [self.suprAdTableView reloadData];
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Error Message:%@",error.description);
}

@end

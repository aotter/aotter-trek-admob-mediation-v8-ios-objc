//
//  NativeAdViewController.m
//  GoogleMediation
//
//  Created by JustinTsou on 2021/4/23.
//

#import "NativeAdViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <AotterTrek-iOS-SDK/AotterTrek-iOS-SDK.h>

#import "TrekNativeAdTableViewCell.h"

static NSInteger googleMediationNativeAdPosition = 6;

static NSString *const TestNativeAdUnit = @"ca-app-pub-8836593984677243/8365089229";

@interface NativeAdViewController ()<GADNativeAdLoaderDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    GADNativeAd *_gADUnifiedNativeAd;
}

@property UIRefreshControl *refreshControl;
@property (atomic, strong) GADAdLoader *adLoader;

@property (weak, nonatomic) IBOutlet UITableView *nativeAdTableView;

@end

@implementation NativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableVie];
    [self setupRefreshControl];
    
    [self setupGADAdLoader];
}

#pragma mark : Setup TableView

- (void)setupTableVie {
    self.nativeAdTableView.dataSource = self;
    self.nativeAdTableView.delegate = self;
    
    
    [self.nativeAdTableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    
    [self.nativeAdTableView registerNib:[UINib nibWithNibName:@"TrekNativeAdTableViewCell" bundle:nil] forCellReuseIdentifier:@"TrekNativeAdTableViewCell"];
    
    [self.nativeAdTableView registerNib:[UINib nibWithNibName:@"TrekSuprAdTableViewCell" bundle:nil] forCellReuseIdentifier:@"TrekSuprAdTableViewCell"];
}

- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc]init];
    
    [self.refreshControl addTarget:self action:@selector(onRefreshTable) forControlEvents:UIControlEventValueChanged];
    [self.nativeAdTableView addSubview:self.refreshControl];
}

#pragma mark : Setup GADAdLoader

- (void)setupGADAdLoader {
    GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[ kGADSimulatorID ];
    self.adLoader = [[GADAdLoader alloc]initWithAdUnitID: TestNativeAdUnit
                                      rootViewController: self
                                                 adTypes: @[kGADAdLoaderAdTypeNative]
                                                 options: @[]];
    
    self.adLoader.delegate = self;

    [self adLoaderLoadRequest];
}

- (void)adLoaderLoadRequest {
   
    GADRequest *request = [GADRequest request];
    GADCustomEventExtras *extra = [[GADCustomEventExtras alloc] init];
    [extra setExtras:@{@"category":@"navite_movie"} forLabel:@"AotterTrekGADCustomEventNativeAd"];
    [request registerAdNetworkExtras:extra];
    
    [self.adLoader loadRequest:request];
}

#pragma mark - Action

- (void)onRefreshTable {
    [self.refreshControl beginRefreshing];
    
    if (_gADUnifiedNativeAd) {
        _gADUnifiedNativeAd = nil;
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
    
    if (indexPath.row == googleMediationNativeAdPosition) {
        if (_gADUnifiedNativeAd != nil) {
            TrekNativeAdTableViewCell *trekNativeAdTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"TrekNativeAdTableViewCell" forIndexPath:indexPath];
            
            [trekNativeAdTableViewCell setGADNativeAdData:_gADUnifiedNativeAd];
            return trekNativeAdTableViewCell;
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
    
    if (indexPath.row == googleMediationNativeAdPosition) {
        return _gADUnifiedNativeAd == nil ? 0:80;
    }
    
    return 80;
}

#pragma mark - GADUnifiedNativeAdLoaderDelegate


- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAd:(GADNativeAd *)nativeAd {
    // Delegate 回來的 nativeAd 已經可以接取到自己的 Custom Ad View，
    // 這部分可以將 nativeAd 放到 CustomTableViewCell 去接資料

    if (nativeAd != nil) {

        if ([[nativeAd.extraAssets allKeys]containsObject:@"trekAd"]) {
            NSString *adType = nativeAd.extraAssets[@"trekAd"];

            if ([adType isEqualToString:@"nativeAd"]) {
                _gADUnifiedNativeAd = nativeAd;
            }
        }
    }

    [self.nativeAdTableView reloadData];
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Error Message:%@",error.description);
}

@end

//
//  AdItemViewController.m
//  GoogleMediation
//
//  Created by JustinTsou on 2021/4/23.
//

#import "AdItemViewController.h"
#import "NativeAdViewController.h"
#import "SuprAdViewController.h"
#import "BannerViewController.h"

typedef NS_ENUM(NSInteger, AdEnum) {
    NativeAd = 0,
    SuprAd = 1,
    SuprAdBanner = 2
};

@interface AdItemViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_adItem;
}
@property (weak, nonatomic) IBOutlet UITableView *adItemTableView;
@property AdEnum adEnum;

@end

@implementation AdItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _adItem = [[NSArray alloc]initWithObjects:@"Native Ad",@"Supr Ad",@"Banner Ad", nil];
    
    [self setupTableVie];
}

#pragma mark : Setup TableView

- (void)setupTableVie {
    self.adItemTableView.dataSource = self;
    self.adItemTableView.delegate = self;
    
    [self.adItemTableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _adItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = _adItem[indexPath.row];
    return  cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == NativeAd) {
        NativeAdViewController *nativeAdViewController = [[NativeAdViewController alloc]init];
        [self.navigationController pushViewController:nativeAdViewController animated:YES];
    }else if (indexPath.row == SuprAd) {
        SuprAdViewController *suprAdViewController = [[SuprAdViewController alloc]init];
        [self.navigationController pushViewController:suprAdViewController animated:YES];
    }if (indexPath.row == SuprAdBanner) {
        BannerViewController *bannerViewController = [[BannerViewController alloc]init];
        [self.navigationController pushViewController:bannerViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

@end

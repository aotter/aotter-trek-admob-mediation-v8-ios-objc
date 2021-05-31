//
//  BannerViewController.swift
//  AdMobMediation_v8_Swift
//
//  Created by JustinTsou on 2021/5/31.
//

import UIKit
import GoogleMobileAds

class BannerViewController: UIViewController {
    
    @IBOutlet weak var RefreshButton: UIButton!
    
    private let TestBannerAdUnit: String = "Your banner ad unit"
    
    private var gadBannerView: GADBannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupGADBannerView()
    }
    
    @IBAction func tapRefreshBtn(_ sender: UIButton) {
        
        self.gadBannerViewLoadRequest()
    }
}

extension BannerViewController {
    
    private func setupGADBannerView() {
        
        gadBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        gadBannerView?.delegate = self
        gadBannerView?.rootViewController = self
        gadBannerView?.adUnitID = TestBannerAdUnit
        
        self.gadBannerViewLoadRequest()
    }
    
    private func gadBannerViewLoadRequest() {
        gadBannerView?.load(GADRequest())
    }
}

extension BannerViewController: GADBannerViewDelegate {
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        
        self.view.addSubview(bannerView)

        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bannerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bannerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        bannerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("error message:\(error.localizedDescription)")
    }
}


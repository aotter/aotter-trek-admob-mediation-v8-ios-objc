//
//  SuprAdBannerViewController.swift
//  AotterGoogleMediationAdSwift
//
//  Created by JustinTsou on 2021/4/23.
//

import UIKit
import GoogleMobileAds

class SuprAdBannerViewController: UIViewController {
    
    private let TestSuprAdUnit_BottomBanner: String = "ca-app-pub-8836593984677243/5995562909"
    
    @IBOutlet weak var refreshButton: UIButton!
    private var adLoader: GADAdLoader?
    private var gADUnifiedSuprAd_BottomBanner: GADNativeAd?
    private var suprAdBackgroundView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupGADAdloader()
    }

    @IBAction func tapRefreshButton(_ sender: UIButton) {
        self.adLoaderLoadRequest()
    }
}

// MARK: Setup GADAdLoader

extension SuprAdBannerViewController {
    
    private func setupGADAdloader() {
        
        adLoader = GADAdLoader.init(adUnitID: TestSuprAdUnit_BottomBanner, rootViewController: self, adTypes: [.native], options: [])

        adLoader?.delegate = self

        adLoaderLoadRequest()
    }
    
    private func adLoaderLoadRequest() {
        adLoader?.load(GADRequest())
    }
}

// MARK: GADUnifiedNativeAdLoaderDelegate

extension SuprAdBannerViewController: GADNativeAdLoaderDelegate {

    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        guard let extraAssets = nativeAd.extraAssets else { return }

        if extraAssets.keys.contains("trekAd") {
            let adType = extraAssets["trekAd"] as! String

            if adType == "suprAd" {
                gADUnifiedSuprAd_BottomBanner = nativeAd
                
                if extraAssets.keys.contains("adSizeWidth") &&
                    extraAssets.keys.contains("adSizeHeight") {
                    
                    let width = extraAssets["adSizeWidth"] as! Double
                    let height = extraAssets["adSizeHeight"] as! Double
                    
                    let adSizeWidth:CGFloat = CGFloat(width)
                    let adSizeHeight:CGFloat = CGFloat(height)
                    
                    let viewWidth = UIScreen.main.bounds.size.width
                    let viewHeight = viewWidth * adSizeHeight/adSizeWidth
                    let adheight = Int(viewHeight)
                    let adWidth = Int(viewWidth)
                    let preferedMediaViewSize = CGSize(width: adWidth, height: adheight)
                    
                    self.setupSuprAdBackgroundView(nativeAd: gADUnifiedSuprAd_BottomBanner, size: preferedMediaViewSize)
                }
            }
        }
    }

    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("Error Message:\(error.localizedDescription)")
    }
}

extension SuprAdBannerViewController {
    private func setupSuprAdBackgroundView(nativeAd:GADNativeAd?, size:CGSize) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.suprAdBackgroundView = UIView(frame: rect)
        
        self.view.addSubview(self.suprAdBackgroundView ?? UIView())
        self.suprAdBackgroundView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.suprAdBackgroundView?.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        self.suprAdBackgroundView?.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.suprAdBackgroundView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.suprAdBackgroundView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        let gADMediaView:GADMediaView = GADMediaView(frame: .zero)
        gADMediaView.mediaContent = nativeAd?.mediaContent
        self.suprAdBackgroundView?.addSubview(gADMediaView)
        
        gADMediaView.translatesAutoresizingMaskIntoConstraints = false
        
        gADMediaView.topAnchor.constraint(equalTo: self.suprAdBackgroundView!.topAnchor).isActive = true
        gADMediaView.bottomAnchor.constraint(equalTo: self.suprAdBackgroundView!.bottomAnchor).isActive = true
        gADMediaView.trailingAnchor.constraint(equalTo: self.suprAdBackgroundView!.trailingAnchor).isActive = true
        gADMediaView.leadingAnchor.constraint(equalTo: self.suprAdBackgroundView!.leadingAnchor).isActive = true
    }
}

//
//  SuprAdViewController.swift
//  AotterGoogleMediationAdSwift
//
//  Created by JustinTsou on 2021/4/23.
//

import UIKit
import GoogleMobileAds

@objc class SuprAdViewController: UIViewController {
    
    @IBOutlet weak var suprAdTableView: UITableView!
    
    private let TestSuprAdUnit: String = "Your Supr ad unit"
    
    private let googleMediationSuprAdPosition:   Int = 8
    
    private var refreshControl: UIRefreshControl?
    private var adLoader: GADAdLoader?
    private var gADUnifiedSuprAd: GADNativeAd?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        self.setupRefreshControl()
        self.setupGADAdloader()
    }
    
}

// MARK: Setup UI

extension SuprAdViewController {
    
    private func setupTableView() {
        suprAdTableView.delegate = self
        suprAdTableView.dataSource = self
        
        suprAdTableView.register(UINib(nibName: "TrekSuprAdTableViewCell", bundle: nil), forCellReuseIdentifier: "TrekSuprAdTableViewCell")
        
        suprAdTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.onRefreshTable), for: .valueChanged)
        suprAdTableView.addSubview(refreshControl!)
    }
    
    @objc func onRefreshTable(_: UIRefreshControl) {
        refreshControl?.beginRefreshing()
        
        if gADUnifiedSuprAd != nil {
            gADUnifiedSuprAd = nil;
        }
        
        self.adLoaderLoadRequest()
        
        refreshControl?.endRefreshing()
    }
}

// MARK: Setup GADAdLoader

extension SuprAdViewController {
    
    private func setupGADAdloader() {
        
        adLoader = GADAdLoader.init(adUnitID: TestSuprAdUnit, rootViewController: self, adTypes: [.native], options: [])

        adLoader?.delegate = self

        adLoaderLoadRequest()
    }
    
    private func adLoaderLoadRequest() {
        adLoader?.load(GADRequest())
    }
}

// MARK: UITableViewDataSource

extension SuprAdViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if indexPath.row == googleMediationSuprAdPosition {
            let trekSuprAdTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TrekSuprAdTableViewCell", for: indexPath) as! TrekSuprAdTableViewCell
            
            if let gADUnifiedSuprAd = gADUnifiedSuprAd,
               let extraAssets = gADUnifiedSuprAd.extraAssets {
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

                    trekSuprAdTableViewCell.setGADNativeAdData(nativeAd: gADUnifiedSuprAd, size: preferedMediaViewSize)

                    return trekSuprAdTableViewCell
                }
            }
            return trekSuprAdTableViewCell
        }
        
        cell.textLabel?.text = "index:\(indexPath.row)"
        return cell
    }
}

// MARK: UITableViewDelegate

extension SuprAdViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == googleMediationSuprAdPosition {
            if let gADUnifiedSuprAd = gADUnifiedSuprAd,
               let extraAssets = gADUnifiedSuprAd.extraAssets {
                if extraAssets.keys.contains("adSizeWidth") &&
                    extraAssets.keys.contains("adSizeHeight") {

                    let width = extraAssets["adSizeWidth"] as! Double
                    let height = extraAssets["adSizeHeight"] as! Double

                    let adSizeWidth:CGFloat = CGFloat(width)
                    let adSizeHeight:CGFloat = CGFloat(height)

                    let viewWidth = UIScreen.main.bounds.size.width
                    let viewHeight = viewWidth * adSizeHeight/adSizeWidth

                    return viewHeight
                }
            }
            
            return 0
        }
        
        return 80
    }
}

// MARK: ScrollView delegate

extension SuprAdViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if gADUnifiedSuprAd != nil {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SuprAdScrolled"),
                                            object: nil,
                                            userInfo: nil)
        }
    }
}


// MARK: GADUnifiedNativeAdLoaderDelegate

extension SuprAdViewController: GADNativeAdLoaderDelegate {

    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        guard let extraAssets = nativeAd.extraAssets else { return }

        if extraAssets.keys.contains("trekAd") {
            let adType = extraAssets["trekAd"] as! String

            if adType == "suprAd" {
                gADUnifiedSuprAd = nativeAd
            }
        }

        suprAdTableView.reloadData()
    }

    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("Error Message:\(error.localizedDescription)")
    }
}

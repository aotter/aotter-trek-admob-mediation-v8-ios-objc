//
//  NativeAdViewController.swift
//  AotterGoogleMediationAdSwift
//
//  Created by JustinTsou on 2021/4/23.
//

import UIKit
import GoogleMobileAds


class NativeAdViewController: UIViewController {

    @IBOutlet weak var nativeAdTableView: UITableView!
    
    private let TestNativeAdUnit: String = "Your Native ad unit"
    
    private let googleMediationNativeAdPosition: Int = 11
    
    private var refreshControl: UIRefreshControl?
    
    private var adLoader: GADAdLoader?
    private var gADUnifiedNativeAd: GADNativeAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        self.setupRefreshControl()
        self.setupGADAdloader()
    }
    
}

// MARK: Setup UI

extension NativeAdViewController {
    
    private func setupTableView() {
        nativeAdTableView.delegate = self
        nativeAdTableView.dataSource = self
        
        nativeAdTableView.register(UINib(nibName: "TrekNativeAdTableViewCell", bundle: nil), forCellReuseIdentifier: "TrekNativeAdTableViewCell")
        
        nativeAdTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.onRefreshTable), for: .valueChanged)
        nativeAdTableView.addSubview(refreshControl!)
    }
    
    @objc func onRefreshTable(_: UIRefreshControl) {
        refreshControl?.beginRefreshing()
        
        if gADUnifiedNativeAd != nil {
            gADUnifiedNativeAd = nil;
        }
        
        self.adLoaderLoadRequest()
        
        refreshControl?.endRefreshing()
    }
}

// MARK: Setup GADAdLoader

extension NativeAdViewController {
    
    private func setupGADAdloader() {
        
        adLoader = GADAdLoader.init(adUnitID: TestNativeAdUnit, rootViewController: self, adTypes: [.native], options: [])

        adLoader?.delegate = self

        adLoaderLoadRequest()
    }
    
    private func adLoaderLoadRequest() {
        adLoader?.load(GADRequest())
    }
}

// MARK: UITableViewDataSource

extension NativeAdViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if indexPath.row == googleMediationNativeAdPosition {
            let trekNativeAdTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TrekNativeAdTableViewCell", for: indexPath) as! TrekNativeAdTableViewCell
            
            guard let gADUnifiedNativeAd = gADUnifiedNativeAd else { return cell }
            trekNativeAdTableViewCell.setGADNativeAdData(nativeAd: gADUnifiedNativeAd )
            
            cell = trekNativeAdTableViewCell
        }
        
        cell.textLabel?.text = "index:\(indexPath.row)"
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: UITableViewDelegate

extension NativeAdViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == googleMediationNativeAdPosition {
            return gADUnifiedNativeAd == nil ? 0:80
        }
        
        return 80
    }
}


// MARK: GADNativeAdLoaderDelegate

extension NativeAdViewController: GADNativeAdLoaderDelegate {

    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        guard let extraAssets = nativeAd.extraAssets else { return }

        if extraAssets.keys.contains("trekAd") {
            let adType = extraAssets["trekAd"] as! String

            if adType == "nativeAd" {
                gADUnifiedNativeAd = nativeAd
            }
        }

        nativeAdTableView.reloadData()
    }

    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("Error Message:\(error.localizedDescription)")
    }
}


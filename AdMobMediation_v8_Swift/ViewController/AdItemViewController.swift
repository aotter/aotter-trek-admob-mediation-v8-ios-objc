//
//  AdItemViewController.swift
//  AotterGoogleMediationAdSwift
//
//  Created by JustinTsou on 2021/4/23.
//

import UIKit

enum AdEnum:Int {
    case NativeAd
    case SuprAd
    case SuprAdBanner
    
    static func getReviewCellType() -> [AdEnum] {
        return [.NativeAd,.SuprAd,SuprAdBanner]
    }
}

class AdItemViewController: UIViewController {
    
    @IBOutlet weak var adItemTableView: UITableView!
    
    private let adItem = ["Native Ad","Supr Ad","Banner Ad"];

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
    }

}

// MARK: Setup UI

extension AdItemViewController {
    
    private func setupTableView() {
        adItemTableView.delegate = self
        adItemTableView.dataSource = self
        adItemTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

// MARK: UITableViewDataSource

extension AdItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = adItem[indexPath.row]
        return cell
    }
}

extension AdItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = AdEnum.getReviewCellType()[indexPath.row]
        
        switch row {
        case .NativeAd:
            let nativeAdViewController = NativeAdViewController(nibName: "NativeAdViewController", bundle: nil)
            self.navigationController?.pushViewController(nativeAdViewController, animated: true)
            break
        case .SuprAd:
            let suprAdViewController = SuprAdViewController(nibName: "SuprAdViewController", bundle: nil)
            self.navigationController?.pushViewController(suprAdViewController, animated: true)
            break
        case .SuprAdBanner:
            let bannerViewController = BannerViewController(nibName: "BannerViewController", bundle: nil)
            self.navigationController?.pushViewController(bannerViewController, animated: true)
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

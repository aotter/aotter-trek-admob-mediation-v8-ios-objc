//
//  TrekSuprAdTableViewCell.swift
//  AotterGoogleMediationAdSwift
//
//  Created by JustinTsou on 2021/3/2.
//

import UIKit
import GoogleMobileAds

class TrekSuprAdTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setGADNativeAdData(nativeAd:GADNativeAd, size:CGSize) {

        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let gADMediaView = GADMediaView.init(frame: rect)
        gADMediaView.mediaContent = nativeAd.mediaContent
        self.contentView.addSubview(gADMediaView)

        gADMediaView.translatesAutoresizingMaskIntoConstraints = false
        gADMediaView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        gADMediaView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        gADMediaView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        gADMediaView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
}

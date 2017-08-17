//
//  FinalDestinationCellTableViewCell.swift
//  SwiftPlay
//
//  Created by Richard Martin on 13/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import UIKit

class FinalDestinationCellTableViewCell: UITableViewCell {
    var timeLabel: UILabel!
    var locationLabel: UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = UIColor.clear
        
        setup()
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    private func setup() {
        locationLabel = UILabel()
        self.contentView.addSubview(locationLabel)
        locationLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 10.5)
        locationLabel.textColor = UIColor(red: 42/255, green: 42/255, blue: 43/255, alpha: 1.0)
        
        timeLabel = UILabel()
        self.addSubview(timeLabel)
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 9.0)
        timeLabel.textColor = Constants.Colors.LightBlue
        
        locationLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.contentView).inset(75)
            make.top.equalToSuperview().offset(3)
        }
        
        timeLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.width.equalTo(65)
            make.top.equalToSuperview().offset(5)
        }
    }
    
    func set(time: String, location: String) {
        locationLabel.text = location
        timeLabel.text = time
    }
}

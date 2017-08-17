//
//  DirectionTableViewCell.swift
//  SwiftPlay
//
//  Created by Richard Martin on 07/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import UIKit
import SnapKit
import GoogleMaterialDesignIcons

enum TravelStage {
    case begining
    case normal
    case ending
}

class DirectionTableViewCell: UITableViewCell {
    var locationLabel: UILabel!
    var travelTimeLabel: UILabel!
    var stopsLabel: UILabel!
    var leftContainer: DirectionTableViewCellLeftView!
    var station: UILabel!
    var departuresEveryLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor.white
        
        setup()
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    private func setup() {
        leftContainer = DirectionTableViewCellLeftView()
        self.contentView.addSubview(leftContainer)
        leftContainer.snp.makeConstraints { (make) -> Void in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(66)
        }
        
        locationLabel = UILabel()
        self.contentView.addSubview(locationLabel)
        locationLabel.font = Constants.Fonts.defaultBoldFont(size: 10.5)
        locationLabel.textColor = Constants.Colors.Black
        
        let arrowLabel = UILabel()
        self.contentView.addSubview(arrowLabel)
        arrowLabel.font = UIFont(name: GoogleIconName, size: 8.0)
        arrowLabel.textColor = Constants.Colors.Black
        arrowLabel.text = GoogleIcon.ebb9
        
        station = UILabel()
        self.contentView.addSubview(station)
        station.font = Constants.Fonts.defaultBoldFont(size: 10.5)
        station.textColor = Constants.Colors.Black
        
        locationLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(leftContainer.snp.right).offset(10)
            make.top.equalToSuperview().offset(3)
        }
        
        station.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(arrowLabel.snp.right).offset(3)
            make.top.equalTo(locationLabel.snp.bottom).offset(3)
        }
        
        arrowLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(leftContainer.snp.right).offset(10)
            make.top.equalTo(locationLabel.snp.bottom).offset(5)
        }
        
        departuresEveryLabel = UILabel()
        self.contentView.addSubview(departuresEveryLabel)
        departuresEveryLabel.font = UIFont(name: "HelveticaNeue", size: 8)
        departuresEveryLabel.textColor = .gray
        
        departuresEveryLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(station)
            make.top.equalTo(station.snp.bottom)
        }
        
        let container = UIView()
        self.contentView.addSubview(container)
        
        stopsLabel = UILabel()
        container.addSubview(stopsLabel)
        stopsLabel.font = UIFont(name: "HelveticaNeue", size: 9)
        stopsLabel.textColor = .gray
        
        travelTimeLabel = UILabel()
        self.contentView.addSubview(travelTimeLabel)
        travelTimeLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 8)
        travelTimeLabel.textColor = UIColor(red: 41/255, green: 72/255, blue: 226/255, alpha: 1.0)
        
        travelTimeLabel.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().inset(10)
            make.top.equalTo(station.snp.top).offset(2)
        }
        
        container.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(leftContainer.snp.right).offset(10)
            make.right.equalToSuperview()
            make.top.equalTo(departuresEveryLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        stopsLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(leftContainer.snp.right).offset(10)
            make.centerY.equalToSuperview().offset(3)
        }
    }
    
    func set(transport: NumberedTransport, travelStage: TravelStage) {
        locationLabel.text = transport.location
        leftContainer.set(transport: transport, travelStage: travelStage)
        stopsLabel.text = "\(transport.numberOfStops) Stops"
        station.text = transport.stop
        travelTimeLabel.text = "\(transport.travelTime)min"
        departuresEveryLabel.text = "Departures every: \(transport.departuresEvery)min"
    }
}

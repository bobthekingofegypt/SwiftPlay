//
//  MapHolderView.swift
//  SwiftPlay
//
//  Created by Richard Martin on 14/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import UIKit
//import MapKit
import Mapbox

class MapHolderView: UIView {
    var v: UIView!
    var mapView: MGLMapView!
    //var mapView: MKMapView!
    
    init() {
        super.init(frame: CGRect.zero)
        self.isUserInteractionEnabled = true
        self.backgroundColor = .clear
        
        v = UIView()
        self.addSubview(v)
        v.backgroundColor = .clear
        //Mapbox throws a bunch of warnings to console if you dont initialise it with a size
        mapView = MGLMapView(frame: CGRect(x: 0, y: 0, width: 64, height: 64), styleURL: MGLStyle.lightStyleURL())
        v.addSubview(mapView)
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 13, animated: false)
        
        v.snp.makeConstraints { (make) -> Void in
            make.top.left.width.equalToSuperview()
            make.height.equalTo(200)
        }
        
        mapView.snp.makeConstraints { (make) -> Void in
            make.top.left.width.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateIn() {
        let frame = mapView.frame
        v.alpha = 0
        v.frame = CGRect(x: 0, y: self.frame.height, width: frame.width, height: frame.height)
        UIView.animate(withDuration: 0.8, delay: 0.8, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.v.frame = frame
            self.v.alpha = 1.0
        }, completion: nil)
    }
}

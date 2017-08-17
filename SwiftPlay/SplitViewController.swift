//
//  SplitViewController.swift
//  SwiftPlay
//
//  Created by Richard Martin on 04/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import UIKit
import SnapKit

class SplitViewController: UIViewController, DragHandleTouchDelegate, DepartureListViewControllerDelegate, DragOverlayTouchDelegate {
    var departureListViewController: DepartureListViewController!
    var directionsViewController: DirectionsViewController!
    var dragHandle: DragHandle!
    var dragOverlay: DragOverlayView!
    var topConstraint: Constraint? = nil
    var topOpened: Bool = false
    var routes: [Route]?
    var mapHolderView: MapHolderView!
    
    override func loadView() {
        super.loadView()
        
        let bundle = Bundle.main
        let path = bundle.path(forResource: "results", ofType:
            "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        let parser = RoutesJSONParser()
        routes = parser.parse(with: data)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        departureListViewController = DepartureListViewController(routes: routes!)
        departureListViewController.delegate = self
        directionsViewController = DirectionsViewController(route: routes![0])
        
        self.addChildViewController(departureListViewController)
        self.view.addSubview(departureListViewController.view)
        departureListViewController.didMove(toParentViewController: self)
        
        self.addChildViewController(directionsViewController)
        self.view.addSubview(directionsViewController.view)
        directionsViewController.didMove(toParentViewController: self)
        
        dragHandle = DragHandle()
        dragHandle.delegate = self
        self.view.addSubview(dragHandle)
        
        dragOverlay = DragOverlayView()
        dragOverlay.delegate = self
        self.view.addSubview(dragOverlay)
        
        mapHolderView = MapHolderView()
        self.view.addSubview(mapHolderView)
        
        //Cant quite figure out a nice way to do the map pushing off screen with just constraints
        //so manually working out a height to force on the directions controller view so we can
        //force the map to shrink as the directions view has a higher priority
        let directionsHeight = self.view.frame.height - 200 - 8 - 60
        
        mapHolderView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(directionsViewController.view.snp.bottom).priority(500)
            make.height.lessThanOrEqualTo(200).priority(400)
            make.height.equalTo(200).priority(403)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        departureListViewController.view.snp.makeConstraints { (make) -> Void in
            make.left.top.width.equalToSuperview()
            make.height.equalTo(60).priority(250)
            make.bottom.equalTo(dragHandle.snp.top)
        }
        
        directionsViewController.view.snp.makeConstraints { (make) -> Void in
            make.left.width.equalToSuperview()
            make.bottom.equalTo(mapHolderView.snp.top)
            make.top.equalTo(dragHandle.snp.bottom)
            make.height.equalTo(directionsHeight).priority(900)
        }
        
        dragHandle.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(8)
            make.width.equalToSuperview()
            self.topConstraint = make.top.equalTo(60).constraint
        }
        
        dragOverlay.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(DepartureListViewController.kCellHeight)
            make.width.equalToSuperview()
            make.bottom.equalTo(dragHandle.snp.top)
        }
    }
    
    func departureSelected(indexPath: IndexPath, route: Route) {
        directionsViewController.set(route: route)
        UIView.animate(withDuration: Double(0.5), delay: Double(0.0), options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.topConstraint?.update(offset: 60)
            self.view.layoutIfNeeded()
            //coupling is real, probably shouldn't call into these things
            self.departureListViewController.myTableView.scrollToRow(at: indexPath, at: .middle, animated: false)
            //this doesn't actually work properly, they do not all animate on resize
            self.departureListViewController.adjustCellAlpha()
        })
        
        mapHolderView.animateIn()
        
        setOpened(false)
    }
    
    func setOpened(_ opened: Bool) {
        topOpened = opened
        dragOverlay.isHidden = topOpened
        self.departureListViewController.myTableView.isUserInteractionEnabled = opened
    }
    
    func dragTouchMoved(touch: UITouch) {
        var y: CGFloat = touch.location(in: self.view).y
        //TODO clean up
        // make sure the views above and below are not too small
        y = max(y, departureListViewController.view.frame.origin.y + DepartureListViewController.kCellHeight)
        y = min(y, directionsViewController.view.frame.origin.y + directionsViewController.view.frame.size.height - (0 + 100))
        
        self.topConstraint?.update(offset: y)
        self.view.layoutIfNeeded()
        
        self.departureListViewController.myTableView.scrollToRow(at: departureListViewController.selectedIndexPath, at: .middle, animated: false)
    }
    
    func dragTouchEnded(touch: UITouch) {
        if topOpened {
            UIView.animate(withDuration: Double(0.5), delay: Double(0.0), options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.topConstraint?.update(offset: 60)
                self.view.layoutIfNeeded()
                for case let cell as DepartureListTableViewCell in self.departureListViewController.myTableView.visibleCells {
                    if cell.cellSelected {
                     cell.contentView.alpha = 1   
                    } else {
                     cell.contentView.alpha = 0   
                    }
                }
            }, completion: { (complete) in
            })
        } else {
            UIView.animate(withDuration: Double(0.5), delay: Double(0.0), options: [.beginFromCurrentState, .curveEaseOut], animations: {
                self.topConstraint?.update(offset: 300)
                self.view.layoutIfNeeded()
            }, completion: { (complete) in
            })
        }
        
        setOpened(!topOpened)
    }
    
    func dragHandleTouchBegan(dragHandle: DragHandle, touch: UITouch) {
        
    }
    
    func dragHandleTouchMoved(dragHandle: DragHandle, touch: UITouch) {
        dragTouchMoved(touch: touch)
    }
    
    func dragHandleTouchEnded(dragHandle: DragHandle, touch: UITouch) {
        dragTouchEnded(touch: touch)
    }
    
    func dragOverlayTouchBegan(dragOverlay: DragOverlayView, touch: UITouch) {
        
    }
    
    func dragOverlayTouchMoved(dragOverlay: DragOverlayView, touch: UITouch) {
        dragTouchMoved(touch: touch)
    }
    
    func dragOverlayTouchEnded(dragOverlay: DragOverlayView, touch: UITouch) {
        dragTouchEnded(touch: touch)
    }
}


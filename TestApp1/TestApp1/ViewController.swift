//
//  ViewController.swift
//  TestApp1
//
//  Created by lim on 4/3/19.
//  Copyright © 2019 lim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var views: [UIView]!
    
    var viewDict: [UITouch: [UIView]] = [:]
    
    var viewsInUse: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func underlyingViewsFor(view: UIView) -> [UIView] {
        var result: [UIView] = []
        
        guard let index = self.view.subviews.firstIndex(of: view) else { return result }
        if index - 1 >= 0 {
            for i in 0...index - 1 {
                let tview = self.view.subviews[i]
                if views.contains(tview) && !viewsInUse.contains(tview) {
                    if view.frame.intersects(tview.frame) {
                        result.append(tview)
                    }
                }
            }
        }
        
        return result
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let view = touch.view {
                if views.contains(view) && !viewsInUse.contains(view) {
                    viewDict[touch] = [view]
                    viewsInUse.append(view)
                    
                    viewDict[touch]?.append(contentsOf: underlyingViewsFor(view: view))
                    viewsInUse.append(contentsOf: underlyingViewsFor(view: view))
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("\n")
        print(touches)

        for touch in touches {
            if let viewArray = viewDict[touch] {
                for view in viewArray {
                    let point = touch.location(in: view)
                    let prevPoint = touch.previousLocation(in: view)

                    let center: CGPoint = CGPoint(x : view.center.x + point.x - prevPoint.x, y : view.center.y + point.y - prevPoint.y)
                    
                    view.center = center
                    
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let viewArray = viewDict[touch] {
                for view in viewArray {
                    let point = touch.location(in: view)
                    let prevPoint = touch.previousLocation(in: view)
                    
                    let center: CGPoint = CGPoint(x : view.center.x + point.x - prevPoint.x, y : view.center.y + point.y - prevPoint.y)
                    
                    view.center = center
                    
                    if let index = viewsInUse.firstIndex(of: view) {
                        viewsInUse.remove(at: index)
                    }
                }
                viewDict.removeValue(forKey: touch)
            }
        }
    }
    
}


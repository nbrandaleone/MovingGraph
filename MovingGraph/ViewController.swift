//
//  ViewController.swift
//  MovingGraph
//
//  Created by Nick Brandaleone on 5/19/15.
//  Copyright (c) 2015 Nick Brandaleone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var graphView: GraphView!
    
    var values = [Int]()
    var clockTimer: NSTimer?
    let delayInSeconds = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(graphView)
        self.startUpdating()
    }
    
    // Delay before firing off task on main run loop or queue
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateValues() {
        
        // Add a random number
        var nextValue = Int(arc4random_uniform(100))
        self.values.append(nextValue)
       println("new value: \(nextValue)")
        graphView.graphPoints = values
        graphView.setNeedsDisplay()
    }
    
    func startUpdating() {
        stopUpdating()
    
        println("Starting to update values:")
        clockTimer = NSTimer.scheduledTimerWithTimeInterval(delayInSeconds, target: self, selector: "updateValues", userInfo: nil, repeats: true)
    }
    
    func stopUpdating() {
        if let timer = clockTimer {
            timer.invalidate()
            clockTimer = nil
        }
    }
}


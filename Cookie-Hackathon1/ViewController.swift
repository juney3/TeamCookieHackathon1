//
//  ViewController.swift
//  Cookie-Hackathon1
//
//  Created by Team Cookie - Coding Dojo on 1/12/17.
//  Copyright © 2017 Team Cookie - Codjing Dojo. All rights reserved.
//  Developers: Stefanie Fluin, June Yoshii, Calvin Nguyen, Michael Imgrund
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var distanceResultLabel: UILabel!
    
    var startTime = Date()
    var time: Double = 0.0
    var acceleration: Double = 0.0
    var velocity: Double = 0.0
    var distance: Double = 0.0
    let myColor = UIColor (red:53/255.0, green:169/255.0, blue:255/255.0, alpha:1.0)
    
    @IBOutlet weak var appNameLabel: UIButton!
    
    var motionManager: CMMotionManager?
    
    @IBAction func resestHomePressed(_ sender: UIButton) {
        distanceResultLabel.isHidden = true
        resetVariables()
    }
    
    @IBAction func startButtonPressedDown(_ sender: UIButton) {
        sender.backgroundColor = UIColor.red
        startStopButton.setTitle("Release to Stop", for: .normal)
        distanceResultLabel.isHidden = true
        resetVariables()
        startTime = Date()
//        print("startime: \(startTime)")
        motionManager = CMMotionManager()
        if let manager = motionManager {
            let myQ = OperationQueue()
            manager.deviceMotionUpdateInterval = 0.5
            //            if didStart {
            manager.startDeviceMotionUpdates(to: myQ) {
                (data:CMDeviceMotion?, error: Error?) in
                if let myData = data {
                    self.acceleration = myData.userAcceleration.x
//                    print("acceleration-x", acceleration.x)
                }
            }
        }
    }
    
    @IBAction func stopButtonPressedUp(_ sender: UIButton) {
        startStopButton.setTitle("Press to Start", for: .normal)
        sender.backgroundColor = myColor
        distanceResultLabel.backgroundColor = myColor
        distanceResultLabel.isHidden = false
        motionManager?.stopDeviceMotionUpdates()
        time = Double(Date().timeIntervalSince(startTime))
//        print("time difference: \(time)")
        calculateDistance()
        distanceResultLabel.text = String(Double(round(distance * 100)/100)) + " in"
        distanceResultLabel.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appNameLabel.setTitle("Measure Ninja", for: .normal)
        appNameLabel.backgroundColor = UIColor.white
        distanceResultLabel.isHidden = true
    }
    
    func resetVariables() {
        velocity = 0.0
        distance = 0.0
        acceleration = 0.0
        time = 0.0
    }
    
    func degrees(radians: Double) -> Double {
        return 180 / Double.pi * radians
    }
    
    func calculateDistance() {
//        print("accel \(acceleration)")
//        print("time \(time)")
        if acceleration < 0 {
            acceleration *= -1
        }
//        print("accel2 \(acceleration)")
        velocity = Double(acceleration) * time
//        print("velocity \(velocity)")
        let rawDistance = velocity * time * 9.8 * 39.37 // 1.10159 m/s2 43.369 in/s2
        distance = rawDistance.squareRoot()
//        print("dist \(distance) inches")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


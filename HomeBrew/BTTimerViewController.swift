//
//  BTTimer.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 7/13/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation
import UIKit

class BTTimerViewController : UIViewController {
    
    @IBOutlet var viewArray: [UIView]!
    @IBOutlet var textFieldArray: [UIView]!
    @IBOutlet var buttonArray: [UIButton]!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var minTextField: UITextField!
    
    @IBOutlet weak var timerStartButton: UIButton!
    @IBOutlet weak var timerResetButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var minutes: Double = 0
    var seconds: Double = 0
    var startTime: TimeInterval = 0.0
    var brewTimer = Timer()
    
    var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let themeColor = UIColor(netHex: BSColor.brewSnobBlack())
        UIView.hr_setToastThemeColor(color: themeColor)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BTTimerViewController.didTapOnScreen(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(BTTimerViewController.goBack(_:)))
        swipeGesture.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeGesture)
        
        applyStyle()
        
        let wasRunning: Bool = UserDefaults.standard.bool(forKey: "timerIsRunning")
        if wasRunning {
            becameActive()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BTTimerViewController.becameActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BTTimerViewController.resignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // #pragma mark - Private
    func startBrewTimer()
    {
        self.minutes = (self.minTextField.text! as NSString).doubleValue
        UserDefaults.standard.set(self.minutes, forKey: "inputTime")
        
        self.startTime = self.minutes * 60
        
        self.brewTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(BTTimerViewController.countdown), userInfo: nil, repeats: true)
    }
    
    @objc func countdown()
    {
        if (self.startTime > 0) {
            
            self.startTime -= 1
            
            let timeLong: CLong = lround(self.startTime)
            
            let minutes = (timeLong / 60) % 60
            let seconds = timeLong % 60
            
            self.timerLabel.text = String(format: "00:%02d:%02d", minutes, seconds)
            
            UserDefaults.standard.set(self.startTime, forKey: "brewTime")
            
        } else {
            resetTimer()
            displayNotification()
        }
    }
    
    @objc func becameActive() {
        
        // reset UI
        self.minTextField.text = "\(UserDefaults.standard.double(forKey: "inputTime"))"
        
        self.isTimerRunning = true
        self.timerStartButton.setTitle("Stop", for: UIControlState())
        self.timerStartButton.backgroundColor = UIColor.init(netHex: 0xFF6666)
        
        self.startTime = UserDefaults.standard.double(forKey: "brewTime")
        
        self.brewTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(BTTimerViewController.countdown), userInfo: nil, repeats: true)
    }
    
    @objc func resignActive() {
        self.brewTimer.invalidate()
    }
    
    func applyStyle()
    {
        self.view.backgroundColor = UIColor(netHex: BSColor.brewSnobBackgroundColor())
        self.topView.backgroundColor = UIColor(netHex: BSColor.brewSnobGreen())
        
        for button in buttonArray {
            button.layer.cornerRadius = 4
        }
        
        for view in viewArray {
            view.layer.cornerRadius = 4
            view.backgroundColor = UIColor.init(netHex: BSColor.brewSnobGreen())
        }
        
        for textField in textFieldArray {
            textField.layer.cornerRadius = 4
            textField.backgroundColor = UIColor(netHex: BSColor.brewSnobGrey())
        }
    }
    
    func displayNotification() {
        
        let notification = UILocalNotification()
        notification.alertBody = "Brew Timer is done!"
        notification.alertAction = "open"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.fireDate = Date(timeIntervalSinceNow: 1)
        notification.userInfo = ["Open" : "Close"]
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    @objc func didTapOnScreen(_ gesture: UITapGestureRecognizer) {
        for textField in textFieldArray {
            textField.resignFirstResponder()
        }
    }
    
    @objc func goBack(_ gesture: UISwipeGestureRecognizer) {
        
        if self.isTimerRunning {
            resignActive()
        }
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func resetTimer() {
        self.brewTimer.invalidate()
        self.isTimerRunning = false
        UserDefaults.standard.set(self.isTimerRunning, forKey: "timerIsRunning")
        
        self.timerLabel.text = "00:00:00"
        self.timerStartButton.setTitle("Start", for: UIControlState())
        self.timerStartButton.backgroundColor = UIColor.init(netHex: 0x83C057)
    }
    
    // #pragma mark - IBActions
    @IBAction func didTapStartTimerButton(_ sender: AnyObject) {
        (sender as! UIView).shake()
        
        if (self.minTextField.text == "") {
            self.view.makeToast(message: "You didn't enter a time!", duration: 2, position: HRToastPositionCenter as AnyObject)
            return;
        }
        
        if (!self.isTimerRunning) {
            
            self.isTimerRunning = true
            self.timerStartButton.setTitle("Stop", for: UIControlState())
            self.timerStartButton.backgroundColor = UIColor.init(netHex: 0xFF6666)
            
            UserDefaults.standard.set(self.isTimerRunning, forKey: "timerIsRunning")
            
            startBrewTimer()
            
        } else {
            resetTimer()
        }
    }
    
    @IBAction func didTapTimerResetButton(_ sender: AnyObject) {
        (sender as! UIView).shake()
        self.brewTimer.invalidate()
        startBrewTimer()
    }
    
    @IBAction func didTapBackButton(_ sender: AnyObject) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
}

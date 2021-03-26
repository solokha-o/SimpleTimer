//
//  TimerModel.swift
//  SimpleTimer WatchKit Extension
//
//  Created by Oleksandr Solokha on 23.03.2021.
//

import Foundation
// create protocol to pass data from TimerModel
protocol TimerModelDelegate {
    //pass display string
    func didReceiveTimerDisplayString(from secondsString: String, and minutesString: String, and hoursString: String)
    //pass display digits
    func didReceiveTimerDigits(from seconds : Double, and minutes: Int, and hours: Int)
}

class TimerModel {
    //create Timer instance
    private var timer = Timer()
    //create TimerDigits instance
    var timerDigits = TimerDigits()
    //create TimerDisplay instance
    var timerDisplay = TimerDisplay()
    //create static TimerModel instance
    static var shared = TimerModel()
    //create delegate for to pass data from TimerModel
    var delegate : TimerModelDelegate?
    
    static let zero : Double = 0
    
    private static let timeIntervalSeconds : Double = 0.01
    
    private static let timeInterval : Int = 1
    
    private static let twoDigits : Int = 10
    //configure run timer
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: TimerModel.timeIntervalSeconds, target: self, selector: #selector(timerConfiguration), userInfo: nil, repeats: true)
    }
    //configure stop timer
    func stopTimer() {
        timer.invalidate()
    }
    //configure reset timer
    func resetTimer() {
        timerDigits = TimerDigits()
        timerDisplay = TimerDisplay()
        delegate?.didReceiveTimerDisplayString(from: timerDisplay.secondsString, and: timerDisplay.minutesString, and: timerDisplay.hoursString)
        delegate?.didReceiveTimerDigits(from: timerDigits.seconds, and: timerDigits.minutes, and: timerDigits.hours)
    }
    //configure timer and update display digits and format of display string
    @objc private func timerConfiguration() {
        timerDigits.seconds += TimerModel.timeIntervalSeconds
        if timerDigits.seconds == TimerModel.zero {
            timerDigits.minutes += TimerModel.timeInterval
            if timerDigits.minutes == Int(TimerModel.zero) && timerDigits.seconds == TimerModel.zero {
                timerDigits.hours += TimerModel.timeInterval
            }
        }
        
        if timerDigits.seconds < Double(TimerModel.twoDigits) - TimerModel.timeIntervalSeconds {
            timerDisplay.secondsString = String(format: "%0d%.02f", timerDigits.seconds)
        } else {
            timerDisplay.secondsString = String(format: "%.02f", timerDigits.seconds)
        }
        
        if timerDigits.minutes < TimerModel.twoDigits {
            timerDisplay.minutesString = String(format: "%02d", timerDigits.minutes)
        } else {
            timerDisplay.minutesString = String(timerDigits.minutes)
        }
        
        if timerDigits.hours < TimerModel.twoDigits {
            timerDisplay.hoursString = String(format: "%02d", timerDigits.hours)
        } else {
            timerDisplay.hoursString = String(timerDigits.hours)
        }
        
        delegate?.didReceiveTimerDisplayString(from: timerDisplay.secondsString, and: timerDisplay.minutesString, and: timerDisplay.hoursString)
        
        delegate?.didReceiveTimerDigits(from: timerDigits.seconds, and: timerDigits.minutes, and: timerDigits.hours)
        
        print(timerDisplay.hoursString + ":" + timerDisplay.minutesString + ":" + timerDisplay.secondsString)
    }
}

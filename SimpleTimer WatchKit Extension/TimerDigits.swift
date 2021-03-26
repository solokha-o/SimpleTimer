//
//  TimerDigits.swift
//  SimpleTimer WatchKit Extension
//
//  Created by Oleksandr Solokha on 23.03.2021.
//

import Foundation

struct TimerDigits {
    //create maximum parameters for tamer digits
    private static let maxSeconds : Double = 59.99
    
    private static let maxMinutes : Int = 59
    
    private static let maxHours : Int = 23
    //create and configure seconds
    var seconds : Double {
        didSet {
            if seconds > TimerDigits.maxSeconds {
                seconds = 0.0
            }
        }
    }
    //create and configure minutes
    var minutes : Int {
        didSet {
            if minutes > TimerDigits.maxMinutes {
                minutes = 0
            }
        }
    }
    //create and configure hours
    var hours : Int {
        didSet {
            if hours > TimerDigits.maxHours {
                hours = 0
            }
        }
    }
    
    init() {
        seconds = 0.0
        minutes = 0
        hours = 0
    }
}

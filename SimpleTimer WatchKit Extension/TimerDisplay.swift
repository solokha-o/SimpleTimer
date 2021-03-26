//
//  TimerDisplay.swift
//  SimpleTimer WatchKit Extension
//
//  Created by Oleksandr Solokha on 23.03.2021.
//

import Foundation
//create timer's display with default values
struct TimerDisplay {
    var secondsString : String
    var minutesString : String
    var hoursString : String
    
    init() {
        secondsString = "00.00"
        minutesString = "00"
        hoursString = "00"
    }
}

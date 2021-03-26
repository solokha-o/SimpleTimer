//
//  InterfaceController.swift
//  SimpleTimer WatchKit Extension
//
//  Created by Oleksandr Solokha on 22.03.2021.
//

import WatchKit
import Foundation
import SpriteKit


class InterfaceController: WKInterfaceController {
    //create and configure timer's state
    enum State {
        case runTimer, stopTimer
        
        var titleButton : String {
            switch self {
                case .runTimer: return "Stop"
                case .stopTimer: return "Start"
            }
        }
        
        var colorButton : UIColor {
            switch self {
                case .runTimer: return .red
                case .stopTimer: return .green
            }
        }
    }
    //add and configure all components of timer
    @IBOutlet private weak var hoursLabel: WKInterfaceLabel! {
        didSet {
            hoursLabel.setText(TimerModel.shared.timerDisplay.hoursString + InterfaceController.separator)
        }
    }
    @IBOutlet private weak var minutesLabel: WKInterfaceLabel! {
        didSet {
            minutesLabel.setText(TimerModel.shared.timerDisplay.minutesString + InterfaceController.separator)
        }
    }
    @IBOutlet private weak var secondsLabel: WKInterfaceLabel! {
        didSet {
            secondsLabel.setText(TimerModel.shared.timerDisplay.secondsString)
        }
    }
    @IBOutlet weak var resetTimerButtonOutlet: WKInterfaceButton! {
        didSet {
            resetTimerButtonOutlet.setTitle("Reset")
            resetTimerButtonOutlet.setBackgroundColor(.darkGray)
        }
    }
    @IBOutlet private weak var startStopTimerButtonOutlet: WKInterfaceButton! {
        didSet {
            startStopTimerButtonOutlet.setTitle(timerState.titleButton)
            startStopTimerButtonOutlet.setBackgroundColor(timerState.colorButton)
        }
    }
    @IBOutlet weak var timerCircleScene: WKInterfaceSKScene!
        
    private static let separator = ":"
    
    private var timerState = State.stopTimer
    
    private var isRunTimer = false
    
    private var endSeconds = TimerModel.zero
    
    private var endMinutes = TimerModel.zero
    
    private var endHours = TimerModel.zero
    
    
    override func awake(withContext context: Any?) {
        
        super.awake(withContext: context)
        //add delegate for pass data from model to controller
        TimerModel.shared.delegate = self
        //setup timer to controller with animated circles
        setTimerCircle()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    //configure timer's start-stop button
    @IBAction private func startStopTimerButtonAction() {
        controlTimer()
        isRunTimer.toggle()
        self.animate(withDuration: 1) {
            self.startStopTimerButtonOutlet.setTitle(self.timerState.titleButton)
            self.startStopTimerButtonOutlet.setBackgroundColor(self.timerState.colorButton)
        }
    }
    //configure timer's reset button
    @IBAction private func resetTimerButtonAction() {
        TimerModel.shared.resetTimer() 
    }
    //configure timer's state with changes by start-stop button
    private func controlTimer() {
        if isRunTimer {
            TimerModel.shared.stopTimer()
            timerState = .stopTimer
        } else {
            TimerModel.shared.runTimer()
            timerState = .runTimer
        }
    }
    //configure timer's setup with animated circles
    private func setTimerCircle() {
        let radius : CGFloat  = 45
        let lineWidth : CGFloat = 15
        let scene = SKScene(size: CGSize(width: 120, height: 120))
        scene.scaleMode = .aspectFit
        scene.backgroundColor = .black
        timerCircleScene.presentScene(scene)
        let secondsCircle = UIBezierPath(arcCenter: .zero,
                                         radius: radius,
                                         startAngle: CGFloat(TimerModel.zero),
                                         endAngle: .pi * CGFloat(endSeconds) / 30,
                                         clockwise: true).cgPath
        let secondsShape = SKShapeNode(path: secondsCircle)
        secondsShape.strokeColor = .red
        secondsShape.lineWidth = lineWidth
        secondsShape.lineCap = .round
        secondsShape.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        scene.addChild(secondsShape)
        let minutesCircle = UIBezierPath(arcCenter: .zero,
                                         radius: radius - lineWidth,
                                         startAngle: CGFloat(TimerModel.zero),
                                         endAngle: .pi * CGFloat(endMinutes) / 30,
                                         clockwise: true).cgPath
        let minutesShape = SKShapeNode(path: minutesCircle)
        minutesShape.strokeColor = .green
        minutesShape.lineWidth = lineWidth
        minutesShape.lineCap = .round
        minutesShape.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        scene.addChild(minutesShape)
        let hoursCircle = UIBezierPath(arcCenter: .zero,
                                       radius: radius - 2 * lineWidth,
                                       startAngle: CGFloat(TimerModel.zero),
                                       endAngle: .pi * CGFloat(endHours) / 12,
                                       clockwise: true).cgPath
        let hoursShape = SKShapeNode(path: hoursCircle)
        hoursShape.strokeColor = .blue
        hoursShape.lineWidth = lineWidth
        hoursShape.lineCap = .round
        hoursShape.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        scene.addChild(hoursShape)
    }
}
//configure to receive data to controller
extension InterfaceController: TimerModelDelegate {
    func didReceiveTimerDigits(from seconds: Double, and minutes: Int, and hours: Int) {
        endSeconds = seconds
        endMinutes = Double(minutes)
        endHours = Double(hours)
        setTimerCircle()
    }
    
    func didReceiveTimerDisplayString(from secondsString: String, and minutesString: String, and hoursString: String) {
        secondsLabel.setText(secondsString)
        minutesLabel.setText(minutesString + InterfaceController.separator)
        hoursLabel.setText(hoursString + InterfaceController.separator)
    }
}

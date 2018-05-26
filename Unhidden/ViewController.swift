//
//  ViewController.swift
//  Unhidden
//
//  Created by Rayhan on 9/17/17.
//  Copyright © 2017 Rayhan. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    lazy var window: NSWindow! = self.view.window
    
    @IBOutlet weak var lblStatus: NSTextField!
    @IBOutlet weak var toggleButton: OGSwitch!
    
    let command: String = "/usr/bin/env"
    let readArgs: [String] = ["defaults", "read", "com.apple.finder", "AppleShowAllFiles"]
    let writeYesArgs: [String] = ["defaults", "write", "com.apple.finder", "AppleShowAllFiles", "Yes"]
    let writeNoArgs: [String] = ["defaults", "write", "com.apple.finder", "AppleShowAllFiles", "No"]
    
    override func viewWillAppear() {
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toggleButton.delegate = self
        toggleButton.isOn = false
        
        let statusCheck = Shell(withCommandPath: command, andArguments: readArgs)
        let (output, error, status) = statusCheck.run()
        if status == 0 && error[0] == "" {
            
            print(output[0])
            
            switch output[0] {
            case "YES", "Yes", "yes":
                setSwitch(toState: .switchOn, withRelaunch: false)
            case "NO", "No", "no":
                setSwitch(toState: .switchOff, withRelaunch: false)
            default:
                lblStatus.textColor = NSColor.white
                lblStatus.stringValue = "N/A"
            }
        }
    }
}

extension ViewController: SwitchDelegate {
    
    func switchToggled() {
        
        if toggleButton.isOn {
            setSwitch(toState: .switchOn, withRelaunch: true)
        } else {
            setSwitch(toState: .switchOff, withRelaunch: true)
        }
    }
    
    // switch function
    
    private func setSwitch(toState state : SwitchState, withRelaunch relaunch: Bool) {
        
        switch state {
        case .switchOn:
            let redOp = Shell(withCommandPath: command, andArguments: writeYesArgs)
            let (_, error, status) = redOp.run()
            
            if status == 0 && error[0] == "" {
                lblStatus.textColor = NSColor(calibratedRed:0.27, green: 0.86, blue: 0.36, alpha: 1.0)
                lblStatus.stringValue = "YES"
                toggleButton.setOn(isOn: true, animated: true)
            }
            
        case .switchOff:
            let redOp = Shell(withCommandPath: command, andArguments: writeNoArgs)
            let (_, error, status) = redOp.run()
            
            if status == 0 && error[0] == "" {
                lblStatus.textColor = NSColor(deviceRed: 255/255, green: 102/255, blue: 102/255, alpha: 1)
                lblStatus.stringValue = "NO"
                toggleButton.setOn(isOn: false, animated: true)
            }
        }
        
        if relaunch {
            let (_, _, _) = Shell(withCommandPath: "/usr/bin/killall", andArguments: ["Finder"]).run()
        }
    }
}


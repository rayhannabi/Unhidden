//
//  MainViewController.swift
//  Unhidden
//
//  Created by Rayhan on 9/17/17.
//  Copyright © 2017 Rayhan. All rights reserved.
//

import Cocoa
import RNShell

class MainViewController: NSViewController {
  
  lazy var window: NSWindow! = self.view.window
  
  @IBOutlet weak var lblStatus: NSTextField!
  @IBOutlet weak var toggleButton: OGSwitch!
  
  private let onColor = NSColor(calibratedRed: 69/255, green: 220/255, blue: 92/255, alpha: 1.0)
  private let offColor = NSColor(calibratedRed: 255/255, green: 102/255, blue: 102/255, alpha: 1.0)
  
  let command: String = "/usr/bin/env"
  let readArgs: [String] = ["defaults", "read", "com.apple.finder", "AppleShowAllFiles"]
  let writeYesArgs: [String] = ["defaults", "write", "com.apple.finder", "AppleShowAllFiles", "Yes"]
  let writeNoArgs: [String] = ["defaults", "write", "com.apple.finder", "AppleShowAllFiles", "No"]
  
  // MARK: - Life cycle Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    toggleButton.delegate = self
    toggleButton.isOn = false
    checkCurrentStatus()
  }
  
  override func viewWillAppear() {
    window.titlebarAppearsTransparent = true
    window.titleVisibility = .hidden
  }
  
  // MARK: - Private methods
  
  fileprivate func checkCurrentStatus() {
    let shellForStatus = RNShell()
    let result = shellForStatus.run(command: Constants.Commands.read)
    
    guard let output = result.firstLineOfOutput else {
      lblStatus.textColor = NSColor.white
      lblStatus.stringValue = "N/A"
      return
    }
    print(output)
    switch output {
    case "YES", "Yes", "yes":
      setSwitchOn()
    case "NO", "No", "no":
      setSwitchOff()
    default:
      return
    }
  }
  
  fileprivate func setSwitch(to state: OGSwitchState) {
    switch state {
    case .on:
      lblStatus.textColor = Constants.Colors.switchOn
      lblStatus.stringValue = "YES"
      toggleButton.setOn(isOn: true, animated: true)
    case .off:
      lblStatus.textColor = Constants.Colors.switchOff
      lblStatus.stringValue = "NO"
      toggleButton.setOn(isOn: false, animated: true)
    }
  }
  
  fileprivate func setHiddenFileSettings(value: Bool) -> Bool {
    let shell = RNShell()
    let command = value ? Constants.Commands.writeYes : Constants.Commands.writeNo
    let result = shell.run(command: command)
    
    if result.firstLineOfError != nil &&
      result.status != 0 {
      return false
    }
    
    return true
  }
  
  fileprivate func setSwitchOn() {
    let success = setHiddenFileSettings(value: true)
    if success {
      setSwitch(to: .on)
    }
  }
  
  fileprivate func setSwitchOff() {
    let success = setHiddenFileSettings(value: false)
    if success {
      setSwitch(to: .off)
    }
  }
  
  fileprivate func relaunchFinder() {
    let shell = RNShell(path: Constants.Commands.killallPath)
    shell.run(command: Constants.Commands.finder)
  }
  
}

// MARK: - SwitchDelegate

extension MainViewController: SwitchDelegate {
  
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
        lblStatus.textColor = onColor
        lblStatus.stringValue = "YES"
        toggleButton.setOn(isOn: true, animated: true)
      }
      
    case .switchOff:
      let redOp = Shell(withCommandPath: command, andArguments: writeNoArgs)
      let (_, error, status) = redOp.run()
      
      if status == 0 && error[0] == "" {
        lblStatus.textColor = offColor
        lblStatus.stringValue = "NO"
        toggleButton.setOn(isOn: false, animated: true)
      }
    }
    
    if relaunch {
      let (_, _, _) = Shell(withCommandPath: "/usr/bin/killall", andArguments: ["Finder"]).run()
    }
  }
  
}

// MARK: - OGSwitchDelegate

extension MainViewController: OGSwitchDelegate {
  
  // FIXME: - Update relaunch
  func didToggle(_ switch: OGSwitch) {
    switch toggleButton.isOn {
    case true:
      setSwitchOff()
      relaunchFinder()
    case false:
      setSwitchOn()
      relaunchFinder()
    }
  }
  
}

//
//  OGSwitchDelegate.swift
//  Unhidden
//
//  Created by Rayhan Nabi on 2/24/19.
//  Copyright © 2019 Rayhan. All rights reserved.
//

import Foundation

protocol OGSwitchDelegate: AnyObject {
  func didToggle(_ switch: OGSwitch)
}

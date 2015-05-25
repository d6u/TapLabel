//
//  TapLabelDelegate.swift
//  TapLabel
//
//  Created by Daiwei Lu on 5/25/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

protocol TapLabelDelegate: class {

    func tapLabel(tapLabel: TapLabel, didSelectLink link: String)

}

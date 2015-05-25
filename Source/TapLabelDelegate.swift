//
//  TapLabelDelegate.swift
//  TapLabel
//
//  Created by Daiwei Lu on 5/25/15.
//
//

import Foundation

public protocol TapLabelDelegate: class {

    func tapLabel(tapLabel: TapLabel, didSelectLink link: String)

}

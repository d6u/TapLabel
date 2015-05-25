//
//  ViewController.swift
//  Example
//
//  Created by Daiwei Lu on 5/25/15.
//
//

import UIKit
import TapLabel

class ViewController: UIViewController, TapLabelDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tapLabel(tapLabel: TapLabel, didSelectLink link: String) {

    }
}


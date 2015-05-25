//
//  ViewController.swift
//  TapLabel
//
//  Created by Daiwei Lu on 5/25/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {

        let label = TapLabel(frame: CGRect(x: 20, y: 40, width: 280, height: 400))

        let text = "The length of a #KILabel is unrestricted, unlike the length of a " +
            "tweet. Tweets are limited to 140 characters, here's long link to " +
            "explain why this is the case http://www.adweek.com/socialtimes/the-reason-for-the-160-character-text-message-and-140-character-twitter-length-limits/4914."

        let attText = NSMutableAttributedString(string: text, attributes: [
            NSFontAttributeName: UIFont.systemFontOfSize(16)
        ])

        attText.addAttribute(TapLabelLinkTypeName, value: "123123", range: NSMakeRange(10, 20))

        label.attributedText = attText

        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0

        view.addSubview(label)

        label.sizeToFit()

        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


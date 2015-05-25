//
//  TapLabel.swift
//  TapLabel
//
//  Created by Daiwei Lu on 5/25/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit

let TapLabelLinkTypeName = "TapLabelLinkTypeName"

class TapLabel: UILabel, NSLayoutManagerDelegate {

    private let layoutManager = NSLayoutManager()
    private let textContainer = NSTextContainer()
    private let textStorage = NSTextStorage()
    private var rangesForUrls = [NSRange]()
    private var links = [String: NSRange]()
    private var isTouchMoved = false
    private var selectedLink: String?

    override var lineBreakMode: NSLineBreakMode {
        didSet {
            textContainer.lineBreakMode = lineBreakMode
        }
    }

    override var numberOfLines: Int {
        didSet {
            textContainer.maximumNumberOfLines = numberOfLines
        }
    }

    override var attributedText: NSAttributedString! {
        didSet {
            textStorage.setAttributedString(attributedText)
            updateLinks()
            updateRangesForUrls()
        }
    }

    override var frame: CGRect {
        didSet {
            textContainer.size = frame.size
        }
    }

    override var bounds: CGRect {
        didSet {
            textContainer.size = bounds.size
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.size = frame.size

        layoutManager.addTextContainer(textContainer)
        layoutManager.delegate = self

        textStorage.addLayoutManager(layoutManager)

        userInteractionEnabled = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateLinks() {
        attributedText.enumerateAttribute(TapLabelLinkTypeName,
            inRange: NSMakeRange(0, attributedText.length),
            options: NSAttributedStringEnumerationOptions(0))
        {
            value, range, stop in

            if let v = value as? String {
                println(range)
                self.links[v] = range
            }
        }
    }

    func updateRangesForUrls()
    {
        var error: NSError?
        let detector = NSDataDetector(types: NSTextCheckingType.Link.rawValue, error: &error)!
        let plainText = attributedText.string
        let matches = detector.matchesInString(plainText,
            options: NSMatchingOptions(0),
            range: NSMakeRange(0, count(plainText))) as! [NSTextCheckingResult]

        rangesForUrls = matches.map { $0.range }
    }

    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect
    {
        let savedTextContainerSize = textContainer.size
        let savedTextContainerNumberOfLines = textContainer.maximumNumberOfLines

        textContainer.size = bounds.size
        textContainer.maximumNumberOfLines = numberOfLines

        let glyphRange = layoutManager.glyphRangeForTextContainer(textContainer)
        var textBounds = layoutManager.boundingRectForGlyphRange(glyphRange, inTextContainer:textContainer)

        textBounds.origin = bounds.origin
        textBounds.size.width = ceil(textBounds.size.width)
        textBounds.size.height = ceil(textBounds.size.height)

        textContainer.size = savedTextContainerSize
        textContainer.maximumNumberOfLines = savedTextContainerNumberOfLines
        
        return textBounds;
    }

    override func drawTextInRect(rect: CGRect)
    {
        let glyphRange = layoutManager.glyphRangeForTextContainer(textContainer)
        let textOffset = calcTextOffsetForGlyphRange(glyphRange)

        layoutManager.drawBackgroundForGlyphRange(glyphRange, atPoint:textOffset)
        layoutManager.drawGlyphsForGlyphRange(glyphRange, atPoint:textOffset)
    }

    func calcTextOffsetForGlyphRange(glyphRange: NSRange) -> CGPoint
    {
        var textOffset = CGPointZero

        let textBounds = layoutManager.boundingRectForGlyphRange(glyphRange, inTextContainer:textContainer)
        let paddingHeight = (self.bounds.size.height - textBounds.size.height) / 2
        if (paddingHeight > 0) {
            textOffset.y = paddingHeight;
        }

        return textOffset;
    }

    func linkAtPoint(var point: CGPoint) -> String?
    {
        if textStorage.length == 0 {
            return nil
        }

        let glyphRange = layoutManager.glyphRangeForTextContainer(textContainer)
        let textOffset = calcTextOffsetForGlyphRange(glyphRange)

        point.x = point.x - textOffset.x
        point.y = point.y - textOffset.y

        let touchedChar = layoutManager.glyphIndexForPoint(point, inTextContainer:textContainer)

        var lineRange = NSRange()
        let lineRect = layoutManager.lineFragmentUsedRectForGlyphAtIndex(touchedChar, effectiveRange:&lineRange)

        if !CGRectContainsPoint(lineRect, point) {
            return nil
        }

        // Find the word that was touched and call the detection block
        for (link, range) in links {
            if range.location <= touchedChar && touchedChar < range.location + range.length {
                return link
            }
        }
        
        return nil
    }

    //MARK: - Interactions

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        isTouchMoved = false
        selectedLink = nil
        let touchLocation = (touches.first as! UITouch).locationInView(self)

        if let link = linkAtPoint(touchLocation) {
            selectedLink = link
        } else {
            super.touchesBegan(touches, withEvent: event)
        }
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        isTouchMoved = true
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)

        if isTouchMoved {
            return
        }

        println(selectedLink)
    }

    //MARK: - NSLayoutManagerDelegate

    func layoutManager(
        layoutManager: NSLayoutManager,
        shouldBreakLineByWordBeforeCharacterAtIndex charIndex: Int) -> Bool
    {
        for range in rangesForUrls {
            if range.location < charIndex && charIndex < range.location + range.length {
                return false
            }
        }
        return true
    }

}

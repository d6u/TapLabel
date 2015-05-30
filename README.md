# TapLabel

A shameless fork of Krelborn/KILabel that replaces auto link detection with manual adding links.

## Usage

Use `TapLabel.LinkContentName` to apply link to attributed text, and `TapLabel.SelectedForegroudColorName` to specify selected foreground color. TapLabel will not apply any other customized color to text. You have to defined your own.

```swift
let text = NSMutableAttributedString(string: "something contains a link http://google.com")

text.addAttribute(TapLabel.LinkContentName,
    value: "test",
    range: NSMakeRange(26, 42))
text.addAttribute(NSForegroundColorAttributeName,
    value: UIColor.blueColor(),
    range: NSMakeRange(26, 42))
text.addAttribute(TapLabel.SelectedForegroudColorName,
    value: UIColor.redColor(),
    range: NSMakeRange(26, 42))

let label = TapLabel(frame: CGRect(x: 20, y: 40, width: 280, height: 100))
label.attributedText = text
```

### TapLabelDelegate

Delegate property on label must be assigned for tap action to work.

- `func tapLabel(tapLabel: TapLabel, didSelectLink link: String)`

    Will be called once `TapLabel.LinkContentName` specifyed text is tapped. `link` will equal to the value of `TapLabel.LinkContentName`.

<p>
<a href="http://cocoadocs.org/docsets/KeyboardMan"><img src="https://img.shields.io/cocoapods/v/KeyboardMan.svg?style=flat"></a> 
<a href="https://github.com/Carthage/Carthage/"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"></a> 
</p>

# KeyboardMan

We may need keyboard infomation from keyboard notifications to do animation. However, the approach is complicated and easy to make mistakes. Even more, we need to handle the bug of system fire keyboard notifications.

But KeyboardMan will make it simple & easy.

另有[中文介绍](https://github.com/nixzhu/dev-blog/blob/master/2015-07-27-keyboard-man.md)。

## Requirements

Swift 4.2, iOS 8.0

(Swift 3, use version 1.1.0)

## Example

```swift
import KeyboardMan
```

Do animation with keyboard appear/disappear:

```swift
let keyboardMan = KeyboardMan()

keyboardMan.animateWhenKeyboardAppear = { [weak self] appearPostIndex, keyboardHeight, keyboardHeightIncrement in

    print("appear \(appearPostIndex), \(keyboardHeight), \(keyboardHeightIncrement)\n")

    if let self = self {

        self.tableView.contentOffset.y += keyboardHeightIncrement
        self.tableView.contentInset.bottom = keyboardHeight + strongSelf.toolBar.frame.height

        self.toolBarBottomConstraint.constant = keyboardHeight
        self.view.layoutIfNeeded()
    }
}

keyboardMan.animateWhenKeyboardDisappear = { [weak self] keyboardHeight in

    print("disappear \(keyboardHeight)\n")

    if let self = self {

        self.tableView.contentOffset.y -= keyboardHeight
        self.tableView.contentInset.bottom = strongSelf.toolBar.frame.height

        self.toolBarBottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
}
```

For more specific information, you can use keyboardInfo that KeyboardMan post:

```swift
keyboardMan.postKeyboardInfo = { [weak self] keyboardMan, keyboardInfo in
    // TODO
}
```

Check the demo for more information.

## Installation

Feel free to drag `KeyboardMan.swift` to your iOS Project. But it's recommended to use Carthage (or CocoaPods).

### Carthage

```ogdl
github "nixzhu/KeyboardMan"
```

### CocoaPods

```ruby
pod 'KeyboardMan'
```

## Contact

NIX [@nixzhu](https://twitter.com/nixzhu)

## License

KeyboardMan is available under the MIT license. See the LICENSE file for more info.

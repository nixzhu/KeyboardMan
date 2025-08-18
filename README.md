# KeyboardMan

We often need keyboard information from keyboard notifications to drive animations. However, handling these notifications correctly is complicated and error‑prone. Moreover, the system can sometimes fire keyboard notifications inconsistently, which you also have to account for.

KeyboardMan makes this simple and reliable.

另有[中文介绍](https://github.com/nixzhu/dev-blog/blob/main/posts/2015-07-27-keyboard-man.md)。

## Example

```swift
import KeyboardMan
```

Animate when the keyboard appears or disappears:

```swift
// Hold a strong reference
private let keyboardMan = KeyboardMan()
```

```swift
// In viewDidLoad
keyboardMan.animateWhenKeyboardAppear = { [weak self] appearPostIndex, keyboardHeight, keyboardHeightIncrement in
    print("keyboard appear: \(appearPostIndex), \(keyboardHeight), \(keyboardHeightIncrement)")

    guard let self else { return }

    tableView.contentOffset.y += keyboardHeightIncrement
    tableView.contentInset.bottom = toolBar.frame.height + keyboardHeight
    tableView.verticalScrollIndicatorInsets.bottom = tableView.contentInset.bottom

    toolBarBottomConstraint?.constant = keyboardHeight
    view.layoutIfNeeded()
}

keyboardMan.animateWhenKeyboardDisappear = { [weak self] keyboardHeight in
    print("keyboard disappear: \(keyboardHeight)")

    guard let self else { return }

    tableView.contentOffset.y -= keyboardHeight
    tableView.contentInset.bottom = toolBar.frame.height + view.safeAreaInsets.bottom
    tableView.verticalScrollIndicatorInsets.bottom = tableView.contentInset.bottom

    toolBarBottomConstraint?.constant = view.safeAreaInsets.bottom
    view.layoutIfNeeded()
}
```

For more detailed information, you can use the keyboardInfo that KeyboardMan posts:

```swift
// In viewDidLoad
keyboardMan.postKeyboardInfo = { [weak self] keyboardMan, keyboardInfo in
    // TODO
}
```

See the demo for more examples.

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have a Swift package set up, add KeyboardMan as a dependency in your `Package.swift` file:

```swift
// In Package.swift

dependencies: [
    .package(url: "https://github.com/nixzhu/KeyboardMan.git", from: "2.0.0"),
]
```

Typically, you will want to depend on the `KeyboardMan` product:

```swift
// In a target's dependencies

.product(name: "KeyboardMan", package: "KeyboardMan")
```

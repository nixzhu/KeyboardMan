//
//  KeyboardMan.swift
//  Messages
//
//  Created by NIX on 15/7/25.
//  Copyright (c) 2015年 nixWork. All rights reserved.
//

import UIKit

public class KeyboardMan: NSObject {

    var keyboardObserver: NSNotificationCenter? {
        didSet {
            oldValue?.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
            oldValue?.removeObserver(self, name: UIKeyboardDidChangeFrameNotification, object: nil)
            oldValue?.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
            //oldValue?.removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)

            keyboardObserver?.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
            keyboardObserver?.addObserver(self, selector: "keyboardDidChangeFrame:", name: UIKeyboardDidChangeFrameNotification, object: nil)
            keyboardObserver?.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
            //keyboardObserver?.addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
        }
    }

    public var keyboardObserveEnabled = false {
        willSet {
            keyboardObserver = newValue ? NSNotificationCenter.defaultCenter() : nil
        }
    }

    deinit {
        keyboardObserveEnabled = false
    }

    public struct KeyboardInfo {
        let frameBegin: CGRect
        let frameEnd: CGRect
        public let animationDuration: NSTimeInterval
        public let animationCurve: UInt

        public var height: CGFloat {
            return frameEnd.height
        }

        public var heightIncrement: CGFloat

        public enum Action {
            case Show
            case Hide
        }
        public var action: Action
    }

    var keyboardInfo: KeyboardInfo? {
        willSet {
            if let info = newValue {

                print("height begin: \(info.frameBegin.height)\n")

                updatedKeyboardInfo?(info)
            }
        }
    }

    public var updatedKeyboardInfo: (KeyboardInfo -> Void)?

    // MARK: - Actions

    private func handleKeyboard(notification: NSNotification, _ action: KeyboardInfo.Action) {
        if let userInfo = notification.userInfo {
            let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            let animationCurve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).unsignedLongValue
            let frameBegin = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
            let frameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()

            let currentHeight = frameEnd.height

            let previousHeight = keyboardInfo?.height ?? 0
            let heightIncrement = currentHeight - previousHeight

            keyboardInfo = KeyboardInfo(frameBegin: frameBegin, frameEnd: frameEnd, animationDuration: animationDuration, animationCurve: animationCurve, heightIncrement: heightIncrement, action: action)
        }
    }

    func keyboardWillShow(notification: NSNotification) {
        print("willShow\n")
        handleKeyboard(notification, .Show)
    }
    
    func keyboardDidChangeFrame(notification: NSNotification) {
        if let _ = keyboardInfo {
            print("didChangeFrame\n")
            handleKeyboard(notification, .Show)
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        print("willHide\n")
        handleKeyboard(notification, .Hide)
        keyboardInfo = nil
    }

//    func keyboardDidHide(notification: NSNotification) {
//        print("didHide\n")
//        keyboardInfo = nil
//    }
}


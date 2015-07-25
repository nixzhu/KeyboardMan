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

            keyboardObserver?.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
            keyboardObserver?.addObserver(self, selector: "keyboardDidChangeFrame:", name: UIKeyboardDidChangeFrameNotification, object: nil)
            keyboardObserver?.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
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

        public let animationDuration: NSTimeInterval
        public let animationCurve: UInt

        let frameEnd: CGRect
        public var height: CGFloat {
            return frameEnd.height
        }
        public let heightIncrement: CGFloat

        public enum Action {
            case Show
            case Hide
        }
        public let action: Action
    }

    var keyboardInfo: KeyboardInfo? {
        willSet {
            if let info = newValue {
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
            let frameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()

            let currentHeight = frameEnd.height
            let previousHeight = keyboardInfo?.height ?? 0
            let heightIncrement = currentHeight - previousHeight

            keyboardInfo = KeyboardInfo(animationDuration: animationDuration, animationCurve: animationCurve, frameEnd: frameEnd, heightIncrement: heightIncrement, action: action)
        }
    }

    func keyboardWillShow(notification: NSNotification) {

        handleKeyboard(notification, .Show)
    }
    
    func keyboardDidChangeFrame(notification: NSNotification) {

        if let _ = keyboardInfo {
            handleKeyboard(notification, .Show)
        }
    }

    func keyboardWillHide(notification: NSNotification) {

        handleKeyboard(notification, .Hide)

        // make sure `keyboardDidChangeFrame:` not work when hide

        keyboardInfo = nil
    }
}


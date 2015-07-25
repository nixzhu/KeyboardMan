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
            oldValue?.removeObserver(self)

            keyboardObserver?.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
            keyboardObserver?.addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
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
        let isSameAction: Bool
    }

    var keyboardInfo: KeyboardInfo? {
        willSet {
            if let info = newValue {
                if !info.isSameAction || info.heightIncrement > 0 {
                    updatedKeyboardInfo?(info)
                }
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

            let isSameAction: Bool
            if let previousAction = keyboardInfo?.action {
                isSameAction = action == previousAction
            } else {
                isSameAction = false
            }

            keyboardInfo = KeyboardInfo(animationDuration: animationDuration, animationCurve: animationCurve, frameEnd: frameEnd, heightIncrement: heightIncrement, action: action, isSameAction: isSameAction)
        }
    }

    func keyboardWillShow(notification: NSNotification) {

        handleKeyboard(notification, .Show)
    }
    
    func keyboardWillChangeFrame(notification: NSNotification) {

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


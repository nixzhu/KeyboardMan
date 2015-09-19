//
//  ViewController.swift
//  Messages
//
//  Created by NIX on 15/7/25.
//  Copyright (c) 2015年 nixWork. All rights reserved.
//

import UIKit
import KeyboardMan

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var toolBar: UIView!
    @IBOutlet weak var toolBarBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var textField: UITextField!

    var messages: [String] = [
        "How do you do?",
    ]

    let cellID = "cell"

    let keyboardMan = KeyboardMan()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 60
        tableView.contentInset.bottom = toolBar.frame.height
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()

        keyboardMan.keyboardWillShow = {
            print("keyboardWillShow")
        }

        keyboardMan.keyboardDidShow = {
            print("keyboardDidShow")
        }

        keyboardMan.keyboardWillHide = {
            
            print("keyboardWillHide")
        }
        
        keyboardMan.keyboardDidHide = {
            print("keyboardDidHide")
        }
        
        keyboardMan.animateWhenKeyboardAppear = { [weak self] appearPostIndex, keyboardHeight, keyboardHeightIncrement in

            print("appear \(appearPostIndex), \(keyboardHeight), \(keyboardHeightIncrement)\n")

            if let strongSelf = self {

                strongSelf.tableView.contentOffset.y += keyboardHeightIncrement
                strongSelf.tableView.contentInset.bottom = keyboardHeight + strongSelf.toolBar.frame.height

                strongSelf.toolBarBottomConstraint.constant = keyboardHeight
                strongSelf.view.layoutIfNeeded()
            }
        }

        keyboardMan.animateWhenKeyboardDisappear = { [weak self] keyboardHeight in

            print("disappear \(keyboardHeight)\n")

            if let strongSelf = self {

                strongSelf.tableView.contentOffset.y -= keyboardHeight
                strongSelf.tableView.contentInset.bottom = strongSelf.toolBar.frame.height

                strongSelf.toolBarBottomConstraint.constant = 0
                strongSelf.view.layoutIfNeeded()
            }
        }

        keyboardMan.postKeyboardInfo = { keyboardMan, keyboardInfo in

            switch keyboardInfo.action {
            case .Show:
                print("show \(keyboardMan.appearPostIndex), \(keyboardInfo.height), \(keyboardInfo.heightIncrement)\n")
            case .Hide:
                print("hide \(keyboardInfo.height)\n")
            }

            /*
            if let strongSelf = self {

                let duration = keyboardInfo.animationDuration
                let curve = keyboardInfo.animationCurve
                let options = UIViewAnimationOptions(rawValue: curve << 16 | UIViewAnimationOptions.BeginFromCurrentState.rawValue)

                switch keyboardInfo.action {

                case .Show:

                    print("show \(keyboardMan.appearPostIndex), \(keyboardInfo.height), \(keyboardInfo.heightIncrement)\n")

                    UIView.animateWithDuration(duration, delay: 0, options: options, animations: {

                        strongSelf.tableView.contentOffset.y += keyboardInfo.heightIncrement
                        strongSelf.tableView.contentInset.bottom = keyboardInfo.height + strongSelf.toolBar.frame.height

                        strongSelf.toolBarBottomConstraint.constant = keyboardInfo.height
                        strongSelf.view.layoutIfNeeded()

                    }, completion: nil)

                case .Hide:

                    print("hide \(keyboardInfo.height)\n")

                    UIView.animateWithDuration(duration, delay: 0, options: options, animations: {

                        strongSelf.tableView.contentOffset.y -= keyboardInfo.height
                        strongSelf.tableView.contentInset.bottom = strongSelf.toolBar.frame.height

                        strongSelf.toolBarBottomConstraint.constant = 0
                        strongSelf.view.layoutIfNeeded()

                    }, completion: nil)
                }
            }
            */
        }
    }

    // MARK: - Actions

    func sendMessage(textField: UITextField) {

        guard let message = textField.text else {
            return
        }

        if message.isEmpty {
            return
        }

        // update data source

        messages.append(message)

        // insert new row

        let indexPath = NSIndexPath(forRow: messages.count - 1, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

        // scroll up a little bit if need

        let newMessageHeight: CGFloat = tableView.rowHeight

        let blockedHeight = statusBarHeight + navigationBarHeight + toolBar.frame.height + toolBarBottomConstraint.constant
        let visibleHeight = tableView.frame.height - blockedHeight
        let hiddenHeight = tableView.contentSize.height - visibleHeight

        if hiddenHeight + newMessageHeight > 0 {

            let contentOffsetYIncrement = hiddenHeight > 0 ? newMessageHeight : hiddenHeight + newMessageHeight
            print("contentOffsetYIncrement: \(contentOffsetYIncrement)\n")

            UIView.animateWithDuration(0.2) {
                self.tableView.contentOffset.y += contentOffsetYIncrement
            }
        }

        // clear text

        textField.text = ""
    }

}

// MARK: - Bar heights

extension UIViewController {

    var statusBarHeight: CGFloat {

        if let window = view.window {
            let statusBarFrame = window.convertRect(UIApplication.sharedApplication().statusBarFrame, toView: view)
            return statusBarFrame.height

        } else {
            return 0
        }
    }

    var navigationBarHeight: CGFloat {

        if let navigationController = navigationController {
            return navigationController.navigationBar.frame.height

        } else {
            return 0
        }
    }
}

// MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {

        sendMessage(textField)

        return true
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return messages.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(cellID)!

        let message = messages[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row + 1): " + message

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        textField.resignFirstResponder()
    }
}


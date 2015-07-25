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

        keyboardMan.keyboardObserveEnabled = true
        keyboardMan.postKeyboardInfo = { [weak self] keyboardInfo in

            if let strongSelf = self {

                let animationDuration = keyboardInfo.animationDuration
                let animationCurve = keyboardInfo.animationCurve

                switch keyboardInfo.action {

                case .Show:

                    print("show \(keyboardInfo.height), \(keyboardInfo.heightIncrement)\n")

                    UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions(animationCurve << 16), animations: {

                        strongSelf.tableView.contentOffset.y += keyboardInfo.heightIncrement
                        strongSelf.tableView.contentInset.bottom = keyboardInfo.height + strongSelf.toolBar.frame.height

                        strongSelf.toolBarBottomConstraint.constant = keyboardInfo.height
                        strongSelf.view.layoutIfNeeded()

                    }, completion: nil)

                case .Hide:

                    print("hide \(keyboardInfo.height), \(keyboardInfo.heightIncrement)\n")

                    UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions(animationCurve << 16), animations: {

                        strongSelf.tableView.contentOffset.y -= keyboardInfo.height - keyboardInfo.heightIncrement
                        strongSelf.tableView.contentInset.bottom = strongSelf.toolBar.frame.height

                        strongSelf.toolBarBottomConstraint.constant = 0
                        strongSelf.view.layoutIfNeeded()

                    }, completion: nil)
                }
            }
        }
    }

    // MARK: - Actions

    func sendMessage(textField: UITextField) {

        let text = textField.text

        if text.isEmpty {
            return
        }

        // update data source

        let message = text
        messages.append(message)

        // insert new row

        let indexPath = NSIndexPath(forRow: messages.count - 1, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

        // scroll up a little bit if need

        let newMessageHeight: CGFloat = tableView.rowHeight

        let blockedHeight = 64 + toolBar.frame.height + toolBarBottomConstraint.constant
        let visibleHeight = tableView.frame.height - blockedHeight
        let hiddenHeight = tableView.contentSize.height - visibleHeight

        if hiddenHeight + newMessageHeight > 0 {

            let adjustHeight = hiddenHeight > 0 ? newMessageHeight : hiddenHeight + newMessageHeight
            print("adjustHeight: \(adjustHeight)\n\n")

            UIView.animateWithDuration(0.2) {
                self.tableView.contentOffset.y += adjustHeight
            }
        }

        // clear text

        textField.text = ""
    }

}

extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        sendMessage(textField)

        return true
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return messages.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(cellID) as! UITableViewCell

        let message = messages[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row + 1): " + message

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        textField.resignFirstResponder()
    }
}




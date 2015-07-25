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
        "Hello world!",
        "How do you do?",
        "I'm fine, thank you! And you?",
//        "Hello world!",
//        "How do you do?",
//        "I'm fine, thank you! And you?",
//        "Hello world!",
//        "How do you do?",
//        "I'm fine, thank you! And you?",
//        "Hello world!",
//        "How do you do?",
//        "I'm fine, thank you! And you?",
//        "Hello world!",
//        "How do you do?",
//        "I'm fine, thank you! And you?",
    ]

    let cellID = "cell"

    let keyboardMan = KeyboardMan()

    var tableViewContentOffsetBeforeKeyboardShow = CGPointZero

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellID)

        var contentInset = tableView.contentInset
        contentInset.bottom = 60
        tableView.contentInset = contentInset

        keyboardMan.keyboardObserveEnabled = true

        keyboardMan.updatedKeyboardInfo = { [weak self] keyboardInfo in

            if let strongSelf = self {
                strongSelf.tableViewContentOffsetBeforeKeyboardShow = strongSelf.tableView.contentOffset
            }

            print(keyboardInfo.height)
            print(", ")
            print(keyboardInfo.heightIncrement)
            print("\n")
            print(self?.tableView.contentOffset.y)
            print("\n")
            print("\n")

            let animationDuration = keyboardInfo.animationDuration
            let animationCurve = keyboardInfo.animationCurve

            switch keyboardInfo.action {

            case .Show:

                print("show\n\n\n")

                UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions(animationCurve << 16), animations: {

                    self?.tableView.contentOffset.y += keyboardInfo.heightIncrement
                    self?.tableView.contentInset.bottom = keyboardInfo.height + 60

                    self?.toolBarBottomConstraint.constant = keyboardInfo.height
                    self?.view.layoutIfNeeded()

                }, completion: { _ in
                })

            case .Hide:

                print("hide\n\n\n")

                UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions(animationCurve << 16), animations: {

                    self?.tableView.contentOffset.y -= keyboardInfo.height - keyboardInfo.heightIncrement
                    self?.tableView.contentInset.bottom = 60

                    self?.toolBarBottomConstraint.constant = 0
                    self?.view.layoutIfNeeded()

                }, completion: { _ in
                })
            }
        }
    }

    // MARK: - Actions

    @IBAction func sendMessage() {

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

        // scroll up a little bit

        let newMessageHeight: CGFloat = 44

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
//
//        if hiddenHeight < blockedHeight {
//            if hiddenHeight > 0 {
//                let contentOffset = CGPoint(x: tableViewContentOffsetBeforeKeyboardShow.x, y: tableViewContentOffsetBeforeKeyboardShow.y + hiddenHeight)
//                UIView.animateWithDuration(0.2) {
//                    self.tableView.contentOffset = contentOffset
//                }
//            }
//
//        } else {
//            //var contentOffset = tableViewContentOffsetBeforeKeyboardShow
//            //contentOffset.y += newMessageHeight
//            UIView.animateWithDuration(0.2) {
//                self.tableView.contentOffset.y += newMessageHeight
//            }
//        }

        // clear text

        textField.text = ""
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
        cell.textLabel?.text = "\(indexPath.row) " + message
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        textField.resignFirstResponder()
    }
}




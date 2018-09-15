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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()

        keyboardMan.animateWhenKeyboardAppear = { [weak self] appearPostIndex, keyboardHeight, keyboardHeightIncrement in

            print("appear \(appearPostIndex), \(keyboardHeight), \(keyboardHeightIncrement)\n")

            if let self = self {

                self.tableView.contentOffset.y += keyboardHeightIncrement
                self.tableView.contentInset.bottom = keyboardHeight + self.toolBar.frame.height

                self.toolBarBottomConstraint.constant = keyboardHeight
                self.view.layoutIfNeeded()
            }
        }

        keyboardMan.animateWhenKeyboardDisappear = { [weak self] keyboardHeight in

            print("disappear \(keyboardHeight)\n")

            if let self = self {

                self.tableView.contentOffset.y -= keyboardHeight
                self.tableView.contentInset.bottom = self.toolBar.frame.height

                self.toolBarBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }

        keyboardMan.postKeyboardInfo = { keyboardMan, keyboardInfo in

            switch keyboardInfo.action {
            case .show:
                print("show \(keyboardMan.appearPostIndex), \(keyboardInfo.height), \(keyboardInfo.heightIncrement)\n")
            case .hide:
                print("hide \(keyboardInfo.height)\n")
            }

            /*
            if let self = self {

                let duration = keyboardInfo.animationDuration
                let curve = keyboardInfo.animationCurve
                let options = UIViewAnimationOptions(rawValue: curve << 16 | UIViewAnimationOptions.beginFromCurrentState.rawValue)

                switch keyboardInfo.action {

                case .show:

                    print("show \(keyboardMan.appearPostIndex), \(keyboardInfo.height), \(keyboardInfo.heightIncrement)\n")

                    UIView.animate(withDuration: duration, delay: 0, options: options, animations: {

                        self.tableView.contentOffset.y += keyboardInfo.heightIncrement
                        self.tableView.contentInset.bottom = keyboardInfo.height + self.toolBar.frame.height

                        self.toolBarBottomConstraint.constant = keyboardInfo.height
                        self.view.layoutIfNeeded()

                    }, completion: nil)

                case .hide:

                    print("hide \(keyboardInfo.height)\n")

                    UIView.animate(withDuration: duration, delay: 0, options: options, animations: {

                        self.tableView.contentOffset.y -= keyboardInfo.height
                        self.tableView.contentInset.bottom = self.toolBar.frame.height

                        self.toolBarBottomConstraint.constant = 0
                        self.view.layoutIfNeeded()

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

        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .fade)

        // scroll up a little bit if need

        let newMessageHeight: CGFloat = tableView.rowHeight

        let blockedHeight = statusBarHeight + navigationBarHeight + toolBar.frame.height + toolBarBottomConstraint.constant
        let visibleHeight = tableView.frame.height - blockedHeight
        let hiddenHeight = tableView.contentSize.height - visibleHeight

        if hiddenHeight + newMessageHeight > 0 {

            let contentOffsetYIncrement = hiddenHeight > 0 ? newMessageHeight : hiddenHeight + newMessageHeight
            print("contentOffsetYIncrement: \(contentOffsetYIncrement)\n")

            UIView.animate(withDuration: 0.2) {
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
            let statusBarFrame = window.convert(UIApplication.shared.statusBarFrame, to: view)
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        sendMessage(textField: textField)

        return true
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)!

        let message = messages[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row + 1): " + message

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        
        textField.resignFirstResponder()
    }
}


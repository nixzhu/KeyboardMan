import UIKit
import KeyboardMan

final class ChatViewController: UIViewController {
    private static let cellID = "cell"

    private let keyboardMan = KeyboardMan()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
        return tableView
    }()

    private let toolBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()

    private var toolBarBottomConstraint: NSLayoutConstraint?

    private let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Message..."
        textField.returnKeyType = .send
        return textField
    }()

    private var messages: [String] = [
        "How do you do?",
        "How do you do?",
        "How do you do?",
        "How do you do?",
        "How do you do?",
        "How do you do?",
        "How do you do?",
        "How do you do?",
        "How do you do?",
        "How do you do?",
        "How do you do?",
        "How do you do?",
        "How do you do?",
        "How do you do?",
        "How do you do?",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Chat"

        view.backgroundColor = .systemBackground

        setupUI()

        tableView.dataSource = self
        tableView.delegate = self

        textField.addTarget(self, action: #selector(sendMessage), for: .primaryActionTriggered)

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

//        keyboardMan.postKeyboardInfo = { [weak self] keyboardMan, keyboardInfo in
//            switch keyboardInfo.action {
//            case .show:
//                print("keyboard show: \(keyboardMan.appearPostIndex), \(keyboardInfo.height), \(keyboardInfo.heightIncrement)")
//            case .hide:
//                print("keyboard hide: \(keyboardInfo.height)")
//            }
//
//            guard let self else { return }
//
//            let duration = keyboardInfo.animationDuration
//            let curve = keyboardInfo.animationCurve
//
//            let options = UIView.AnimationOptions(
//                rawValue: curve << 16 |
//                    UIView.AnimationOptions.beginFromCurrentState.rawValue |
//                    UIView.AnimationOptions.allowUserInteraction.rawValue
//            )
//
//            switch keyboardInfo.action {
//            case .show:
//                UIView.animate(withDuration: duration, delay: 0, options: options) {
//                    self.tableView.contentOffset.y += keyboardInfo.heightIncrement
//                    self.tableView.contentInset.bottom = self.toolBar.frame.height + keyboardInfo.height
//                    self.tableView.verticalScrollIndicatorInsets.bottom = self.tableView.contentInset.bottom
//
//                    self.toolBarBottomConstraint?.constant = keyboardInfo.height
//                    self.view.layoutIfNeeded()
//                }
//            case .hide:
//                UIView.animate(withDuration: duration, delay: 0, options: options) {
//                    self.tableView.contentOffset.y -= keyboardInfo.height
//                    self.tableView.contentInset.bottom = self.toolBar.frame.height + view.safeAreaInsets.bottom
//                    self.tableView.verticalScrollIndicatorInsets.bottom = self.tableView.contentInset.bottom
//
//                    self.toolBarBottomConstraint?.constant = 0
//                    self.view.layoutIfNeeded()
//                }
//            }
//        }
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        toolBarBottomConstraint?.constant = view.safeAreaInsets.bottom

        tableView.contentInset.bottom = toolBar.frame.height + view.safeAreaInsets.bottom
        tableView.verticalScrollIndicatorInsets.bottom = tableView.contentInset.bottom
    }

    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(toolBar)
        toolBar.addSubview(textField)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            textField.topAnchor.constraint(equalTo: toolBar.topAnchor, constant: 15),
            textField.leadingAnchor.constraint(equalTo: toolBar.leadingAnchor, constant: 15),
            textField.trailingAnchor.constraint(equalTo: toolBar.trailingAnchor, constant: -15),
            textField.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor, constant: -15),
        ])

        toolBarBottomConstraint = view.bottomAnchor.constraint(
            equalTo: toolBar.bottomAnchor,
            constant: view.safeAreaInsets.bottom
        )
        toolBarBottomConstraint?.isActive = true
    }

    @objc private func sendMessage(_ textField: UITextField) {
        guard let message = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !message.isEmpty
        else { return }

        messages.append(message)

        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .fade)
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)

        textField.text = ""
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellID)!

        let message = messages[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row + 1): " + message

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        textField.resignFirstResponder()
    }
}

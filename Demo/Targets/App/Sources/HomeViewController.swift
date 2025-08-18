import UIKit

final class HomeViewController: UIViewController {
    private let startChatButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Chat", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Home"

        view.backgroundColor = .systemBackground

        setupUI()

        startChatButton.addTarget(self, action: #selector(startChat), for: .touchUpInside)
    }

    private func setupUI() {
        view.addSubview(startChatButton)

        startChatButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            startChatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startChatButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc private func startChat() {
        navigationController?.pushViewController(ChatViewController(), animated: true)
    }
}

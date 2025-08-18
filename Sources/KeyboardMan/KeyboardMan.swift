import UIKit

@MainActor
public final class KeyboardMan {
    public struct KeyboardInfo {
        public let animationDuration: TimeInterval
        public let animationCurve: UInt
        public let frameBegin: CGRect
        public let frameEnd: CGRect

        public var height: CGFloat {
            frameEnd.height
        }

        public let heightIncrement: CGFloat

        public enum Action {
            case show
            case hide
        }

        public let action: Action

        let isSameAction: Bool
    }

    public typealias AnimateWhenKeyboardAppear = (
        _ appearPostIndex: Int,
        _ keyboardHeight: CGFloat,
        _ keyboardHeightIncrement: CGFloat
    ) -> Void

    public typealias AnimateWhenKeyboardDisappear = (
        _ keyboardHeight: CGFloat
    ) -> Void

    public typealias PostKeyboardInfo = (
        _ keyboardMan: KeyboardMan,
        _ keyboardInfo: KeyboardInfo
    ) -> Void

    public var isEnabled = false {
        didSet {
            if isEnabled != oldValue {
                notificationCenter = isEnabled ? .default : nil
            }
        }
    }

    public var animateWhenKeyboardAppear: AnimateWhenKeyboardAppear? {
        didSet {
            isEnabled = true
        }
    }

    public var animateWhenKeyboardDisappear: AnimateWhenKeyboardDisappear? {
        didSet {
            isEnabled = true
        }
    }

    public var postKeyboardInfo: PostKeyboardInfo? {
        didSet {
            isEnabled = true
        }
    }

    public private(set) var appearPostIndex = 0

    public private(set) var keyboardInfo: KeyboardInfo? {
        didSet {
            guard UIApplication.isNotInBackground else { return }
            guard let info = keyboardInfo else { return }
            guard !info.isSameAction || info.heightIncrement != 0 else { return }

            // do convenient animation
            UIView.animate(
                withDuration: info.animationDuration,
                delay: 0,
                options: .init(
                    rawValue: info.animationCurve << 16 |
                        UIView.AnimationOptions.beginFromCurrentState.rawValue |
                        UIView.AnimationOptions.allowUserInteraction.rawValue
                )
            ) { [weak self] in
                guard let self else { return }

                switch info.action {
                case .show:
                    animateWhenKeyboardAppear?(
                        appearPostIndex,
                        info.height,
                        info.heightIncrement
                    )

                    appearPostIndex += 1
                case .hide:
                    animateWhenKeyboardDisappear?(info.height)
                    appearPostIndex = 0
                }
            }

            // post full info
            postKeyboardInfo?(self, info)
        }
    }

    private var notificationCenter: NotificationCenter? {
        didSet {
            oldValue?.removeObserver(self)

            notificationCenter?.addObserver(
                self,
                selector: #selector(keyboardWillShow),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )

            notificationCenter?.addObserver(
                self,
                selector: #selector(keyboardWillChangeFrame),
                name: UIResponder.keyboardWillChangeFrameNotification,
                object: nil
            )

            notificationCenter?.addObserver(
                self,
                selector: #selector(keyboardWillHide),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )

            notificationCenter?.addObserver(
                self,
                selector: #selector(keyboardDidHide),
                name: UIResponder.keyboardDidHideNotification,
                object: nil
            )
        }
    }

    deinit {
        // willSet and didSet are not called when deinit, so...
        notificationCenter?.removeObserver(self)
    }

    public init() {}

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard UIApplication.isNotInBackground else { return }

        handleKeyboard(notification, .show)
    }

    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard UIApplication.isNotInBackground else { return }

        if let keyboardInfo, keyboardInfo.action == .show {
            handleKeyboard(notification, .show)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard UIApplication.isNotInBackground else { return }

        handleKeyboard(notification, .hide)
    }

    @objc private func keyboardDidHide(_ notification: Notification) {
        guard UIApplication.isNotInBackground else { return }

        keyboardInfo = nil
    }

    private func handleKeyboard(_ notification: Notification, _ action: KeyboardInfo.Action) {
        guard let userInfo = notification.userInfo else { return }

        let animationDuration = (
            userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        ).doubleValue

        let animationCurve = (
            userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber
        ).uintValue

        let frameBegin = (
            userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        ).cgRectValue

        let frameEnd = (
            userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        ).cgRectValue

        let currentHeight = frameEnd.height
        let previousHeight = keyboardInfo?.height ?? 0
        let heightIncrement = currentHeight - previousHeight

        let isSameAction: Bool = if let previousAction = keyboardInfo?.action {
            action == previousAction
        } else {
            false
        }

        keyboardInfo = KeyboardInfo(
            animationDuration: animationDuration,
            animationCurve: animationCurve,
            frameBegin: frameBegin,
            frameEnd: frameEnd,
            heightIncrement: heightIncrement,
            action: action,
            isSameAction: isSameAction
        )
    }
}

extension UIApplication {
    fileprivate static var isNotInBackground: Bool {
        sharedOrNil?.applicationState != .background
    }

    private static let sharedOrNil: UIApplication? = {
        let selector = NSSelectorFromString("sharedApplication")

        guard UIApplication.responds(to: selector) else { return nil }

        let application = UIApplication.perform(selector).takeUnretainedValue() as? UIApplication

        guard application?.delegate != nil else { return nil }

        return application
    }()
}

//
//  Alert.swift
//  TakeHome
//
//  Created by Le on 17/5/25.
//

import Alamofire
import UIKit

/// Define 2 methods show alert
protocol CustomAlertType {
    func showAlertOneButton(_ viewController: UIViewController,
                            title: String?, message: String?,
                            buttonTitle: String?, handler: (() -> Void)?)
    func showAlertTwoButton(_ viewController: UIViewController,
                            title: String?,
                            message: String?,
                            leftButtonTitle: String?,
                            rightButtonTitle: String?,
                            leftButtonHandler: (() -> Void)?,
                            rightButtonHandler: (() -> Void)?,
                            leftButtonColor: ColorButtonType?,
                            rightButtonColor: ColorButtonType?)
}

/// Enum Color Button
enum ColorButtonType: String {
    case white
    case blue
}

/// Alert
final class CustomAlert: CustomAlertType {
    static let shared = CustomAlert()
    
    private init() {}
    
    func showAlertOneButton(_ viewController: UIViewController,
                            title: String?,
                            message: String?,
                            buttonTitle: String?,
                            handler: (() -> Void)?) {
        let vc = CustomAlertViewController(title: title?.localized, content: message?.localized,
                                      leftButtonTitle: buttonTitle, rightButtonTitle: nil,
                                      leftButtonHandler: handler, rightButtonHandler: nil,
                                      leftButtonColor: nil, rightButtonColor: nil)
        vc.modalPresentationStyle = .overFullScreen
        viewController.present(vc, animated: false)
    }
    
    func showAlertTwoButton(_ viewController: UIViewController,
                            title: String?,
                            message: String?,
                            leftButtonTitle: String?,
                            rightButtonTitle: String?,
                            leftButtonHandler: (() -> Void)?,
                            rightButtonHandler: (() -> Void)?,
                            leftButtonColor: ColorButtonType?,
                            rightButtonColor: ColorButtonType?) {
        let vc = CustomAlertViewController(buttonType: .twoButton,
                                      title: title?.localized, content: message?.localized,
                                      leftButtonTitle: leftButtonTitle?.localized, rightButtonTitle: rightButtonTitle?.localized,
                                      leftButtonHandler: leftButtonHandler, rightButtonHandler: rightButtonHandler,
                                      leftButtonColor: leftButtonColor, rightButtonColor: rightButtonColor)
        vc.modalPresentationStyle = .overFullScreen
        viewController.present(vc, animated: false)
    }
}

fileprivate final class CustomAlertViewController: UIViewController, UIGestureRecognizerDelegate {
    enum AlertButtonType: String {
        case oneButton
        case twoButton
    }

    private let width = UIScreen.main.bounds.size.width
    private let height = UIScreen.main.bounds.size.height
    private var buttonType: AlertButtonType
    private var leftButtonHandler: (() -> Void)?
    private var rightButtonHandler: (() -> Void)?

    // MARK: - Views
    deinit {
        print("HAlertViewController is deallocated")
    }

    lazy var containView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.alpha = 0
        return label
    }()

    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.alpha = 0
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var leftButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.alpha = 0
        button.backgroundColor = .blue.withAlphaComponent(0.8)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.alpha = 0
        button.backgroundColor = .blue.withAlphaComponent(0.8)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Init
    init(buttonType: AlertButtonType = .oneButton, title: String?,
         content: String?, leftButtonTitle: String?,
         rightButtonTitle: String?, leftButtonHandler: (() -> Void)?,
         rightButtonHandler: (() -> Void)?, leftButtonColor: ColorButtonType?,
         rightButtonColor: ColorButtonType?) {
        switch buttonType {
        case .oneButton:
            self.buttonType = buttonType
            self.leftButtonHandler = leftButtonHandler
            super.init(nibName: nil, bundle: nil)
            titleLabel.text = title
            contentLabel.text = content
            contentLabel.setTextWithLineSpacing(text: content ?? "")
            leftButton.setTitle(leftButtonTitle, for: .normal)
        case .twoButton:
            self.buttonType = buttonType
            self.leftButtonHandler = leftButtonHandler
            self.rightButtonHandler = rightButtonHandler
            super.init(nibName: nil, bundle: nil)
            titleLabel.text = title
            contentLabel.text = content
            contentLabel.setTextWithLineSpacing(text: content ?? "")
            leftButton.setTitle(leftButtonTitle, for: .normal)
            rightButton.setTitle(rightButtonTitle, for: .normal)
            if rightButtonColor != nil, rightButtonColor == .blue {
                self.rightButton.backgroundColor = .blue
                self.rightButton.setTitleColor(.black, for: .normal)
            }
        }
        if leftButtonColor != nil, leftButtonColor == .white {
            leftButton.backgroundColor = .lightGray
            leftButton.layer.cornerRadius = 10
            leftButton.layer.borderWidth = 1
            leftButton.layer.borderColor = UIColor(.blue).cgColor
            leftButton.setTitleColor(UIColor(.black), for: .normal)
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func loadView() {
        super.loadView()
        setUpViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation()
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = .black.withAlphaComponent(0)
            self.titleLabel.alpha = 0
            self.contentLabel.alpha = 0
            self.zoomContainViewOut()
            self.containView.alpha = 0
        } completion: { done in
            if done {
                super.dismiss(animated: flag, completion: completion)
            }
        }
    }

    // MARK: - Methods

    private func setUpViews() {
        view.backgroundColor = .black.withAlphaComponent(0)
        view.addSubview(containView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        containView.addSubview(titleLabel)
        containView.addSubview(contentLabel)
        containView.addSubview(leftButton)
        switch buttonType {
        case .oneButton:
            NSLayoutConstraint.activate([
                containView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                containView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                containView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
                containView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

                titleLabel.centerXAnchor.constraint(equalTo: containView.centerXAnchor),
                titleLabel.topAnchor.constraint(equalTo: containView.topAnchor, constant: 30),

                contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
                contentLabel.leadingAnchor.constraint(equalTo: containView.leadingAnchor, constant: 30),
                contentLabel.trailingAnchor.constraint(equalTo: containView.trailingAnchor, constant: -30),
                contentLabel.bottomAnchor.constraint(equalTo: leftButton.topAnchor, constant: -42),

                leftButton.bottomAnchor.constraint(equalTo: containView.bottomAnchor, constant: -20),
                leftButton.leadingAnchor.constraint(equalTo: containView.leadingAnchor, constant: 20),
                leftButton.trailingAnchor.constraint(equalTo: containView.trailingAnchor, constant: -20),
                leftButton.heightAnchor.constraint(equalToConstant: 40)
            ])
        case .twoButton:
            containView.addSubview(rightButton)
            NSLayoutConstraint.activate([
                containView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                containView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                containView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
                containView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

                titleLabel.centerXAnchor.constraint(equalTo: containView.centerXAnchor),
                titleLabel.topAnchor.constraint(equalTo: containView.topAnchor, constant: 22),

                contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
                contentLabel.leadingAnchor.constraint(equalTo: containView.leadingAnchor, constant: 30),
                contentLabel.trailingAnchor.constraint(equalTo: containView.trailingAnchor, constant: -30),
                contentLabel.bottomAnchor.constraint(equalTo: leftButton.topAnchor, constant: -42),

                leftButton.leadingAnchor.constraint(equalTo: containView.leadingAnchor, constant: 20),
                leftButton.trailingAnchor.constraint(equalTo: containView.centerXAnchor, constant: -20),
                leftButton.bottomAnchor.constraint(equalTo: containView.bottomAnchor, constant: -20),
                leftButton.heightAnchor.constraint(equalToConstant: 40),

                rightButton.leadingAnchor.constraint(equalTo: containView.centerXAnchor, constant: 10),
                rightButton.trailingAnchor.constraint(equalTo: containView.trailingAnchor, constant: -20),
                rightButton.bottomAnchor.constraint(equalTo: containView.bottomAnchor, constant: -20),
                rightButton.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
    }

    // MARK: - Actions

    @objc private func leftButtonTapped() {
        dismiss(animated: false) { [weak self] in
            self?.leftButtonHandler?()
        }
    }

    @objc private func rightButtonTapped() {
        dismiss(animated: false) { [weak self] in
            self?.rightButtonHandler?()
        }
    }

    @objc private func viewTapped() {
        dismiss(animated: false)
    }

    private func showAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = .black.withAlphaComponent(0.5)
            self.containView.frame = CGRect(x: self.width / 2,
                                            y: self.height / 2,
                                            width: 0,
                                            height: 0)
        }, completion: { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.titleLabel.alpha = 1
                    self.contentLabel.alpha = 1
                    self.leftButton.alpha = 1
                    self.rightButton.alpha = 1
                }
            }
        })
    }

    private func zoomContainViewOut() {
        containView.transform = .identity
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveLinear], animations: { () in
            self.containView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        }) { (_: Bool) in
        }
    }

    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view === view
    }
}


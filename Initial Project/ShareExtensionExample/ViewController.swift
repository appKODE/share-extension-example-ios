//
//  ViewController.swift
//  ShareExtensionExample
//
//  Created by Семён Медведев on 19.09.2021.
//

import UIKit

class ViewController: UIViewController {

    private let mainVStack = UIStackView()
    private let backgroundView = UIImageView(image: UIImage(named: "bg"))
    private let titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasicLayout()
    }

    private func setupBasicLayout() {
        configureBackgroundImage()
        configureMainStack()
        configureTitleLabel()
    }
}

// MARK: - UI Elements
private extension ViewController {
    func configureBackgroundImage() {
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.embedIn(view)
    }

    func configureMainStack() {
        mainVStack.axis = .vertical
        mainVStack.distribution = .fillProportionally
        mainVStack.embed(asSubviewTo: view, inset: 40)
    }

    func configureTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textAlignment = .center
        titleLabel.text = "Share Extension Example"
        let titleContainerView = UIView()
        titleLabel.embedIn(titleContainerView, hInset: 0, vInset: 100)
        mainVStack.addArrangedSubview(titleContainerView)
    }
}

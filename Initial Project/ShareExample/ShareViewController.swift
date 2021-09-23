//
//  ShareViewController.swift
//  ShareExample
//
//  Created by Семён Медведев on 19.09.2021.
//

import UIKit

@objc(ShareViewController)
class ShareViewController: UIViewController {

    private let titleLabel = UILabel()
    private let previewsTable = UITableView()
    private let confirmButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTitle()
        configureTable()
        configureConfirmButton()
        setupLayout()
    }
}

// MARK: - Layout
private extension ShareViewController {
    func configureTitle() {
        titleLabel.text = "Загрузка файлов"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.textAlignment = .center
    }

    func configureTable() {

    }

    func configureConfirmButton() {
        confirmButton.setTitle("Загрузить", for: .normal)
        confirmButton.backgroundColor = .systemTeal
        confirmButton.layer.cornerRadius = 14
        confirmButton.setTitleColor(.white, for: .normal)
    }

    func setupLayout() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmButton.heightAnchor.constraint(equalToConstant: 56),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            confirmButton.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14)
        ])

        view.addSubview(previewsTable)
        previewsTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            previewsTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            previewsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            previewsTable.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -24)
        ])
    }
}

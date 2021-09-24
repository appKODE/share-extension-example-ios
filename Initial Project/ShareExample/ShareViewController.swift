//
//  ShareViewController.swift
//  ShareExample
//
//  Created by Семён Медведев on 19.09.2021.
//

import UIKit

struct PreviewModel {
    let image: UIImage
    let title: String
}

@objc(ShareViewController)
class ShareViewController: UIViewController {

    // Layout
    private let titleLabel = UILabel()
    private let previewsTable = UITableView()
    private let confirmButton = UIButton()

    // Properties
    private var previews: [PreviewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTitle()
        configureTable()
        configureConfirmButton()
        setupLayout()
    }

    func getFilesExtensionContext() {
        guard let inputItems = extensionContext?.inputItems as? [NSExtensionItem],
              inputItems.isNotEmpty
        else {
            extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            return
        }

        inputItems.forEach { item in
            if let attachments = item.attachments,
               !attachments.isEmpty {
                attachments.forEach { attachment in

                    if attachment.isImage {
                        handleImageAttachment(attachment)
                    } else if attachment.isMovie {
                        handleMovieAttachment(attachment)
                    }
                }
            }
        }
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
        previewsTable.dataSource = self
        previewsTable.register(UITableViewCell.self, forCellReuseIdentifier: "preview")
    }

    func configureConfirmButton() {
        confirmButton.setTitle("Загрузить", for: .normal)
        confirmButton.backgroundColor = .systemTeal
        confirmButton.layer.cornerRadius = 14
        confirmButton.setTitleColor(.white, for: .normal)
        extensionContext
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

// MARK: - UITableView Data Source
extension ShareViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "preview")!
        cell.textLabel?.text = "Превью файла"
        return cell
    }
}


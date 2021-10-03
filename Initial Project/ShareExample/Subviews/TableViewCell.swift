//
//  Cell.swift
//  ShareExample
//
//  Created by Семён Медведев on 03.10.2021.
//

import Foundation
import UIKit

final class PreviewCell: UITableViewCell {

    private let containerView = UIView()
    private let previewImage = UIImageView()
    private let previewTitleLabel = UILabel()
    private let previewSubtitleLabel = UILabel()

    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }

    func configure(with model: ShareFile) {
        previewImage.image = model.preview.preview
        previewTitleLabel.text = model.preview.title
        previewSubtitleLabel.text = model.preview.size + " Б"
        setupViews()
    }

    private func setupViews() {
        backgroundColor = .clear

        addSubview(containerView)
        containerView.backgroundColor = .init(red: 238/255, green: 239/255, blue: 168/255, alpha: 1)
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        containerView.addSubview(previewImage)
        previewImage.layer.cornerRadius = 12
        previewImage.layer.masksToBounds = true
        previewImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            previewImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            previewImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            previewImage.widthAnchor.constraint(equalToConstant: 50),
            previewImage.heightAnchor.constraint(equalToConstant: 50)
        ])

        containerView.addSubview(previewTitleLabel)
        previewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        previewTitleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        previewTitleLabel.textColor = .black
        NSLayoutConstraint.activate([
            previewTitleLabel.leadingAnchor.constraint(equalTo: previewImage.trailingAnchor, constant: 16),
            previewTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            previewTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        ])

        containerView.addSubview(previewSubtitleLabel)
        previewSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        previewSubtitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        previewSubtitleLabel.textColor = .black
        NSLayoutConstraint.activate([
            previewSubtitleLabel.leadingAnchor.constraint(equalTo: previewImage.trailingAnchor, constant: 16),
            previewSubtitleLabel.topAnchor.constraint(equalTo: previewTitleLabel.bottomAnchor, constant: 10),
            previewSubtitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
}

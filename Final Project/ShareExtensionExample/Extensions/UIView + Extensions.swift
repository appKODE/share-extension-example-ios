//
//  UIView + Extensions.swift
//  ShareExtensionExample
//
//  Created by Семён Медведев on 19.09.2021.
//

import Foundation
import UIKit

public extension UIView {

    func removeSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    func placeInCenter(of view: UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerYAnchor.constraint(equalTo: view.centerYAnchor),
            centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func height(_ value: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: value).isActive = true
    }

    func embed(asSubviewTo: UIView, inset: CGFloat = 0) {
        pinToEdgesWithInset(to: asSubviewTo, top: inset, left: inset, right: -inset, bottom: -inset)
    }

    func embedIn(_ view: UIView, inset: CGFloat = 0) {
        view.removeSubviews()
        pinToEdgesWithInset(to: view, top: inset, left: inset, right: -inset, bottom: -inset)
    }

    func embedIn(_ view: UIView, hInset: CGFloat = 0, vInset: CGFloat = 0) {
        view.removeSubviews()
        pinToEdgesWithInset(to: view, top: vInset, left: hInset, right: -hInset, bottom: -vInset)
    }

    private func pinToEdgesWithInset(
        to view: UIView,
        top: CGFloat,
        left: CGFloat,
        right: CGFloat,
        bottom: CGFloat
    ) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: right),
            topAnchor.constraint(equalTo: view.topAnchor, constant: top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom)
        ])
    }
}

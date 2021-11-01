//
//  ShareViewController.swift
//  ShareExample
//
//  Created by Семён Медведев on 19.09.2021.
//

import UIKit
import MobileCoreServices
import AVFoundation
import ImageIO

public struct ShareFile {
    public struct Preview {
        public let title: String
        public let size: String
        public let preview: UIImage?
    }

    public struct Upload {
        public let name: String
        public let size: UInt64
        public let mimeType: String
        public let data: Data?
    }

    var preview: Preview
    var upload: Upload
}

@objc(ShareViewController)
class ShareViewController: UIViewController {

    // Layout
    private let titleLabel = UILabel()
    private let previewsTable = UITableView()
    private let confirmButton = UIButton()

    // Properties
    var itemsData: [ShareFile] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.previewsTable.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTitle()
        configureTable()
        configureConfirmButton()
        setupLayout()

        getFilesExtensionContext()
    }

    func getFilesExtensionContext() {
        guard let inputItems = extensionContext?.inputItems as? [NSExtensionItem],
              inputItems.count > 0
        else {
            close()
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
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
    }

    func configureTable() {
        previewsTable.backgroundColor = .clear
        previewsTable.delegate = self
        previewsTable.dataSource = self
        previewsTable.register(PreviewCell.self, forCellReuseIdentifier: "preview")
        previewsTable.separatorStyle = .none
    }

    func configureConfirmButton() {
        confirmButton.setTitle("Загрузить", for: .normal)
        confirmButton.backgroundColor = .systemTeal
        confirmButton.layer.cornerRadius = 14
        confirmButton.setTitleColor(.black, for: .normal)
        confirmButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
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
        return itemsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "preview") as! PreviewCell
        cell.configure(with: itemsData[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ShareViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
}

// MARK: - Attachment Types
extension NSItemProvider {
    var isImage: Bool {
        return hasItemConformingToTypeIdentifier(kUTTypeImage as String)
    }

    var isMovie: Bool {
        return hasItemConformingToTypeIdentifier(kUTTypeMovie as String)
    }
}

// MARK: - Get Files context
private extension ShareViewController {
    struct FileName {
        public let title: String
        public let `extension`: String

        public init(title: String, extension: String) {
            self.title = title
            self.extension = `extension`
        }
    }

    func handleImageAttachment(_ attachment: NSItemProvider) {
        attachment.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil) { [weak self] item, error in
            guard let self = self else { return }
            guard error == nil else {
                self.close()
                return
            }

            var title: String = "Картинка"
            var imageData: Data?
            var thumbnail: UIImage?
            var mimeType: String = "application/octet-stream"
            var size: UInt64 = 0

            if let itemUrl = item as? URL,
               let fileName = self.nameAndExtension(from: itemUrl.lastPathComponent) {
                imageData = try? Data(contentsOf: itemUrl)
                title = fileName.title
                size = self.getSize(for: itemUrl) ?? 0
                mimeType = self.getMimeType(for: itemUrl)
            } else if let data = item as? Data {
                imageData = data
                size = UInt64(data.count)
            } else if let image = item as? UIImage,
                      let pngData = image.pngData() {
                imageData = pngData
                size = UInt64(pngData.count)
            } else {
                self.close()
            }

            if let imageData = imageData,
               let image = self.getResizedImage(from: imageData) {
                thumbnail = image
            }

            self.itemsData.append(
                .init(
                    preview: .init(title: title, size: String(size), preview: thumbnail),
                    upload: .init(name: title, size: size, mimeType: mimeType, data: imageData)
                )
            )
        }
    }

    func handleMovieAttachment(_ attachment: NSItemProvider) {
        attachment.loadItem(forTypeIdentifier: kUTTypeMovie as String, options: nil) { [weak self] item, error in
            guard let self = self else { return }
            guard error == nil else {
                self.close()
                return
            }

            var title = "Видео"
            var thumbnail: UIImage? = nil
            var mimeType: String = "application/octet-stream"
            var size: UInt64 = 0

            if let urlItem = item as? URL,
               let fileName = self.nameAndExtension(from: urlItem.lastPathComponent) {
                if let image = self.makeThumbnailForMovie(with: urlItem) {
                    thumbnail = image
                }
                title = fileName.title
                mimeType = self.getMimeType(for: urlItem)
                size = self.getSize(for: urlItem) ?? 0
            }

            self.itemsData.append(.init(
                preview: .init(title: title, size: String(size), preview: thumbnail),
                upload: .init(name: title, size: size, mimeType: mimeType, data: nil)
            ))
        }
    }

    func close() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }

    /// Returns FileName struct from fullName
    /// FileName contains title: String and extension: String
    func nameAndExtension(from fullName: String) -> FileName? {
        guard let lastDotIndex = fullName.lastIndex(of: ".") else { return nil }
        let title = fullName.prefix(upTo: lastDotIndex)
        let `extension` = fullName.suffix(from: fullName.index(lastDotIndex, offsetBy: 1))
        return FileName(title: String(title), extension: String(`extension`))
    }

    func getSize(for url: URL) -> UInt64? {
        guard let resources = try? url.resourceValues(forKeys: [.fileSizeKey]),
              let size = resources.fileSize
        else { return 0 }

        return UInt64(size)
    }

    func getMimeType(for url: URL) -> String {
        guard
            let uti = UTTypeCreatePreferredIdentifierForTag(
                kUTTagClassFilenameExtension,
                url.pathExtension as CFString,
                nil
            )?.takeRetainedValue(),

            let mimeType = UTTypeCopyPreferredTagWithClass(
                uti,
                kUTTagClassMIMEType
            )?.takeRetainedValue() as String?
        else {
            return "application/octet-stream"
        }
        return mimeType
    }
}

// MARK: - File Previews
private extension ShareViewController {
    func getResizedImage(from imageData: Data) -> UIImage? {
        guard let imageSource = CGImageSourceCreateWithData(imageData as NSData, nil)
        else { return nil }
        return resizedImage(from: imageSource)
    }

    func resizedImage(from imageSource: CGImageSource) -> UIImage? {
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: 45
        ]

        guard let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
        else { return nil }

        return UIImage(cgImage: image)
    }

    func makeThumbnailForMovie(with url: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true

            let cgImage = try imageGenerator.copyCGImage(
                at: .zero,
                actualTime: nil
            )
            return UIImage(cgImage: cgImage)
        } catch { return nil }
    }
}

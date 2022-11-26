//
//  PhotosCollectionViewController.swift
//  RxDemo
//
//  Created by Bibin Tom Joseph on 12/07/22.
//

import UIKit
import RxSwift
import Photos

class PhotosCollectionViewController: UICollectionViewController {

    private let selectedPhotoSubject: PublishSubject<UIImage> = .init()
    var selectedPhoto: Observable<UIImage> { selectedPhotoSubject.asObservable() }
    private var images: [PHAsset] = []

    @Dependancy var a: A

    override func viewDidLoad() {
        super.viewDidLoad()
        populatePhotos()

//        let a: A = container.resolve()
        print(a)
        
    }
}

private extension PhotosCollectionViewController {
    func populatePhotos() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: .image, options: nil)
                assets.enumerateObjects { object, count, stop in
                    self?.images.append(object)
                }
                self?.images.reverse()
                DispatchQueue.main.async { self?.collectionView.reloadData() }
            }
        }
    }
}

extension PhotosCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let asset = self.images[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: asset,
                             targetSize: .init(width: 100, height: 100),
                             contentMode: .aspectFill,
                             options: nil) { image, _ in
            DispatchQueue.main.async { cell.photoImageView.image = image }
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = self.images[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: asset,
                             targetSize: .init(width: 300, height: 300),
                             contentMode: .aspectFill,
                             options: nil) { [weak self] image, info in

            guard let info = info else { return }
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool

            if !isDegradedImage {
                guard let image = image else { return }
                self?.selectedPhotoSubject
                    .onNext(image)
            }

            self?.dismiss(animated: true)

        }
    }
}

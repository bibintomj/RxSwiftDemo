//
//  FilterService.swift
//  RxDemo
//
//  Created by Bibin Tom Joseph on 12/07/22.
//

import Foundation
import UIKit
import CoreImage
import RxSwift

final class FilterService {
    private var context: CIContext

    init() {
        self.context = .init()
    }

    func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
        Observable.create { observer in
            self.applyFilter(to: inputImage) {
                observer.onNext($0)
            }
            return Disposables.create()
        }
    }
}

private extension FilterService {
    func applyFilter(to inputImage: UIImage, completion: @escaping (UIImage) -> Void) {
        let filter = CIFilter(name: "CICMYKHalftone")!
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        let sourceImage = CIImage(image: inputImage)!
        filter.setValue(sourceImage, forKey: kCIInputImageKey)
        if let cgimage = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgimage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
            DispatchQueue.main.async { completion(processedImage) }
        }
    }
}

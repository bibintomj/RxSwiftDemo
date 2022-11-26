//
//  ViewController.swift
//  RxDemo
//
//  Created by Bibin Tom Joseph on 06/07/22.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet private weak var fullImageView: UIImageView!
    @IBOutlet private weak var applyFilterButton: UIButton!
    @IBOutlet private weak var randomTextField: UITextField!
    fileprivate let disposeBag: DisposeBag = .init()

    private var userModelRelay: BehaviorRelay<[User]> = .init(value: [])
    private var userModelDriver: Driver<[User]> { userModelRelay.asDriver() }

    override func viewDidLoad() {
        super.viewDidLoad()

        container.register(type: C.self) { container in
            C()
        }

        container.register(type: B.self) { container in
            B(c: container.resolve())
        }

        container.register(type: A.self) { container in
            A(b: container.resolve())
        }



//        applyFilterButton.rx
//            .tap
//            .withLatestFrom(randomTextField.rx.value.orEmpty)
////            .orEmpty
////            .debounce(.seconds(2), scheduler: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] in
//                self?.randomTextField.backgroundColor = $0.count.isMultiple(of: 2) ? .cyan : .brown
//                print($0)
//            })
//            .disposed(by: disposeBag)

//        randomTextField.rx.value
//            .orEmpty
//            .debounce(.seconds(2), scheduler: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] in
//                self?.randomTextField.backgroundColor = $0.count.isMultiple(of: 2) ? .cyan : .brown
//                print($0)
//            })
//            .disposed(by: disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navVC = segue.destination as? UINavigationController,
              let photoCVC = navVC.topViewController as? PhotosCollectionViewController else {
                return
              }
        photoCVC.selectedPhoto
            .subscribe(onNext: { [weak self] in
                self?.updateUI(with: $0)
            })
            .disposed(by: disposeBag)
    }
    @IBAction func handlerOnTapApplyFilter(_ sender: UIButton) {
        guard let inputImage = self.fullImageView.image else { return }
        FilterService().applyFilter(to: inputImage)
            .subscribe(onNext: {
                self.fullImageView.image = $0
            })
            .disposed(by: disposeBag)

        loadUsers()
//        FilterService().applyFilter(to: inputImage) {
//            self.fullImageView.image = $0
//        }
    }

}

private extension ViewController {
    func loadUsers() {
        let resource = Resource<[User]>(url: .init(string: "https://jsonplaceholder.typicode.com/users")!)

        URLRequest.load(resource: resource)
            .observe(on: MainScheduler.instance)
            .retry(3)
            .catch { error -> Observable<[User]> in
                print(error.localizedDescription)
                return Observable.just([])
            }
            .bind(to: self.userModelRelay)
            .disposed(by: disposeBag)

        self.userModelDriver
            .map { $0.first?.email ?? "" }
            .drive(randomTextField.rx.text)
            .disposed(by: disposeBag)

        self.userModelDriver
            .map { $0.first?.name ?? "" }
            .drive(applyFilterButton.rx.title())
            .disposed(by: disposeBag)
    }

    func updateUI(with image: UIImage) {
        fullImageView.image = image
        applyFilterButton.isHidden = false
//        tableview
    }
}

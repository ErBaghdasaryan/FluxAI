//
//  HistoryViewController.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import UIKit
import FluxAIViewModel
import SnapKit
import ApphudSDK

class HistoryViewController: BaseViewController {

    var viewModel: ViewModel?
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.loadShares()
        self.collectionView.reloadData()
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .black

        let numberOfColumns: CGFloat = 2
        let spacing: CGFloat = 17
        let totalSpacing = ((numberOfColumns - 1) * spacing)
        let availableWidth = self.view.frame.width - totalSpacing
        let itemWidth = availableWidth / numberOfColumns

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: 244)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear

        collectionView.register(HistoryCollectionViewCell.self)
        collectionView.register(EmptyCollectionViewCelll.self)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true

        collectionView.delegate = self
        collectionView.dataSource = self

        self.view.addSubview(collectionView)
        setupConstraints()
        setupNavigationItems()
        setupTitleAttributes()
    }

    override func setupViewModel() {
        super.setupViewModel()
    }

    func setupConstraints() {
        collectionView.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(116)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.bottom.equalToSuperview()
        }
    }

}

//MARK: Make buttons actions
extension HistoryViewController {
    
    private func makeButtonsAction() {

    }

    private func setupNavigationItems() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "proButton"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.addTarget(self, action: #selector(getProSubscription), for: .touchUpInside)

        let proButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = proButton
    }

    func setupTitleAttributes() {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "SFProText-Bold", size: 24)!,
            .foregroundColor: UIColor.white
        ]

        let titleString = NSAttributedString(string: "History", attributes: attributes)
        navigationController?.navigationBar.topItem?.title = nil
        navigationController?.navigationBar.topItem?.titleView = UILabel()
        (navigationController?.navigationBar.topItem?.titleView as? UILabel)?.attributedText = titleString
    }

    @objc func getProSubscription() {
        guard let navigationController = self.navigationController else { return }

        if Apphud.hasActiveSubscription() {
            HistoryRouter.showUpdatePaymentViewController(in: navigationController)
        } else {
            HistoryRouter.showPaymentViewController(in: navigationController)
        }
    }
}

extension HistoryViewController: IViewModelableController {
    typealias ViewModel = IHistoryViewModel
}

//MARK: Collection view delegate
extension HistoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.savedItems.isEmpty ?? true ? 1 : self.viewModel!.savedItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.viewModel?.savedItems.isEmpty ?? true {

            let cell: EmptyCollectionViewCelll = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        } else {
            let cell: HistoryCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            if let model = self.viewModel?.savedItems[indexPath.row] {
                cell.configure(with: model)
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let navigationController = self.navigationController else { return }
        if let model = self.viewModel?.savedItems[indexPath.row] {
            HistoryRouter.showEditPhotoViewController(in: navigationController,
                                                      navigationModel: .init(image: model.image))
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.viewModel?.savedItems.isEmpty ?? true {
            return CGSize(width: collectionView.frame.width - 32, height: collectionView.frame.height)
        } else {
            let numberOfColumns: CGFloat = 2
            let spacing: CGFloat = 17
            let totalSpacing = ((numberOfColumns - 1) * spacing)
            let availableWidth = collectionView.frame.width - totalSpacing
            let itemWidth = availableWidth / numberOfColumns

            return CGSize(width: itemWidth, height: 244)
        }
    }
}

//MARK: Preview
import SwiftUI

struct HistoryViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let historyViewController = HistoryViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<HistoryViewControllerProvider.ContainerView>) -> HistoryViewController {
            return historyViewController
        }

        func updateUIViewController(_ uiViewController: HistoryViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<HistoryViewControllerProvider.ContainerView>) {
        }
    }
}

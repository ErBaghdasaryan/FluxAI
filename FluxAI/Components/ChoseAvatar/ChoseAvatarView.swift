//
//  ChoseAvatarView.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 06.03.25.
//

import UIKit
import Combine
import FluxAIModele

class ChoseAvatarView: UIView {

    var collectionView: UICollectionView!
    private var selectedIndex: IndexPath?
    private var selectedAvatar: Avatar?
    private var collectionViewData: [Avatar] = []
    let editTappedSubject = PassthroughSubject<UIImage, Never>()
    let plusTappedSubject = PassthroughSubject<Void, Never>()
    var cancellables = Set<AnyCancellable>()

    private var state: Bool = false

    override func layoutSubviews() {
        super.layoutSubviews()
        cancellables.removeAll()
    }

    init() {
        super.init(frame: .zero)
        setupUI()
        makeButtonActions()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        makeButtonActions()
    }

    private func setupUI() {

        self.backgroundColor = UIColor(hex: "#1D1B1B")
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12

        self.isUserInteractionEnabled = true

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 77, height: 95)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear

        collectionView.register(AvatarCollectionViewCell.self)
        collectionView.register(EmptyAvatarCell.self)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.reloadData()

        self.addSubview(collectionView)
        setupConstraints()
    }

    private func setupConstraints() {

        collectionView.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(12)
            view.leading.equalToSuperview().offset(12)
            view.trailing.equalToSuperview()
            view.height.equalTo(95)
        }

        self.snp.makeConstraints { view in
            view.height.equalTo(119)
        }
    }

    func setupAvatars(model: [Avatar]) {
        self.collectionViewData = model
        self.collectionView.reloadData()
    }

    func returnSelectedAvatar() -> Avatar? {
        guard let selectedAvatar = self.selectedAvatar else { return nil }

        return selectedAvatar
    }

    func getCurrentState() -> Bool {
        return self.state
    }
}

extension ChoseAvatarView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.isEmpty ? 1 : collectionViewData.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell: EmptyAvatarCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setup(image: "addAvatar")
            return cell
        } else {
            let cell: AvatarCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            let dataIndex = indexPath.row - 1

            self.loadImage(from: self.collectionViewData[dataIndex].preview) { image in
                if let image = image {
                    cell.setup(with: "",
                               image: image)
                }
            }

            cell.updateSelectionState(isSelected: indexPath == selectedIndex)

            cell.editSubject.sink { [weak self] _ in
                guard let self = self else { return }
                self.loadImage(from: self.collectionViewData[dataIndex].preview) { image in
                    if let image = image {
                        self.editTappedSubject.send(image)
                    }
                }
            }.store(in: &cell.cancellables)

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return indexPath.row == 0 ? CGSize(width: 56, height: 95) : CGSize(width: 77, height: 95)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row != 0 else {
            self.plusTapped()
            return
        }

        if let previousIndex = selectedIndex,
           let previousCell = collectionView.cellForItem(at: previousIndex) as? AvatarCollectionViewCell {
            previousCell.updateSelectionState(isSelected: false)
        }

        selectedIndex = indexPath
        selectedAvatar = self.collectionViewData[indexPath.row - 1]

        if let newCell = collectionView.cellForItem(at: indexPath) as? AvatarCollectionViewCell {
            newCell.updateSelectionState(isSelected: true)
        }

        self.state = true
    }
}

extension ChoseAvatarView {
    private func makeButtonActions() {

    }

    private func plusTapped() {
        plusTappedSubject.send()
    }

    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: url) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }

            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}

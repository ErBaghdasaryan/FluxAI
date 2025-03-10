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

    private let header = UILabel(text: "Chose avatar",
                                 textColor: UIColor(hex: "#8D929B")!,
                                 font: UIFont(name: "SFProText-Bold", size: 18))
    var collectionView: UICollectionView!
    private var selectedIndex: IndexPath?
    private var selectedAvatar: Avatar?
    private var collectionViewData: [Avatar] = []
    private let create = UIButton(type: .system)
    let editTappedSubject = PassthroughSubject<UIImage, Never>()
    let plusTappedSubject = PassthroughSubject<Void, Never>()
    let createTappedSubject = PassthroughSubject<Void, Never>()
    var cancellables = Set<AnyCancellable>()

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

        self.backgroundColor = UIColor.clear

        self.header.textAlignment = .left

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

        self.create.backgroundColor = UIColor(hex: "#7500D2")
        self.create.layer.masksToBounds = true
        self.create.layer.cornerRadius = 20
        self.create.setTitle("Create by Model & Prompt", for: .normal)
        self.create.setTitleColor(.white, for: .normal)
        self.create.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 15)

        collectionView.reloadData()

        self.addSubview(header)
        self.addSubview(collectionView)
        setupConstraints()
    }

    private func setupConstraints() {
        header.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(12)
            view.leading.equalToSuperview().offset(12)
            view.trailing.equalToSuperview().inset(12)
            view.height.equalTo(20)
        }

        collectionView.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(8)
            view.leading.equalToSuperview().offset(12)
            view.trailing.equalToSuperview()
            view.height.equalTo(95)
        }

        self.snp.makeConstraints { view in
            view.height.equalTo(147)
        }
    }

    func openButton() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 16
        self.layer.borderColor = UIColor(hex: "#7500D2")?.cgColor
        self.layer.borderWidth = 1

        self.addSubview(create)

        create.snp.makeConstraints { view in
            view.top.equalTo(collectionView.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(12)
            view.trailing.equalToSuperview().inset(12)
            view.height.equalTo(40)
        }

        self.snp.updateConstraints { view in
            view.height.equalTo(200)
        }
    }

    func closeButton() {
        self.layer.borderColor = UIColor.clear.cgColor

        self.create.removeFromSuperview()

        self.snp.updateConstraints { view in
            view.height.equalTo(147)
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

            cell.updateSelectionState(isSelected: indexPath == selectedIndex)

            self.loadImage(from: self.collectionViewData[dataIndex].preview) { image in
                if let image = image {
                    cell.setup(with: "",
                               image: image)
                }
            }

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
        selectedIndex = indexPath

        collectionView.reloadData()
        selectedAvatar = self.collectionViewData[indexPath.row - 1]
    }
}

extension ChoseAvatarView {
    private func makeButtonActions() {
        self.create.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
    }

    @objc func createTapped() {
        createTappedSubject.send()
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

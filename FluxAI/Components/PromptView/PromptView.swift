//
//  PromptView.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 01.03.25.
//

import UIKit

class PromptView: UIView {

    private let header = UILabel(text: "What do you want to create?",
                                 textColor: UIColor.white,
                                 font: UIFont(name: "SFProText-Bold", size: 18))
    public let text = CustomTextView(placeholder: "Write what you want...")
    private let aspectRatio = UILabel(text: "Aspect ratio",
                                      textColor: UIColor.white,
                                      font: UIFont(name: "SFProText-Bold", size: 18))
    var aspectRatioCollectionView: UICollectionView!
    private let aspectRatioData = ["1:1", "9:16", "2:3", "3:4", "4:5"]
    private var selectedIndex: IndexPath = IndexPath(item: 1, section: 0)
    private var selectedAspectRatio: String?

    let bottomLine = UIView()

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {

        self.backgroundColor = UIColor.clear

        self.header.textAlignment = .left
        self.aspectRatio.textAlignment = .left

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 54, height: 32)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12

        aspectRatioCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        aspectRatioCollectionView.showsHorizontalScrollIndicator = false
        aspectRatioCollectionView.backgroundColor = .clear

        aspectRatioCollectionView.register(AspectRatioCollectionViewCell.self)
        aspectRatioCollectionView.backgroundColor = .clear
        aspectRatioCollectionView.isScrollEnabled = true

        aspectRatioCollectionView.delegate = self
        aspectRatioCollectionView.dataSource = self

        selectedAspectRatio = self.aspectRatioData[selectedIndex.row]
        aspectRatioCollectionView.reloadData()

        self.addSubview(header)
        self.addSubview(text)
        self.addSubview(aspectRatio)
        self.addSubview(aspectRatioCollectionView)
        setupConstraints()
    }

    private func setupConstraints() {
        header.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.trailing.equalToSuperview()
            view.height.equalTo(20)
        }

        text.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(12)
            view.leading.trailing.equalToSuperview()
            view.height.equalTo(184)
        }

        aspectRatio.snp.makeConstraints { view in
            view.top.equalTo(text.snp.bottom).offset(16)
            view.leading.trailing.equalToSuperview()
            view.height.equalTo(20)
        }

        aspectRatioCollectionView.snp.makeConstraints { view in
            view.top.equalTo(aspectRatio.snp.bottom).offset(12)
            view.leading.trailing.equalToSuperview()
            view.height.equalTo(33)
        }
    }

    func getCurrentAspectRatio() -> String? {
        guard let aspectRatio = self.selectedAspectRatio else { return nil }
        return aspectRatio
    }

    func getPromptText() -> String? {
        if self.text.text == "" {
            return nil
        } else {
            return text.text
        }
    }
}

extension PromptView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.aspectRatioData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AspectRatioCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)

        cell.updateSelectionState(isSelected: indexPath == selectedIndex)

        cell.setup(with: self.aspectRatioData[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 54, height: 32)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousIndex = selectedIndex
        selectedIndex = indexPath

        aspectRatioCollectionView.reloadItems(at: [previousIndex, selectedIndex])
        selectedAspectRatio = self.aspectRatioData[indexPath.row]
    }
}

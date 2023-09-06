//
//  SliderCollectionViewCell.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 6.09.2023.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var sliderDataList = [Article]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureData()
        customNibs()
        print(sliderDataList.count)
        configureCollectionViewLayout()
    }

    
    private func configureData() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    private func customNibs() {
        let categoryCollectionCellNib: UINib = UINib(nibName: "SliderDetailCollectionView", bundle: nil)
        collectionView.register(categoryCollectionCellNib, forCellWithReuseIdentifier: "SliderDetailCollectionViewCell")
    }
    func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = collectionView.frame.size.height
        layout.itemSize = CGSizeMake(screenWidth, screenHeight);
        collectionView.collectionViewLayout = layout
    }
}


extension SliderCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliderDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderDetailCollectionViewCell", for: indexPath) as? SliderDetailCollectionViewCell {
            let slider = sliderDataList[indexPath.row]
            if let urlToImage = slider.urlToImage, let url = URL(string: urlToImage) {
                cell.imageView.load(url: url)
            }
            cell.categoryName.text = slider.author ?? "Boş"
            cell.decription.text = slider.description ?? "Boş"
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    
}

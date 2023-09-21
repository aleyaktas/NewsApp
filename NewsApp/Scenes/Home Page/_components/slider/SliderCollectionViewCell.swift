//
//  SliderCollectionViewCell.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 6.09.2023.
//

import UIKit
import Kingfisher

protocol SliderSelectDelegate {
    func didSelectCell(article: Article)
}

class SliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var delegate: SliderSelectDelegate?
    
    var currentCell = 0
    var timer: Timer?

    var sliderDataList = [Article]() {
        didSet {
            collectionView.reloadData()
        }
    }
    func cellAct(index: Int) {
    
        delegate?.didSelectCell(article: sliderDataList[index])
   
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configureData()
        customNibs()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(slideToNext), userInfo: nil, repeats: true)
        print(sliderDataList.count)
    }
    
    @objc func slideToNext() {
        if sliderDataList.count > 0 {
            if currentCell < sliderDataList.count - 1 {
                currentCell += 1
            } else {
                currentCell = 0
            }
            collectionView.scrollToItem(at: IndexPath(item: currentCell, section: 0), at: .right, animated: true)
        }
    }
    
    private func configureData() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    private func customNibs() {
        let categoryCollectionCellNib: UINib = UINib(nibName: "SliderDetailCollectionView", bundle: nil)
        collectionView.register(categoryCollectionCellNib, forCellWithReuseIdentifier: "SliderDetailCollectionViewCell")
    }
}


extension SliderCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliderDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderDetailCollectionViewCell", for: indexPath) as? SliderDetailCollectionViewCell {
            let slider = sliderDataList[indexPath.row]
            if let urlToImage = slider.urlToImage {
                let url = URL(string: urlToImage)
                cell.imageView.kf.setImage(with: url)
            } else {
                cell.imageView.image = UIImage(named: "no_photo")
                cell.tintColor = .secondaryLabel
            }
            
            if let author = slider.author {
                let components = author.components(separatedBy: ",")
                cell.categoryName.text = components.first
            }
        
            cell.decription.text = slider.title ?? "Empty"
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellAct(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let screenWidth = UIScreen.main.bounds.width
           let itemHeight = collectionView.frame.size.height
           return CGSize(width: screenWidth, height: itemHeight)
       }
    
}

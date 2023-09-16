//
//  OnboardingVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 15.09.2023.
//

import UIKit

class OnboardingVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    var slider: [OnboardingSlider] = []
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slider.count - 1 {
                nextButton.setTitle("Get Started", for: .normal)
            } else {
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
        setArray()
    }
    
    private func configureData() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    @IBAction func nextStepAct(_ sender: UIButton) {
        if currentPage == slider.count - 1 {
            let storyboard = UIStoryboard(name: "RegisterVC", bundle: nil)
                        
            if let vc = storyboard.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC {
            
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    
    func setArray() {
        let item1 = OnboardingSlider(title: "Welcome", description: "Take your first step to get closer to the news with us. Easily access the latest news and updates.", image: "onboarding1")
        let item2 = OnboardingSlider(title: "Explore Categories", description: "Customize your news by selecting categories that match your interests. Discover sports, technology, politics, and more.", image: "onboarding2")
        let item3 = OnboardingSlider(title: "Save Your Favorite News", description: "Add the news you want to follow closely to your favorites. Access them quickly whenever you want.", image: "onboarding3")
        slider = [item1, item2, item3]
        collectionView.reloadData()
    }
    
}

extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(slider.count)
        return slider.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sliderItem = slider[indexPath.row]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingSliderVC", for: indexPath) as? OnboardingSliderVC,
            let title = sliderItem.title,
            let description = sliderItem.description,
            let image = sliderItem.image {
            
            cell.onboardingTitle.text = title
            cell.onboardingImage.image = UIImage(named: image)
            cell.onboardingDescription.text = description
            
            return cell
        }

        return UICollectionViewCell()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

}

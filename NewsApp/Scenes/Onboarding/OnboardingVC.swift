//
//  OnboardingVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 15.09.2023.
//

import UIKit

final class OnboardingVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    var slider: [OnboardingSlider] = []
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slider.count - 1 {
                nextButton.setTitle("get_started_button_title".localized(), for: .normal)
            } else {
                nextButton.setTitle("next_button_title".localized(), for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
        setArray()
    }
    
    private func configureData() {
        nextButton.setTitle("next_button_title".localized(), for: .normal)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false

    }
    
    @IBAction func nextStepAct(_ sender: UIButton) {
        if currentPage == slider.count - 1 {
            let storyboard = UIStoryboard(name: "RegisterVC", bundle: nil)
                        
            if let vc = storyboard.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC {

                vc.navigationItem.hidesBackButton = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    
    func setArray() {
        let item1 = OnboardingSlider(title: "onboarding_title1".localized(),
                                     description: "onboarding_desc1".localized(),
                                     image: "onboarding1")

        let item2 = OnboardingSlider(title: "onboarding_title2".localized(),
                                     description: "onboarding_desc2".localized(),
                                     image: "onboarding2")

        let item3 = OnboardingSlider(title: "onboarding_title3".localized(),
                                     description: "onboarding_desc3".localized(),
                                     image: "onboarding3")

        slider = [item1, item2, item3]
        collectionView.reloadData()
    }
    
}

extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    
}

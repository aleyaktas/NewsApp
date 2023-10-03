//
//  HomeVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 5.09.2023.
//

import UIKit
import Kingfisher
import SideMenu

class HomeVC: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!

    let menu = MenuListController()
    
    let viewModel = HomeVM()

    private var sideMenu: SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: NSNotification.Name("changeLanguage"), object: nil)
        
        customNibs()
        prepareCollectionView()
        setupNavigationBar()
        prepareSideMenu()
        prepareViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func customNibs() {
        let sliderCellNib: UINib = UINib(nibName: "SliderCollectionView", bundle: nil)
        collectionView.register(sliderCellNib, forCellWithReuseIdentifier: "SliderCollectionViewCell")
        
        let newsCellNib: UINib = UINib(nibName: "NewsDetailCollectionView", bundle: nil)
        collectionView.register(newsCellNib, forCellWithReuseIdentifier: "NewsDetailCollectionViewCell")
    }
    
    func prepareViewModel() {
        viewModel.onSucces = reloadTableView()
        viewModel.onError = showError()
        
        viewModel.fetchNewsData(category: "general")
    }
    
    func prepareSideMenu() {
        menu.menuDelegate = self
        
        sideMenu = SideMenuNavigationController(rootViewController: menu)
 
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    @objc func languageChanged() {
        viewModel.fetchNewsData(category: "general")
        collectionView.reloadData()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = ""
        let imageView = UIImageView(image: UIImage(named: "small-logo"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        let imageSize = CGSize(width: 75, height: 75)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: imageSize.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageSize.height).isActive = true
    }

    
    @IBAction func menuButtonAct(_ sender: UIButton) {
        present(sideMenu!, animated: true, completion: nil)
    }
    
    private func prepareCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func showError() -> (_ errorStr: String) -> () {
        return { errorStr in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error!", message: errorStr, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .cancel)
                alert.addAction(okButton)
                self.present(alert, animated: true)
            }
        }
    }
    
    func reloadTableView() -> () -> () {
        return {
            self.collectionView.reloadData()
        }
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SliderSelectDelegate {

    func didSelectCategory(_ category: Category) {
        viewModel.fetchNewsData(category: category.id)
        sideMenu?.dismiss(animated: true)
    }
    
    func didSelectCell(article: Article) {
        let storyboard = UIStoryboard(name: "DetailVC", bundle: nil)

        if let vc = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC {

            vc.article = article

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCollectionViewCell", for: indexPath) as? SliderCollectionViewCell {
                
                let sliderItems = viewModel.getTenItems()
                cell.sliderDataList = sliderItems
                cell.delegate = self

                return cell
            }
        } else if indexPath.section == 1 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsDetailCollectionViewCell", for: indexPath) as? NewsDetailCollectionViewCell {
                let article = viewModel.cellForRow(at: indexPath)
                    if let urlToImage = article?.urlToImage {
                        let url = URL(string: urlToImage)
                        cell.newImage.kf.setImage(with: url)
                    } else {
                        cell.newImage.image = UIImage(named: "no_photo")
                        cell.tintColor = .secondaryLabel
                    }
                    
                let components = article?.author?.components(separatedBy: ",")
                cell.categoryName.text = components?.first
                    

                cell.detail.text = article?.title ?? ""
                let date = article?.publishedAt?.dateFormatter()
                cell.newDate.text = date ?? ""

                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let collectionViewWidth = collectionView.frame.width
        let cellWidth = collectionViewWidth
        let cellHeight: CGFloat = (indexPath.section == 0) ? 300 : 150
        
        return CGSize(width: cellWidth, height: cellHeight)
        }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.frame.size.width, height: 60)
        } else {
            return CGSize(width: collectionView.frame.size.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCollectionView", for: indexPath) as! HeaderCollectionView
            if let headerLabel = cell.headerLabel {
                headerLabel.text = "Latest News".localized()
            } else {
            }
            return cell
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailVC", bundle: nil)
        
        let article = viewModel.cellForRow(at: indexPath)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC {
      
            vc.article = article

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeVC: MenuListDelegate {
    
}

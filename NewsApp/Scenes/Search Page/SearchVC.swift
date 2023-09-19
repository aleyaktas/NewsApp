//
//  SearchVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 14.09.2023.
//

import UIKit
import Alamofire
import Localize_Swift

class SearchVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
        
    var newsData: [Article] = []
    let homeVC = HomeVC()
    var viewModel = SearchVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTableView()
        prepareSearchBar()
        
        viewModel.onSucces = reloadTableView()
        viewModel.onError = showError()

        viewModel.fetchNewsData(searchText: "")

        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: NSNotification.Name("changeLanguage"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.text = ""
        viewModel.fetchNewsData(searchText: "")
    }
    
    @objc func languageChanged() {
        navigationItem.title = "search_title".localized()
        viewModel.fetchNewsData(searchText: "")
    }
    
    func configureData() {
        navigationItem.title = "search_title".localized()
    }
    
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func prepareSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "search_placeholder".localized()
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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell {
            let article = viewModel.cellForRow(at: indexPath)

            if let urlToImage = article?.urlToImage {
                let url = URL(string: urlToImage)
                cell.newImage.kf.setImage(with: url)
            }
            
            let components = article?.author?.components(separatedBy: ",")
            cell.newAuthor.text = components?.first
        

            let date = homeVC.dateFormatter(dateString: article?.publishedAt ?? "Empty")
            cell.date.text = date ?? "Empty"
            cell.titleText.text = article?.title ?? "Empty"

            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailVC", bundle: nil)
        
        let article = viewModel.cellForRow(at: indexPath)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC {
            if let urlToImage = article?.urlToImage, let url = URL(string: urlToImage) {
                vc.imageUrl = url
            }
            vc.newTitle = article?.title
            vc.content = article?.content
            vc.article = article

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.fetchNewsData(searchText: searchText)
    }
}

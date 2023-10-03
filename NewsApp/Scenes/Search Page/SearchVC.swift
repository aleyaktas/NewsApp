//
//  SearchVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 14.09.2023.
//

import UIKit
import Localize_Swift

final class SearchVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
        
    let homeVC = HomeVC()
    let viewModel = SearchVM()
    
    var isDataEmpty = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTableView()
        prepareSearchBar()
        
        viewModel.onSucces = reloadTableView()
        viewModel.onError = showError()
        
        viewModel.fetchNewsData(searchText: "")
        
        customNibs()
        configureData()

        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: NSNotification.Name("changeLanguage"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.text = ""
        viewModel.fetchNewsData(searchText: "")
    }
    
    func customNibs() {
        let emptyCell = UINib(nibName: "EmptyCell", bundle: nil)
        tableView.register(emptyCell, forCellReuseIdentifier: "EmptyCell")
    }
    
    @objc func languageChanged() {
        navigationItem.title = "search_title".localized()
        searchBar.placeholder = "search_placeholder".localized()
        viewModel.fetchNewsData(searchText: "")
    }
    
    func configureData() {
        navigationItem.title = "search_title".localized()
    }
    
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
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
                self.isDataEmpty = self.viewModel.numberOfItems(in: 0) == 0
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isDataEmpty {
            return 1
        } else {
            return viewModel.numberOfItems(in: section)
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isDataEmpty {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as? EmptyCell {
                cell.emptyText.text = "search_empty_text".localized()
                cell.emptyImage.image = UIImage(named: "search-empty")
                cell.emptyImage.tintColor = .secondaryLabel
                cell.backgroundColor = .systemGray6
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell {
                let article = viewModel.cellForRow(at: indexPath)

                if let urlToImage = article?.urlToImage {
                    let url = URL(string: urlToImage)
                    cell.newImage.kf.setImage(with: url)
                } else {
                    cell.newImage.image = UIImage(named: "no_photo")
                    cell.tintColor = .secondaryLabel
                }
                
                let components = article?.author?.components(separatedBy: ",")
                cell.newAuthor.text = components?.first
            

                let date = article?.publishedAt?.dateFormatter()
                cell.date.text = date ?? "Empty"
                cell.titleText.text = article?.title ?? "Empty"

                return cell
            }
        }
        return UITableViewCell()

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isDataEmpty {
            return tableView.frame.height
        } else {
            return 150
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isDataEmpty {
            let storyboard = UIStoryboard(name: "DetailVC", bundle: nil)
            
            let article = viewModel.cellForRow(at: indexPath)
            
            if let vc = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC {
 
                vc.article = article

                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.fetchNewsData(searchText: searchText)
    }
}



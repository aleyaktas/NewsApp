//
//  PrivacySecurityDetailVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 20.09.2023.
//

import UIKit

final class PrivacySecurityDetailVC: UIViewController {
        
    var label: String?

    @IBOutlet weak var privacyLabel: UILabel!

    
    override func viewDidLoad() {
        
        privacyLabel.text = label
        privacyLabel.numberOfLines = 100
        privacyLabel.lineBreakMode = .byTruncatingTail
        
        super.viewDidLoad()
    }
    


}

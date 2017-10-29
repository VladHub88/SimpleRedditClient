//
//  ViewController.swift
//  SimpleRedditClient
//
//  Created by Vlad Vovk on 10/28/17.
//  Copyright © 2017 VladVovk. All rights reserved.
//

import UIKit

class SRCNewsContainerViewController: UIViewController {
    /////////////////////////////////////////
    // MARK: INTERNAL
    // MARK: Accessors
    class func identifier() -> String {
        return String(describing: self)
    }
    private(set) var newsService: SRCNewsService!
    
    // Init/Deinit
    class func createNewsContainerViewController(newsService: SRCNewsService) -> SRCNewsContainerViewController {
        printEnterLog()

        let newsContainerViewController = UIStoryboard(name: "NewsFeedStoryboard", bundle: Bundle.main).instantiateViewController(withIdentifier: self.identifier()) as! SRCNewsContainerViewController
        newsContainerViewController.newsService = newsService
        return newsContainerViewController
    }
    
    // MARK: UIVIew lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SRCNewsTableViewController.identifier(),
            let newsTableViewController = segue.destination as? SRCNewsTableViewController {
            newsTableViewController.newsService = newsService
            newsTableViewController.refreshNews()
            self.tableViewController = newsTableViewController
        }
    }
    
    /////////////////////////////////////////
    // MARK: PRIVATE
    // MARK: Accessors
    private var tableViewController: SRCNewsTableViewController?

}


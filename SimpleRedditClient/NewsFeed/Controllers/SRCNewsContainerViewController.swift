//
//  ViewController.swift
//  SimpleRedditClient
//
//  Created by Vlad Vovk on 10/28/17.
//  Copyright © 2017 VladVovk. All rights reserved.
//

import UIKit

class SRCNewsContainerViewController: UIViewController, SRCNewsTableViewControllerDelegate {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SRCNewsTableViewController.identifier(),
            let newsTableViewController = segue.destination as? SRCNewsTableViewController {
            newsTableViewController.newsService = newsService
            newsTableViewController.refreshNews()
            newsTableViewController.delegate = self
            self.tableViewController = newsTableViewController
        }
    }
    
    // MARK: SRCNewsTableViewControllerDelegate
    func newsTableViewControllerShowGalleryInitiated(post: SRCPost) {
        let galleryViewController = SRCNewsGalleryViewController.createNewsGalleryViewController(post: post)
        navigationController?.pushViewController(galleryViewController, animated: true)
    }
    
    /////////////////////////////////////////
    // MARK: PRIVATE
    // MARK: Accessors
    private var tableViewController: SRCNewsTableViewController?

}


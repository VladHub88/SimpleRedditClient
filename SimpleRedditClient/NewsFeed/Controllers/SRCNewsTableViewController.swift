//
//  SRCNewsTableViewController.swift
//  SimpleRedditClient
//
//  Created by Vlad Vovk on 10/29/17.
//  Copyright © 2017 VladVovk. All rights reserved.
//

import UIKit
import Foundation

class SRCNewsTableViewController: UITableViewController {
    /////////////////////////////////////////
    // MARK: INTERNAL
    // MARK: Accessors
    class func identifier() -> String {
        return String(describing: self)
    }
    var newsService: SRCNewsService?
    
    // MARK: UIView lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    // MARK: Helpers
    func refreshNews() {
        printEnterLog()
    
        newsService?.getTopNews(completion: { [weak self] (posts, error) in
            guard error == nil else {
                // TODO: Show alert
                return
            }
            
            self?.posts = posts
        })
    }
    
    // MARK: UITableViewDataSourse
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postCell = tableView.dequeueReusableCell(withIdentifier: SRCNewsTableViewCell.identifier(), for: indexPath) as! SRCNewsTableViewCell
        if let post = posts?[indexPath.row] {
            postCell.updateWith(title: post.title, author: post.author, numOfComments: post.numberOfComments, date: post.creationDate, thumbnail: nil)
        }
        
        return postCell
    }

    // MARK: UITableViewDelegate
    
    /////////////////////////////////////////
    // MARK: PRIVATE
    var posts: [SRCPost]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}

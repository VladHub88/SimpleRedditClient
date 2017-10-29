//
//  SRCNewsTableViewController.swift
//  SimpleRedditClient
//
//  Created by Vlad Vovk on 10/29/17.
//  Copyright © 2017 VladVovk. All rights reserved.
//

import UIKit
import Foundation

protocol SRCNewsTableViewControllerDelegate: class {
    func newsTableViewControllerShowGalleryInitiated(post: SRCPost)
}

class SRCNewsTableViewController: UITableViewController, SRCNewsTableViewCellDelegate {
    /////////////////////////////////////////
    // MARK: INTERNAL
    // MARK: Accessors
    class func identifier() -> String {
        return String(describing: self)
    }
    weak var delegate: SRCNewsTableViewControllerDelegate?
    var newsService: SRCNewsService?
    
    // MARK: UIView lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.refreshNews), for: UIControlEvents.valueChanged)
    }

    // MARK: Helpers
    func refreshNews() {
        printEnterLog()
    
        guard !newsDownloadingInProgress else {
            print("\(getFileAndFunctionTitle()). Can't start refreshing news because it's already in progress.")
            return
        }
    
        newsDownloadingInProgress = true
        refreshControl?.beginRefreshing()
        newsService?.getTopNews(completion: { [weak self] (posts, error) in
            self?.refreshControl?.endRefreshing()
            self?.newsDownloadingInProgress = false
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
        postCell.delegate = self
        if let post = posts?[indexPath.row] {
            postCell.updateWithPost(post, startThumbnailDownload: true)
        }
        
        return postCell
    }

    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numOfPosts = self.posts?.count ?? 0
        if indexPath.row + 1 == numOfPosts {
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            tableView.tableFooterView = spinner
        
            getMoreNews(completion: { (posts, error) in
                DispatchQueue.main.async {
                    tableView.tableFooterView = UIView()
                }
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        templateNewsTableViewCell.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0)
        templateNewsTableViewCell.updateWithPost(posts![indexPath.row], startThumbnailDownload: false)
        templateNewsTableViewCell.layoutIfNeeded()
        return templateNewsTableViewCell.contentHeight
    }
    
    //MARK: SRCNewsTableViewCellDelegate
    func newsTableViewCellThumbnailTapped(sender: SRCNewsTableViewCell) {
        guard let post = sender.post else {
            return
        }
        
        delegate?.newsTableViewControllerShowGalleryInitiated(post: post)
    }
    
    /////////////////////////////////////////
    // MARK: PRIVATE
    // MARK: Accessors
    private var _templateNewsTableViewCell: SRCNewsTableViewCell?
    private var templateNewsTableViewCell: SRCNewsTableViewCell! {
        if _templateNewsTableViewCell == nil {
            _templateNewsTableViewCell = (tableView.dequeueReusableCell(withIdentifier: SRCNewsTableViewCell.identifier()) as! SRCNewsTableViewCell)
        }
        return _templateNewsTableViewCell!
    }
    private var newsDownloadingInProgress = false
    private var posts: [SRCPost]? {
        didSet {
            posts?.forEach{$0.downloadThumbnailAsync(completion: nil)}
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: Helpers
    private func getMoreNews(completion: @escaping ([SRCPost]?, Error?) -> Swift.Void) {
        printEnterLog()
        
        guard !newsDownloadingInProgress else {
            print("\(getFileAndFunctionTitle()). Can't start refreshing news because it's already in progress.")
            return
        }
        
        newsDownloadingInProgress = true
        newsService?.getTopNewsNextBatch(completion: { [weak self] (posts, error) in
            self?.newsDownloadingInProgress = false
            guard error == nil else {
                // TODO: Show alert
                completion(posts, error)
                return
            }
            
            if let posts = posts {
                self?.posts?.append(contentsOf: posts)
            }
            completion(posts, nil)
        })
    }
}

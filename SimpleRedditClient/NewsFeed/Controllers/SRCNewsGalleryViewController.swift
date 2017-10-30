//
//  SRCNewsGalleryViewController.swift
//  SimpleRedditClient
//
//  Created by Vlad Vovk on 10/29/17.
//  Copyright © 2017 VladVovk. All rights reserved.
//

import UIKit
import Foundation

class SRCNewsGalleryViewController: UIViewController, UIWebViewDelegate {
    /////////////////////////////////////////
    // MARK: INTERNAL
    // MARK: Init/Deinit
    class func createNewsGalleryViewController(post: SRCPost) -> SRCNewsGalleryViewController {
        let newsGalleryViewController = SRCNewsGalleryViewController()
        newsGalleryViewController.post = post
        return newsGalleryViewController
    }
    
    // MARK: UIViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        shareBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(share(_:)))
        shareBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem = shareBarButtonItem

        if let postUrl = post?.postUrl {
            showWebViewForUrl(url: postUrl)
        } else {
            showNoDataImage()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: UIWebViewDelegate
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true

        if let response = URLCache.shared.cachedResponse(for: URLRequest(url: post!.postUrl!)) {
            loadedImage = UIImage(data: response.data)
            if loadedImage != nil {
                shareBarButtonItem?.isEnabled = true
            }
        }
    }
    
    /////////////////////////////////////////
    // MARK: PRIVATE
    // MARK: Accessors
    private var post: SRCPost?
    private var loadedImage: UIImage?
    private var shareBarButtonItem: UIBarButtonItem?
    private let webView: UIWebView = {
        let webView = UIWebView()
        webView.scalesPageToFit = true
        return webView
    }()
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.color = .black
        activityIndicatorView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        return activityIndicatorView
    }()
    
    // MARK: Helpers
    private func showWebViewForUrl(url: URL) {
        webView.frame = view.frame
        webView.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
        
        view.addSubview(webView)
        webView.delegate = self
        webView.loadRequest(URLRequest(url: url))
    }
    
    private func showNoDataImage() {
        let noDataImage = UIImage(named: "noThumbnailIcon")
        let noDataImageView = UIImageView(image: noDataImage)
        noDataImageView.frame.size = CGSize(width: 100, height: 100)
        noDataImageView.center = view.center
        view.addSubview(noDataImageView)
    }
    
    @objc private func share(_ sender: AnyObject) {
        guard let loadedImage = loadedImage else {
            return
        }

        let activityViewController = UIActivityViewController(activityItems: [loadedImage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
}

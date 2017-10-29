//
//  SRCNewsGalleryViewController.swift
//  SimpleRedditClient
//
//  Created by Vlad Vovk on 10/29/17.
//  Copyright © 2017 VladVovk. All rights reserved.
//

import UIKit
import Foundation

class SRCNewsGalleryViewController: UIViewController {
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
        
        imageView.frame = view.frame
        view.addSubview(imageView)
        
        imageView.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
        
        if let fullImageUrl = post?.fullImageUrl {
            imageView.downloadImageFrom(url: fullImageUrl, contentMode: UIViewContentMode.scaleAspectFit, completion: { [weak self] (image, error) -> Void in
                self?.activityIndicatorView.stopAnimating()
                self?.activityIndicatorView.removeFromSuperview()
                
                if image == nil {
                    self?.setDefaultImage()
                } else {
                    self?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(self?.share(_:)))
                }
            })
        } else {
            setDefaultImage()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        activityIndicatorView.startAnimating()
    }
    
    /////////////////////////////////////////
    // MARK: PRIVATE
    // MARK: Accessors
    private var post: SRCPost?
    private let imageView = UIImageView()
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.color = .black
        activityIndicatorView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        return activityIndicatorView
    }()
    
    // MARK: Helpers
    private func setDefaultImage() {
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "noThumbnailIcon")
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
    
    @objc private func share(_ sender: AnyObject) {
        guard let image = imageView.image else {
            return
        }

        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
}

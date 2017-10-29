//
//  SRCNewsTableViewCell.swift
//  SimpleRedditClient
//
//  Created by Vlad Vovk on 10/29/17.
//  Copyright © 2017 VladVovk. All rights reserved.
//

import UIKit
import Foundation

class SRCNewsTableViewCell: UITableViewCell {
    /////////////////////////////////////////
    // MARK: PRIVATE
    // MARK: Accessors
    class func identifier() -> String {
        return String(describing: self)
    }
    
    // MARK: Helpers
    func updateWith(title: String, author: String, numOfComments: Int, date: Date, thumbnail: UIImage?) {
        titleLabel.text = title
        authorLabel.text = author
        numOfCommentsLabel.text = "\(numOfComments)"
        dateLabel.text = date.timeAgoString()
        
        thumbnailImageView.image = thumbnail
        if thumbnail != nil {
            showThumbnailImageView()
        } else {
            hideThumbnailImageView()
        }
    }
    
    func showThumbnailImageView() {
        thumbnailImageView.isHidden = false
        NSLayoutConstraint.activate([thumbnailImageViewWidthConstraint])
        NSLayoutConstraint.deactivate([thumbnailImageViewZeroWidthConstraint])
    }
    
    func hideThumbnailImageView() {
        thumbnailImageView.isHidden = true
        NSLayoutConstraint.deactivate([thumbnailImageViewWidthConstraint])
        NSLayoutConstraint.activate([thumbnailImageViewZeroWidthConstraint])
    }
    
    /////////////////////////////////////////
    // MARK: PRIVATE
    // MARK: Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var numOfCommentsLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var thumbnailImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var thumbnailImageViewZeroWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var thumbnailImageViewLeadingIndentConstraint: NSLayoutConstraint!
}

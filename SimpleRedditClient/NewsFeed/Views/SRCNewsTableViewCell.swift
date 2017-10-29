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
    
    var contentHeight: CGFloat {
        guard post != nil else {
            return 0
        }
        
        let contentHeight = authorLabel.intrinsicContentSize.height + dateLabel.intrinsicContentSize.height +
            titleLabel.intrinsicContentSize.height + 2 * Constants.verticalContentIndent +
            titleLabelBottomIndentConstraint.constant + commentsLabelBottomIndentConstraint.constant
        
        return contentHeight
    }
    
    // MARK: Helpers
    func updateWithPost(_ post: SRCPost, startThumbnailDownload: Bool) {
        self.post = post
        titleLabel.text = post.title
        authorLabel.text = post.author
        numOfCommentsLabel.text = "\(post.numberOfComments)"
        dateLabel.text = post.creationDate.timeAgoString()
        
        thumbnailImageView.image = UIImage(named: "noThumbnailIcon")
        if startThumbnailDownload && post.thumbnailUrl != nil {
            post.downloadThumbnailAsync(completion: { [weak self] (image, error) in
                guard post.id == self?.post?.id, image != nil else {
                    return
                }
            
                DispatchQueue.main.async {
                    self?.thumbnailImageView.contentMode = .scaleAspectFit
                    self?.thumbnailImageView.image = image
                }
            })
        }
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
    @IBOutlet private weak var titleLabelBottomIndentConstraint: NSLayoutConstraint!
    @IBOutlet private weak var commentsLabelBottomIndentConstraint: NSLayoutConstraint!
    
    // MARK: Accessors
    private var post: SRCPost?
    
    // MARK: Types
    private struct Constants {
        static let verticalContentIndent: CGFloat = 8
    }
}

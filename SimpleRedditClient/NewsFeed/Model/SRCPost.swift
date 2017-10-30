//
//  SRCPost.swift
//  SimpleRedditClient
//
//  Created by Vlad Vovk on 10/28/17.
//  Copyright © 2017 VladVovk. All rights reserved.
//

import UIKit
import Foundation

protocol SRCPost {
    var id: String { get }
    var name: String { get }
    var title: String { get }
    var author: String { get }
    var creationDate: Date { get }
    var numberOfComments: Int { get }
    var thumbnailUrl: URL? { get }
    var thumbnailWidth: Float? { get }
    var thumbnailHeight: Float? { get }
    var postUrl: URL? { get }
    
    func downloadThumbnailAsync(completion: ((UIImage?, Error?) -> Swift.Void)?)
}

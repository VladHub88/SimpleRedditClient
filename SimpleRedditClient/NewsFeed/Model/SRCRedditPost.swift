//
//  SRCRedditPost.swift
//  SimpleRedditClient
//
//  Created by Vlad Vovk on 10/28/17.
//  Copyright © 2017 VladVovk. All rights reserved.
//

import UIKit
import Foundation

class SRCRedditPost: NSObject, SRCPost {
    /////////////////////////////////////////
    // MARK: INTERNAL
    // MARK: Accessors
    private(set) var id: String
    private(set) var name: String
    private(set) var title: String
    private(set) var author: String
    private(set) var creationDate: Date
    private(set) var numberOfComments: Int = 0
    private(set) var thumbnailUrl: URL?
    private(set) var thumbnailWidth: Float?
    private(set) var thumbnailHeight: Float?
    private(set) var thumbnail: UIImage?
    private(set) var postUrl: URL?
    
    // MARK: Init/Deinit
    init?(json: [String: Any]?) {
       guard let jsonData = json?[Constants.dataKey] as? [String: Any],
            let id = jsonData[Constants.idKey] as? String,
            let name = jsonData[Constants.nameKey] as? String,
            let title = jsonData[Constants.titleKey] as? String,
            let author = jsonData[Constants.authorKey] as? String,
            let creationDate = (jsonData[Constants.creationDateKey] as? TimeInterval).map({Date(timeIntervalSince1970: $0)}),
            let numberOfComments = jsonData[Constants.numberOfCommentsKey] as? Int else {
            return nil
       }

        self.id = id
        self.name = name
        self.title = title
        self.author = author
        self.creationDate = creationDate
        self.numberOfComments = numberOfComments
        self.thumbnailUrl = (jsonData[Constants.thumbnailKey] as? String).map({URL(string: $0)}) as? URL
        self.thumbnailWidth = jsonData[Constants.thumbnailWidthKey] as? Float
        self.thumbnailHeight = jsonData[Constants.thumbnailHeightKey] as? Float
        self.postUrl = (jsonData[Constants.postUrlKey] as? String).map({URL(string: $0)}) as? URL
    }
    
    // MARK: Helpers
    func downloadThumbnailAsync(completion: ((UIImage?, Error?) -> Swift.Void)?) {
        if self.thumbnailUrl == nil || thumbnail != nil {
            completion?(thumbnail, nil)
            return
        }
    
        if thumbnailDownloadInProgress {
            if completion != nil {
                thumbnailLock.lock()
                thumbnailDownloadCompletionHandlers.append(completion!)
                thumbnailLock.unlock()
            }
            return
        }
    
        thumbnailDownloadInProgress = true
        URLSession.shared.dataTask( with: self.thumbnailUrl!, completionHandler: { [weak self] (data, response, error) -> Void in
            func invokeCompletionHandlers(image: UIImage?, error: Error?) {
                self?.thumbnailLock.lock()
                if let thumbnailDownloadCompletionHandlers = self?.thumbnailDownloadCompletionHandlers {
                    for completion in thumbnailDownloadCompletionHandlers {
                        completion(image, error)
                    }
                }
                self?.thumbnailDownloadCompletionHandlers.removeAll()
                self?.thumbnailLock.unlock()
            }
        
            guard error == nil else {
                invokeCompletionHandlers(image: nil, error: error)
                self?.thumbnailDownloadInProgress = false
                return
            }
        
            self?.thumbnail = data.map{ UIImage(data: $0)! }
            invokeCompletionHandlers(image: self?.thumbnail, error: nil)
            self?.thumbnailDownloadInProgress = false
        }).resume()
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Constants.idKey)
        aCoder.encode(name, forKey: Constants.nameKey)
        aCoder.encode(title, forKey: Constants.titleKey)
        aCoder.encode(author, forKey: Constants.authorKey)
        aCoder.encode(creationDate, forKey: Constants.creationDateKey)
        aCoder.encode(numberOfComments, forKey: Constants.numberOfCommentsKey)
        aCoder.encode(thumbnailUrl, forKey: Constants.thumbnailKey)
        if let thumbnailWidth = thumbnailWidth {
            aCoder.encode(thumbnailWidth, forKey: Constants.thumbnailWidthKey)
        }
        if let thumbnailHeight = thumbnailHeight {
            aCoder.encode(thumbnailHeight, forKey: Constants.thumbnailHeightKey)
        }
        aCoder.encode(thumbnail, forKey: Constants.thumbnailImageKey)
        aCoder.encode(postUrl, forKey: Constants.postUrlKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: Constants.idKey) as! String
        name = aDecoder.decodeObject(forKey: Constants.nameKey) as! String
        title = aDecoder.decodeObject(forKey: Constants.titleKey) as! String
        author = aDecoder.decodeObject(forKey: Constants.authorKey) as! String
        creationDate = aDecoder.decodeObject(forKey: Constants.creationDateKey) as! Date
        numberOfComments = aDecoder.decodeInteger(forKey: Constants.numberOfCommentsKey)
        thumbnailUrl = aDecoder.decodeObject(forKey: Constants.thumbnailKey) as? URL
        thumbnailWidth = aDecoder.decodeFloat(forKey: Constants.thumbnailWidthKey)
        thumbnailHeight = aDecoder.decodeFloat(forKey: Constants.thumbnailHeightKey)
        thumbnail = aDecoder.decodeObject(forKey: Constants.thumbnailImageKey) as? UIImage
        postUrl = aDecoder.decodeObject(forKey: Constants.postUrlKey) as? URL
    }
    
    /////////////////////////////////////////
    // MARK: PRIVATE
    // MARK: Accessors
    private var thumbnailDownloadInProgress = false
    private var thumbnailDownloadCompletionHandlers = [((UIImage?, Error?) -> Void)]()
    private let thumbnailLock = NSLock()
    
    // MARK: Types
    private struct Constants {
        static let idKey = "id"
        static let nameKey = "name"
        static let titleKey = "title"
        static let authorKey = "author"
        static let creationDateKey = "created_utc"
        static let numberOfCommentsKey = "num_comments"
        static let dataKey = "data"
        static let thumbnailKey = "thumbnail"
        static let thumbnailWidthKey = "thumbnail_width"
        static let thumbnailHeightKey = "thumbnail_height"
        static let postUrlKey = "url"
        static let thumbnailImageKey = "thumbnailImage"
    }
}

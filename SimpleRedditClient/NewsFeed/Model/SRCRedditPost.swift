//
//  SRCRedditPost.swift
//  SimpleRedditClient
//
//  Created by Vlad Vovk on 10/28/17.
//  Copyright © 2017 VladVovk. All rights reserved.
//

import Foundation

class SRCRedditPost: SRCPost {
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
    }
    
    /////////////////////////////////////////
    // MARK: PRIVATE
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
    }
}

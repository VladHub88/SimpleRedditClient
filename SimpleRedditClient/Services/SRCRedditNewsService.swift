//
//  SRCRedditNewsService.swift
//  SimpleRedditClient
//
//  Created by Vlad Vovk on 10/28/17.
//  Copyright © 2017 VladVovk. All rights reserved.
//

import Foundation

class SRCRedditNewsService: SRCNewsService {
    /////////////////////////////////////////
    // MARK: INTERNAL
    // MARK: Helpers
    func getTopNews(completion: @escaping ([SRCPost]?, Error?) -> Swift.Void) {
        printEnterLog()
        
        guard let topNewsUrl = URL(string: Constants.baseRedditUrl + Constants.topNewsPathComponent) else {
            completion(nil, SRCNewsServiceError.invalidUrl)
            return
        }
        
        let topNewsTask = session.dataTask(with: topNewsUrl) { [weak self] (topNewsData, response, error) in
            guard error == nil, let topNewsData = topNewsData,
                let topNewsJson = (try? JSONSerialization.jsonObject(with: topNewsData, options: []) as? [String : Any]),
                let topNewsDataDictionary = topNewsJson?[Constants.dataKey] as? [String: Any],
                let topNewsChildren = topNewsDataDictionary[Constants.childrenKey] as? [[String: Any]] else {

                completion(nil, error ?? SRCNewsServiceError.invalidDataReceived)
                return
            }
            
            let posts = topNewsChildren.flatMap{ SRCRedditPost(json: $0) }
            self?.lastDownloadedPost = posts.last
            print("\(getFileAndFunctionTitle()). Successfully parsed \(posts.count) posts.")
            completion(posts,nil)
        }
        
        topNewsTask.resume()
    }
    
    func getTopNewsNextBatch(completion: @escaping ([SRCPost]?, Error?) -> Swift.Void) {
        printEnterLog()
    }
    
    /////////////////////////////////////////
    // MARK: PRIVATE
    // MARK: Accessors
    private var session: URLSession = {
        let sessionConfiguration = URLSessionConfiguration.default
        let additionalHeadersDict = [Constants.userAgentHeaderKey: Constants.simpleRedditClientAgentHeader]
        sessionConfiguration.httpAdditionalHeaders = additionalHeadersDict
        return URLSession(configuration: .default)
    }()
    private var lastDownloadedPost: SRCRedditPost?
    
    // MARK: Types
    private struct Constants {
        static let userAgentHeaderKey = "User-Agent"
        static let simpleRedditClientAgentHeader = "SimpleRedditClient"
        static let userAgentString = "SimpleRedditClient"
        static let baseRedditUrl = "https://www.reddit.com/"
        static let topNewsPathComponent = "top/.json"
        static let childrenKey = "children"
        static let dataKey = "data"
    }
}

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
            print("\(getFileAndFunctionTitle()). Failed to get correct url for news downloading.")
            completion(nil, SRCNewsServiceError.invalidUrl)
            return
        }
        
        getNews(fromUrl: topNewsUrl) { [weak self] (posts, error) in
            self?.lastDownloadedPost = posts?.last
            completion(posts, error)
        }
    }
    
    func getTopNewsNextBatch(completion: @escaping ([SRCPost]?, Error?) -> Swift.Void) {
        printEnterLog()
        
        guard let lastDownloadedPostName = lastDownloadedPost?.name else {
            return getTopNews(completion: completion)
        }
        
        let nextBatchPath = Constants.baseRedditUrl + Constants.topNewsPathComponent + Constants.parametersSectionSymbol +
            Constants.afterParameterKey + lastDownloadedPostName
        
        guard let nextBatchUrl = URL(string: nextBatchPath) else {
            print("\(getFileAndFunctionTitle()). Failed to get correct url for news downloading.")
            return completion(nil, SRCNewsServiceError.invalidUrl)
        }
        
        getNews(fromUrl: nextBatchUrl) { [weak self] (posts, error) in
            self?.lastDownloadedPost = posts?.last
            completion(posts, error)
        }
    }
    
    /////////////////////////////////////////
    // MARK: PRIVATE
    // MARK: Accessors
    private var session: URLSession = {
        let sessionConfiguration = URLSessionConfiguration.default
        let additionalHeadersDict = [Constants.userAgentHeaderKey: Constants.simpleRedditClientAgentHeader]
        sessionConfiguration.httpAdditionalHeaders = additionalHeadersDict
        return URLSession(configuration: sessionConfiguration)
    }()
    private var lastDownloadedPost: SRCPost?
    
    // MARK: Helpers
    private func getNews(fromUrl newsUrl: URL, completion: @escaping ([SRCPost]?, Error?) -> Swift.Void) {
        let getNewsTask = session.dataTask(with: newsUrl) { [weak self] (newsData, response, error) in
            guard error == nil, let posts = self?.parsePostsFromNewsData(newsData: newsData) else {
                print("\(getFileAndFunctionTitle()). Failed to download or parse posts from url \(newsUrl).")
                completion(nil, error ?? SRCNewsServiceError.invalidDataReceived)
                return
            }
            
            print("\(getFileAndFunctionTitle()). Successfully downloaded and parsed \(posts.count) posts.")
            completion(posts,nil)
        }
        
        getNewsTask.resume()
    }
    
    private func parsePostsFromNewsData(newsData: Data?) -> [SRCPost]? {
        printEnterLog()
        
        guard let newsData = newsData,
            let newsJson = (try? JSONSerialization.jsonObject(with: newsData, options: []) as? [String : Any]),
            let dataJson = newsJson?[Constants.dataKey] as? [String: Any],
            let postsJson = dataJson[Constants.childrenKey] as? [[String: Any]] else {

            return nil
        }
        
        let posts = postsJson.flatMap({ SRCRedditPost(json: $0) })
        return posts
    }
    
    // MARK: Types
    private struct Constants {
        static let userAgentHeaderKey = "User-Agent"
        static let simpleRedditClientAgentHeader = "SimpleRedditClient"
        static let userAgentString = "SimpleRedditClient"
        static let baseRedditUrl = "https://www.reddit.com/"
        static let topNewsPathComponent = "top/.json"
        static let childrenKey = "children"
        static let dataKey = "data"
        static let parametersSectionSymbol = "?"
        static let parametersSeparationSymbol = "&"
        static let afterParameterKey = "after="
    }
}

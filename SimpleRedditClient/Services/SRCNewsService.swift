//
//  SRCNewsService.swift
//  SimpleRedditClient
//
//  Created by Vlad Vovk on 10/28/17.
//  Copyright © 2017 VladVovk. All rights reserved.
//

import Foundation

protocol SRCNewsService {
    func getTopNews(completion: @escaping ([SRCPost]?, Error?) -> Swift.Void)
    func getTopNewsNextBatch(completion: @escaping ([SRCPost]?, Error?) -> Swift.Void)
}

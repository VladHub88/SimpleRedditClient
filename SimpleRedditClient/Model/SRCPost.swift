//
//  SRCPost.swift
//  SimpleRedditClient
//
//  Created by Vlad Vovk on 10/28/17.
//  Copyright © 2017 VladVovk. All rights reserved.
//

import Foundation

protocol SRCPost {
    var id: String { get }
    var name: String { get }
    var title: String { get }
    var author: String { get }
    var creationDate: Date { get }
    var numberOfComments: Int { get }
}

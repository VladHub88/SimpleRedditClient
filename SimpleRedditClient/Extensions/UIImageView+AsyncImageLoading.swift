//
//  UIImageView+AsyncImageLoading.swift
//  SimpleRedditClient
//
//  Created by Vlad Vovk on 10/29/17.
//  Copyright © 2017 VladVovk. All rights reserved.
//

import UIKit
import Foundation

extension UIImageView {
    func downloadImageFrom(url:URL, contentMode: UIViewContentMode, completion: ((UIImage?, Error?) -> Void)?) {
        URLSession.shared.dataTask( with: url, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data {
                    self.image = UIImage(data: data)
                }
                completion?(self.image, error)
            }
        }).resume()
    }
}

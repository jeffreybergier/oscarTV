//
//  Downloader.swift
//  RottenTomatoesSwift
//
//  Created by Jeffrey Bergier on 9/12/15.
//  Copyright © 2015 MobileBridge. All rights reserved.
//

import Foundation

protocol DownloaderDelegate: class {
    func downloadFinishedForURL(finishedURL: NSURL)
}

class Downloader {
    
    weak var delegate: DownloaderDelegate?
    
    private let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    private var downloaded = [NSURL : NSData]()
    
    func beginDownloadingURL(downloadURL: NSURL) {
        self.session.dataTaskWithRequest(NSURLRequest(URL: downloadURL)) { (downloadedData, response, error) in
            guard let downloadedData = downloadedData else { return }
            guard let response = response as? NSHTTPURLResponse else { return }
            switch response.statusCode {
            case 200:
                self.downloaded[downloadURL] = downloadedData
                self.delegate?.downloadFinishedForURL(downloadURL)
            default:
                break
            }
        }.resume()
    }
    
    func dataForURL(requestURL: NSURL) -> NSData? {
        return self.downloaded[requestURL]
    }
}

//
//  MovieListTableViewController.swift
//  RottenTomatoesSwift
//
//  Created by Jeffrey Bergier on 4/14/15.
//  Copyright (c) 2015 MobileBridge. All rights reserved.
//

import UIKit

class MovieListTableViewController: UITableViewController {
    
    private var moviesArray: [NSDictionary]?
    private let downloader = Downloader()
    private let jsonURL: NSURL = {
        let apiKey = "qe43pmsb84evcmyj43gbe7j8"
        return NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/upcoming.json?apikey=\(apiKey)")!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.downloader.delegate = self
        
        // Download rotten tomatoes file
        
        self.downloader.beginDownloadingURL(self.jsonURL)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moviesArray?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let optionalCell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as? MovieTableViewCell
        guard let moviesArray = self.moviesArray else { fatalError() }
        guard let cell = optionalCell else { fatalError() }
        
        let movie = moviesArray[indexPath.row]
        if let posterDictionary = movie["posters"] as? NSDictionary,
            let posterURLString = posterDictionary["thumbnail"] as? String,
            let posterURL = NSURL(string: posterURLString) {
                
                let movieTitle = movie["title"] as? String ?? "Title Not Found"
                let movieDescription = movie["synopsis"] as? String ?? "Synopsys Not Found"
                
                let movieModel = Movie(title: movieTitle, description: movieDescription, posterURL: posterURL)
                cell.model = movieModel
        }
        return cell
    }
    
    func downloadImageURL(downloadURL: NSURL, forCell cell: MovieTableViewCell?) {
        let request = NSURLRequest(URL: downloadURL, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 10.0)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (downloadedData, response, error) in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    // Grab the main queue because NSURLSession can callback on any
                    // queue and we're touching non-atomic properties and the UI
                    dispatch_async(dispatch_get_main_queue()) {
                        if httpResponse.URL == cell?.posterURL {
                            let image = UIImage(data: downloadedData!)
                        } else {
                            // The URL's don't match. That means that the cell has been "Reused" since starting this download
                            // We can discard this download and do nothing
                            // Hopefully, the appropriate downloaded for this cell has already started
                            // If we were serious about error handling, we would have a way to verify that.
                            NSLog("URL's Don't match: Download \(httpResponse.URL). Cell \(cell?.posterURL)")
                        }
                    }
                default:
                    break //handle http errors here
                }
            }
        })
        task.resume()
    }
    
}

extension MovieListTableViewController: DownloaderDelegate {
    func downloadFinishedForURL(finishedURL: NSURL) {
        if finishedURL == self.jsonURL {
            guard let downloadedData = self.downloader.dataForURL(finishedURL) else { return }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(downloadedData, options: .AllowFragments)
                if let jsonDictionary = json as? NSDictionary,
                    let moviesArray = jsonDictionary["movies"] as? [NSDictionary] {
                        // Grab the main queue because NSURLSession can callback on any
                        // queue and we're touching non-atomic properties and the UI
                        dispatch_async(dispatch_get_main_queue()) {
                            self.moviesArray = moviesArray
                            self.tableView.reloadData()
                        }
                }
            } catch {
                NSLog("MovieListTableViewController: Could not parse JSON from URL: \(finishedURL) – Error: \(error)")
            }
        } else {
            // handle images here
        }
    }
}

















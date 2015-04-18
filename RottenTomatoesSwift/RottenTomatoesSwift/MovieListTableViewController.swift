//
//  MovieListTableViewController.swift
//  RottenTomatoesSwift
//
//  Created by Jeffrey Bergier on 4/14/15.
//  Copyright (c) 2015 MobileBridge. All rights reserved.
//

import UIKit

class MovieListTableViewController: UITableViewController {
    
    var moviesArray: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Download rotten tomatoes file
        let apiKey = "qe43pmsb84evcmyj43gbe7j8"
        let url: NSURL! = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/upcoming.json?apikey=\(apiKey)")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {(downloadedData, response, error) in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    if let data = downloadedData,
                        let json = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: nil) as? NSDictionary,
                        let moviesArray = json["movies"] as? [NSDictionary] {
                            // Grab the main queue because NSURLSession can callback on any 
                            // queue and we're touching non-atomic properties and the UI
                            dispatch_async(dispatch_get_main_queue()) {
                                self.moviesArray = moviesArray
                                self.tableView.reloadData()
                            }
                    }
                default:
                    NSLog("Error downloading file: Response code \(httpResponse.statusCode)") // handle errors here
                }
            }
        })
        task.resume()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moviesArray?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as? MovieTableViewCell
        if let moviesArray = self.moviesArray {
            let movie = moviesArray[indexPath.row]
            let movieTitle = movie["title"] as? String ?? "Title Not Found"
            let movieDescription = movie["synopsis"] as? String ?? "Synopsys Not Found"
            
            cell?.moviePosterImageView.image = nil // Need to clear the image before we start downloading a new one.
            cell?.movieTitleLabel.text = movieTitle
            cell?.movieDescriptionLabel.text = movieDescription
            
            if let posterDictionary = movie["posters"] as? NSDictionary,
                let posterURLString = posterDictionary["thumbnail"] as? String,
                let posterURL = NSURL(string: posterURLString) {
                    cell?.posterURL = posterURL
                    self.downloadImageURL(posterURL, ForCell: cell)
            }
        }
        return cell!
    }
    
    func downloadImageURL(downloadURL: NSURL, ForCell cell: MovieTableViewCell?) {
        let request = NSURLRequest(URL: downloadURL, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 10.0)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (downloadedData, response, error) in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    // Grab the main queue because NSURLSession can callback on any
                    // queue and we're touching non-atomic properties and the UI
                    dispatch_async(dispatch_get_main_queue()) {
                        if httpResponse.URL == cell?.posterURL {
                            let image = UIImage(data: downloadedData)
                            cell?.moviePosterImageView.image = image
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

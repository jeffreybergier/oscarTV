## Improving Code with Swift Features

### Summary
In this section we are going to improve the code with nice swift features and other miscellaneous improvements. By the end, you’ll see how breaking the code up into several different areas of concerns really makes the code easier to read, understand, and debug. Concepts we will introduce:

1. New Types, particularly structs. If possible you may want to explain the different between Reference types and Value types in swift.
1. Guard statements in Swift and how to use them
1. Private Methods / Properties
1. Extensions
1. try? in swift
1. Using a Model for the Cell Class. We are going to give the cell a single item and it will lay itself out, instead of the ViewController doing it for the cell.
1. Download class. We will create a class that downloads the artwork and notifies the cells as needed. This class will be very very generic, handling NSURL and NSData so it can be reused for many things.
1. Protocols and Delegates. We are going to define Protocols for the download class so it can safely communicate with other objects.

### 1) Create Movie Type
1. Add a Movie.swift file. Create a struct called Movie with 3 properties: Title, Description, PosterURL
1. Declare all the properties as let (read only)
	* normally this is not required because setting a struct to a let variable automatically makes its properties read only. However, we are using a var to store the model property for the cell. Setting the Movie properties as let will guarantee us that the title, description and URL are never changed on us.
	* [Screenshot](/ImagesForGuide/swiftNiceMovieType.png)
1. Make the IBOutlets in the cell private
1. add an internal property to the cell called model and make it of type movie
1. In the didSet{} method of the model property, set the title and description labels, also set the image view to nil.
	* [Screenshot](/ImagesForGuide/swiftNiceCell.png)
1. In cellForRowAtIndexPath, use guards to make the cell and the moviesArray not optional
1. Then create the Movie type and set it on the cell
	* [Screenshot](/ImagesForGuide/swiftNiceTableView.png)
1. Run. the movie titles and descriptions should work but no posters.

### 2) Create Basic Downloader Class
1. Create new swift file called Downloader. Declare a class called Downloader
	1. The class needs a private var property that is a Dictionary with key type NSURL and Value type NSData
	1. The class needs a private let property for an NSURLSession
	1. The class needs an internal func called beginDownloadingURL(downloadURL: NSURL)
	1. In this method, we need to create a data task with completion handler
	1. In the completion handler, guard to make sure the data is not nil, also guard to make sure the response is of type NSHTTPURLResponse
	1. Switch on the responses status code to make sure its response 200
	1. In the 200 case, add the URL and data to the dictionary property. 
	1. Don’t forgot to call resume() at the end of the closure.
	1. Also, print to the console so we know data was downloaded
		* [Screenshot](/ImagesForGuide/swiftNiceDownloaderClass.png)
1. In the view controller declare a private let property for the new downloader class.
	1. Then in viewDidLoad, delete all the NSURLSession code for downloaded the JSON file.
	1. Instead, ask the downloader class to download the JSON file for us.
		* [Screenshot](/ImagesForGuide/swiftNiceDownloaderViewController.png)
1. Run - make sure the JSON data prints to the log

### 2) Create Delegate for Downloader
1. In the downloader file, declare a class protocol called DownloaderDelegate with func downloadFinishedForURL(finishedURL: NSURL) as its only method
	1. In the Downloader class add a weak var for this delegate type called delegate
	1. In the switch 200 case for the downloaded file, remove the print line and add self.delegate?.downloadFinishedForURL()
		* [Screenshot](/ImagesForGuide/swiftNiceDownloaderProtocol.png)
1. In the ViewController, add an extension that adds compliance for the DownloaderDelegate protocol
	1. in the required method, just print the URL that finishes downloading.
	1. in viewDidLoad, make sure to set the delegate of the Downloader to self.
	1. Run - make sure the JSON url prints in the console
		* [Screenshot](/ImagesForGuide/swiftNiceDownloaderViewController_02.png)
1. In the downloader class, create a dataForURL method that return NSData?. This method should be a 1 liner that returns the dictionary value of self.downloaded[url]
1. In the viewController change the downloadFinishedForURL method to print(“url: \(finishedURL), data: \(self.downloader.dataForURL(finishedURL))”)

### 3) Parse the JSON Dictionary
1. In the view controller, Declare the JSON URL as a let constant on the class.
1. Change viewDidLoad download to use this new constant property.
1. In downloadFinishedForURL, Check if the finishedURL matches the JSONURL, if it does then this is the JSON file, not an image.
1. change downloadFinishedForURL to guard to make sure the data for the URL is present.
1. perform a try? to convert the data into JSON, populate the moviesArray and then reload the tableView
1. Run, the table should now populate with no images again
	* [Screenshot](/ImagesForGuide/swiftNiceDownloaderViewController_03.png)

### 4) Download Images for Cells
1. In the MoveiTableViewCell create a method called updateDisplayImages(newImage: UIImage)
	1. In this method, set the ImageView image property to the newImage.
1. In the view controller override tableView:willDisplayCell:forRowAtIndexPath:
1. In this method, guard to make sure the cell is of type MovieTableViewCell
1. Also guard to make sure the cell who a model property set.
1. In an if let statement, check the downloader if we already have data for this cell, then check if a UIImage can be made from the data.
1. In this if let closure call updateDisplayImages on the cell with the image.
1. In the else block, ask the downloader to download the URL.
1. Run - images will be downloading and might display but it will be very unreliable and require scrolling around.
	* [Screenshot](/ImagesForGuide/swiftNiceDownloaderViewController_04.png)

### 5) Update Cells When Downloads Finish
1. In the view controller, Delete the yucky existing downloadImageForCell method
1. In the downloadFinishedForURL method, in the else block of the JSON URL if statement, we want to parse images out of the data received an update cells.
1. guard to make sure we have valid image data
1. Create a for in loop that iterates through self.tableView.visibleCells
1. In the for in loop, guard to make sure the cell is of type MovieTableViewCell
1. Then check the posterURL of the cell and see if it matches the finishedURL from the callback
1. dispatch to the main queue to call updateDisplayImages on the cell with the image we created in the guard a couple steps back
1. call break outside of the dispatch closure so we don’t keep looping
1. Run - now everything should work really well
	* [Screenshot](/ImagesForGuide/swiftNiceDownloaderViewController_05.png)

### 6) Clean up the cellForRowAtIndexPathCode
1. This code is pretty ugly because we’re parsing through an untyped dictionary of JSON. It would be nice if we preprocessed the JSON file into Movie types, stored an array of that and then populated the cells with already formatted data.
1. In the Movie.swift file, create an extension of the Movie type. In the extension declare a static func called moviesFromDictionaryArray(dictionaryArray: [NSDictionary]) that returns an optional [Movie]?
1. declare a variable at the top of the method called movieArray and initialize it to be an empty array of Movie type.
1. In the view controller copy the code from cellForRowAtIndexPathCode where we parse the JSON and put it into this new static func
1. Now create a for in loop on the dictionaryArray, in each loop use the code we pasted in and add the Movie to the movieArray declared earlier.
1. Lastly, check if the movieArray isEmpty and if it is return nil, otherwise return the array.
	* [Screenshot](/ImagesForGuide/swiftNiceMovieType_02.png)
1. In the view controller, delete all the yucky code from cellForRowAtIndexPathCode, we’re only going to guard here to make sure the cell is of the right type and thats it.
1. Change the moviesArray property on the viewController to be of type [Movie]?
1. In downloadFinishedForURL we need to use the new static func we created on the movie type to populate self.moviesArray
	* [Screenshot](/ImagesForGuide/swiftNiceDownloaderViewController_06.png)
1. In tableView:willDisplayCell:forRowAtIndexPath: remove the guard that verifies the cell already has a model, add a guard to verify self.moviesArray exists
1. Declare let cellModel = moviesArray[indexPath.row] to get the model out of the array
1. Then set the model property on the cell with this new cellModel
1. Run - everything should work as before
	* [Screenshot](/ImagesForGuide/swiftNiceDownloaderViewController_07.png)

### Project Files
* [Project files at the end of this section](http://github.com/mobilebridge/iosbridge-rottentomatoes/releases/tag/v0.7-Swift-Improvements)



## Improving Code with Swift Features

### Summary
In this section we are going to improve the code with nice swift features and other miscellaneous improvements. Concepts we will introduce:

1. New Types, particularly structs. If possible you may want to explain the different between Reference types and Value types in swift.
1. Guard statements in Swift and how to use them
1. Private Methods / Properties
1. Extensions
1. Do/Catch error Handling in Swift
1. Using a Model for the Cell Class. We are going to give the cell a single item and it will lay itself out, instead of the ViewController doing it for the cell.
1. Download class. We will create a class that downloads the artwork and notifies the cells as needed. This class will be very very generic, handling NSURL and NSData so it can be reused for many things.
1. Protocols and Delegates. We are going to define Protocols for the download class so it can safely communicate with other objects.

### 1) Create Movie Type
1. Add a Movie.swift file. Create a struct called Movie with 3 properties: Title, Description, PosterURL
1. Declare all the properties as let (read only)
	* normally this is not required because setting a struct to a let variable automatically makes its properties read only. However, we are using a var to store the model property for the cell. Setting the Movie properties as let will guarantee us that the title, description and URL are never changed on us.
	* reference screenshot
	* [Screenshot](/ImagesForGuide/swiftNiceMovieType.png)
1. Make the IBOutlets in the cell private
1. add an internal property to the cell called model and make it of type movie
1. In the didSet{} method of the model property, set the title and description labels, also set the image view to nil.
	* reference screenshot
	* [Screenshot](/ImagesForGuide/swiftNiceCell.png)
1. In cellForRowAtIndexPath, use guards to make the cell and the moviesArray not optional
1. Then create the Movie type and set it on the cell
	* reference screenshot
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
		* Reference Screenshot
		* [Screenshot](/ImagesForGuide/swiftNiceDownloaderClass.png)
1. In the view controller declare a private let property for the new downloader class.
	1. Then in viewDidLoad, delete all the NSURLSession code for downloaded the JSON file.
	1. Instead, ask the downloader class to download the JSON file for us.
		* Reference Screenshot
		* [Screenshot](/ImagesForGuide/swiftNiceDownloaderViewController.png)
1. Run - make sure the JSON data prints to the log

### 2) Create Delegate for Downloader
1. In the downloader file, declare a class protocol called DownloaderDelegate with func downloadFinishedForURL(finishedURL: NSURL) as its only method
	1. In the Downloader class add a weak var for this delegate type called delegate
	1. In the switch 200 case for the downloaded file, remove the print line and add self.delegate?.downloadFinishedForURL()
		* Reference Screenshot
		* [Screenshot](/ImagesForGuide/swiftNiceDownloaderProtocol.png)
1. In the ViewController, add an extension that adds compliance for the DownloaderDelegate protocol
	1. in the required method, just print the URL that finishes downloading.
	1. in viewDidLoad, make sure to set the delegate of the Downloader to self.
	1. Run - make sure the JSON url prints in the console
		* Reference Screenshot
		* [Screenshot](/ImagesForGuide/swiftNiceDownloaderViewController_02.png)
1. In the downloader class, create a dataForURL method that return NSData?. This method should be a 1 liner that returns the dictionary value of self.downloaded[url]
1. In the viewController change the downloadFinishedForURL method to print(“url: \(finishedURL), data: \(self.downloader.dataForURL(finishedURL))”)

### 3) Parse the JSON Dictionary
1. In the view controller, Declare the JSON URL as a let constant on the class.
1. Check if the finishedURL matches the JSONURL
1. change downloadFinishedForURL to guard to make sure the data for the URL is present.
1. perform a do / catch block to convert the data into JSON, populate the moviesArray and then reload the tableView
1. Run, the table should now populate with no images again
	* Reference Screenshot
	* [Screenshot](/ImagesForGuide/swiftNiceDownloaderViewController_03.png)

### 4) Download Images for Cells





## Downloading Poster Images and Displaying Them in Cells

### Summary
The concept of reusable cells is pretty hard for a beginner to grasp. Based on the experience level of your class, use your best judgement about how much detail to go into when explaining reusable cells. In this section we are going to do the following:

1. Add an NSURL property to the MovieTableViewCell. We will use this as the “identity” of the cell. When the asynchronous image downloads, it will check the cell’s URL to make sure it matches the URL of the downloaded image before populating the UIImageView with the image.
1. Add a method to MovieListTableViewController that configures an NSURLSessionDataTask to download the poster image on behalf of the MovieTableViewCells
1. Modify ```tableView:cellForRowAtIndexPath``` to extract the URL for the poster thumbnail image and start the download by calling the method we made in the step before. Then set the image property of the cell’s UIImageView to nil so that when cells are recycled, the old image doesn’t stick around.

### 1) Add Property to MovieTableViewCell
1. Open the MovieTableViewCell file (.h file in Objective C, Swift file in Swift). Add a strong property called ```posterURL``` of type NSURL (NSURL? in Swift).
	* [Objective-C Reference Screenshot](/ImagesForGuide/imageDownload01_objc.png)
	* [Swift Reference Screenshot](/ImagesForGuide/imageDownload01_swift.png)

### 2) Add Method to MovieListTableViewController
1. Add a method that returns void and takes an NSURL to download and a MovieTableViewCell instance so it this method can set the image in the cell’s Image View
	* Objective-C: ```-(void)downloadImageURL:(NSURL *)downloadURL ForCell:(MovieTableViewCell *)cell```
	* Swift: ```func downloadImageURL(downloadURL: NSURL, ForCell cell: MovieTableViewCell?)```
1. Next, create an ```NSURLRequest``` for the ```downloadURL``` that uses the ```NSURLRequestReturnCacheDataElseLoad``` cache policy.
1. Next, create an ```NSURLSessionTask``` by calling ```dataTaskWithRequest:ComplectionHandler:``` on the ```NSURLSession sharedSession.```
	* Don’t forget to call resume on the task
1. In the completion handler block, cast the response instance as ```NSHTTPURLResponse``` and then switch on its ```statusCode``` property. In the switch, create a case for 200.
1. In the 200 case, dispatch to the main queue. We are going to be touching the UI and strange bugs will happen if we don’t.
1. Now check to make sure the ```downloadURL``` still matches the ```posterURL``` property on the cell. The cell could have changed while the download was happening.
	* Don’t forget that Objective-C requires calling isEqual, not using ==
1. Create a ```UIImage``` from the data returned by the completed data task.
1. Set the Image View of the cell to the new image.
	* [Objective-C Reference Screenshot](/ImagesForGuide/imageDownload02_objc.png)
	* [Swift Reference Screenshot](/ImagesForGuide/imageDownload02_swift.png)

### 3) Modify CellForRowAtIndexPath
1. Near where the title and description labels of the cell are being set, set ```moviePosterImageView.image``` property to nil.
	* Explain the importance of this in regard to how cells are reused.
1. Create an NSDictionary from the “posters” key of the ```movie``` dictionary.
1. Create a String from the “thumbnail” key of the posters dictionary.
1. Create an NSURL from the thumbnail string. Then set the ```posterURL``` property of the cell to this string.
1. Lastly, call ```downloadImageURL:ForCell:``` on self. This will start the image download.
	* [Objective-C Reference Screenshot](/ImagesForGuide/imageDownload03_objc.png)
	* [Swift Reference Screenshot](/ImagesForGuide/imageDownload03_swift.png)

### 4) (Optional) Experiment
If time allows, try experimenting by commenting out the parts of the code that protect against cell reuse bugs.

* If possible, enable the Link Condition on your Mac or iPhone to simulate an EDGE connection. Show the students how slowly the images load
* Comment out the line of code that sets the ```moviePostImageView.image``` to nil. Show how, as you scroll, the wrong images appear in the wrong cells.
* Comment out the if statement that checks to make sure the ```posterURL``` matches the ```downloadURL``` and show how the wrong images get set to the wrong cells.

### Project Files
* [Objective-C Reference Screenshot](/ImagesForGuide/imageDownload04_objc.png)
* [Swift Reference Screenshot](/ImagesForGuide/imageDownload04_swift.png)
* [Project files at the end of this section](http://github.com/mobilebridge/iosbridge-rottentomatoes/releases/tag/v0.6-Working-App)
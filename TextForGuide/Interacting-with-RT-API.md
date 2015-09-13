## Interacting with the Rotten Tomatoes API
### Summary
In this section, we’re going to download the a JSON file from Rotten Tomatoes with NSURLSession, we’re going to parse the JSON file and store it in a Property on the UITableViewController and then we’re going to populate the UILabels in the cells with the movie data. The NSURLSession and JSON parsing code are probably going to be another “beer goggles” moment for most students. Try not to get slowed down too much by answering questions. There’s a lot of work to do. You can answer detailed questions in the end.

* Rotten Tomatoes requires an API token. If the student didn’t bring one, try and share 2 or 3 among the class. The limits are pretty high, so its doubtful they will get hit during class.
* App Transport Security is going to block us in iOS 9. The rotten tomatoes API does not support HTTPS. Same with the image posters.
* Again, remember that many students won’t know what a Dictionary or an Array are. We will be using both in this section. Try not to get bogged down with how the technicalities of how JSON gets converted into Arrays and Dictionaries. Ask the students to put on their beer goggles and focus on getting the movie information into the cells.

### 1) Configure NSURLSession
1. Verify that this URL works for each student in their browser with their API Key:
	* http://api.rottentomatoes.com/api/public/v1.0/lists/movies/upcoming.json?apikey=[api_key_here]
1. Create an Array property on the MovieListTableViewController called ```moviesArray```.
	* (Swift only) Make the property optional
1. In ```ViewDidLoad```, create an ```NSURLSessionTask``` by calling ```dataTaskWithURL:ComplectionHandler:``` on the ```NSURLSession sharedSession.```
	* Don’t forget to call resume on the task.
1. Run the project - notice how we have been foiled by App Transport Security. Explain this new iOS 9 “feature.”

### 2) Configure App Transport Security
1. In the Info.plist file for the project (not for the tests) add Dictionary and Boolean entries for the two required domains.
1. Refer to reference Screenshot
	* [Screenshot](/ImagesForGuide/rottenTomatoesJSON02.png)
1. Run the app again. Now we should get no error

### 3) Extract Movie Data from JSON
1. Add an NSLog to print the JSON data so the students can see what they are starting with.
1. Run the project to get that print of the JSON data.
1. Use ```NSJSONSerialization JSONObjectWithData:options:error``` to convert the downloaded data into an NSDictionary
1. Create an NSArray from the “movies” key of the JSON Dictionary
1. Next, dispatch into the main thread. Set the ```moviesArray``` property to the array you just extracted in the step above.
1. Next, call ```reloadData``` on ```self.tableView```.
	* Calling to the main queue is important because the property we are modifying is non-atomic and reloadData updates the UI.
1. Refer to Screenshots for Details
	* [Objective-C Reference Screenshot](/ImagesForGuide/rottenTomatoesJSON01_objc.png)
	* [Swift Reference Screenshot](/ImagesForGuide/rottenTomatoesJSON01_swift.png)

### 4) Configure TableView with Movie Data
1. In ```tableView:numberOfRowsInSection:``` return the count of the ```self.moviesArray.count```
1. In ```tableView:cellForRowAtIndexPath:``` create a variable that holds the NSDictionary in self.moviesArray[indexPath.row] called movie.
1. The movie title NSString can be found with ```movie[“title”]``` and the description with  ```movie[“synopsis”]```
1. Use these two strings to populate the ```titleLabel``` and the ```descriptionLabel``` in the cell.
1. Run the app in the simulator and make sure the Title text and Description text is showing up in the tableView.
1. Refer to Screenshots for Details
	* [Objective-C Reference Screenshot](/ImagesForGuide/rottenTomatoesJSON01_objc.png)
	* [Swift Reference Screenshot](/ImagesForGuide/rottenTomatoesJSON01_swift.png)

### Project Files
* Project files are out of date because of ATS in iOS9. Please refer to the finished project in the repo to see full implementation.
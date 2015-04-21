## UITableViewController and Prototype Cells

### Summary
We’re going to throw the previous View Controller and start over with a UITableViewController in a UINavigationController. We’re going to create a prototype cell and UITableViewCell subclass. Then we’re going to load 5 or so of the prototype cells in the UITableViewController. We’re going to wire up interface elements in the prototype cell to the UITableViewCell subclass. Lastly, we’re going to change the text of one the labels in CellForRowAtIndexPath.
* Main Concepts
	* Prototype Cells are like cell templates. Each cell uses the same template but loads different data into it.
	* TableViews ask the UITableViewController for the number of rows in the table. Then the TableView asks for individual cells
	* Each cell must be configured by the UITableViewController before returning it to the TableView
* Main Gotchas 
	* TableViews can be confusing to anyone new to iOS. Use your own intuition with the skill level of your class to determine how deep to go into UITableViewCell reuse. With advanced students, explain how the pointers are reused and all properties need to be reset. With students that are new to a C based language, try not to get bogged down with detailed questions until we get to loading images into the cells [later in the curriculum.](/TextForGuide/Downloading-Poster-Art.md)
	* The Cell recycling is another concept that is really hard to understand, and for now, its best to not mention it or mention it will be explained later.  

### 1) Throw Away ViewController
1. Throw away the ViewController code file(s) and the ViewController scene in the Storyboard.
1. In the storyboard, drag in a UINavigationController. This should also create UITableViewController at the same time.
	* Make sure the UINavigationController is marked as the Initial View Controller.
	* Make sure the “Simulated Metrics > Size” is set to the same device the student is using in the simulator.
1. Create a UITableViewController subclass via File > New > File. Call it MovieListTableViewController
1. Change the class of the UITableViewController in the Storyboard to MovieListTableViewController
1. (Objective-C Only) - Make sure the .m file of the MovieListTableViewController has an @Interface.
1. Override ViewDidLoad, set breakpoint, and run Application to verify that this MovieListTableViewController is loading properly.
	* [Objective-C Reference Screenshot](/ImagesForGuide/tableView01_objc.png)
	* [Swift Reference Screenshot](/ImagesForGuide/tableView01_swift.png)

### 2) Create Movie Prototype Cell
1. Show how to add and remove prototype cells from the UITableViewController. Settle on 1 tall-ish (Approx 100 points) prototype cell.
	* Be sure the row height on the UITableView in the Storyboard matches the cell height set above.
1. Give the Prototype Cell a cell reuse identifier of “MovieCell”
1. Populate the prototype cell with a UIImageView and 2 UILabels. Arrange them so they are similar to the screenshot below.
	* Show how to use the preferred font styles like Headline and Body to make font size choices easier.
	* [Reference Screenshot](/ImagesForGuide/tableView02.png)
1. In MovieListTableViewController, override ```tableView:numberOfRowsInSection``` and return 5 or so. Also override ```tableView:cellForRowAtIndexPath``` and return cells with the “MovieCell” reuse identifier. Run in the simulator to make sure that the custom cell is showing up 5 times.
	* Explain the relationship between ```tableView:numberOfRowsInSection``` and ```tableView:cellForRowAtIndexPath``` that lead to 5 cells being created.
	* [Objective-C Reference Screenshot](/ImagesForGuide/tableView03_objc.png)
	* [Swift Reference Screenshot](/ImagesForGuide/tableView03_swift.png)

### 3) Create Custom UITableViewCell Subclass
1. Add a new file that is a UITableViewCell subclass, Name it ```MovieTableViewCell```.
1. Change the class of the Prototype Cell in the Storyboard to ```MovieTableViewCell```.
1. Create IBOutlets for the 3 views that are in the prototype cell.
	* Note that if working in Objective C, its best to create the IBOutlets in the .h file rather the .m file.
	* Note if you have trouble getting the Assistant editor to show the correct file, be sure you are selecting the “Content View” in the cell instead of the Prototype Cell itself in the storyboard.
1. Change ```tableView:cellForRowAtIndexPath``` in MovieListTableViewController to change the title label to something like “This is cell number X” where X is the IndexPath Row.
	* [Objective-C Reference Screenshot](/ImagesForGuide/tableView04_objc.png)
	* [Swift Reference Screenshot](/ImagesForGuide/tableView04_swift.png)
1. Run in the simulator and make sure this custom title label is working.
	* Explain how ```tableView:cellForRowAtIndexPath``` is customizing each cell before it gets displayed in the tableView

### Project Files
* [Project files at the end of this section](/mobilebridge/iosbridge-rottentomatoes/releases/tag/v0.3-TableCellsDone)
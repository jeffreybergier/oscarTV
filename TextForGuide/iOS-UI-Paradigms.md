## Understanding iOS UI Paradigms
### About
Its important that the students have a basic understanding of how most apps work on iOS. Show them the Music app and messages app on your phone. Show them how most apps consist of the following basic elements.

### Container Views
1. UIViewController
	* UIViewControllers represent a “screen” in an application. 
	* They can also be thought of as a single “page” in a web site
	* Generally 1 UIViewController equals 1 “screen” of your app.
1. UINavigationController
	* Title bar at the top of most apps
		* Shows Title
		* Usually presents an “action” button at the top right.
		* Usually shows a back button at the top left.
	* Transitions you from 1 “screen” to another.
1. UITabBarController
	* Works like tabs in a web browser
	* Each tab in the bar contains on UIViewController (screen)
	* Tapping a tab switches the user between these screens.
1. UITableView & UITableViewController
	* The most basic type of list view in iOS
	* Contains rectangular cells that are stacked on each other vertically.
	* Most apps in iOS are TableViews. 
	* Twitter, Instagram, etc
	* Pictures and tweets in the same layout stacked on top of each other.

### Presentation Styles
1. Navigation Controller “Push”
	* Used when navigating from a broad concept to a more specific concept.
		* E.g. All Artists > Specific Artist > Specific Album 
	* Works very much like a web browser.
		* When the user taps a button, they are taken to the next screen.
		* The back button takes them back to where the first button was tapped.
	* Screens continue to stack on top of each other as the user browses deeper into the app
1. Modal Presentation
	* Used when making something new
		* E.g. Composing a new Tweet or Facebook Post or SMS
	* Slides a new screen up from the bottom of the phone.
	* Slides on top of the Navigation Controller.

### Quick Design Session
1. Whiteboard with the students to show how a basic Rotten Tomatoes app could be designed and browsed through
1. ToDo: Insert picture of whiteboard.

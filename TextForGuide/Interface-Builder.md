## Understanding How Interface Builder Connects With Code
### Summary
In this section, we’re finally going to be in Xcode. We are going to start with a single window project. In the View Controller that comes with the project we are going to place some Views and hook them up to the code with IBOutlets and IBActions. Once the elements are hooked up, we’ll make it so touching the update button, takes the text from the text field and puts it into the label.
* Its probably best try to explain the difference between an IBOutlet and an IBAction. Its a pretty confusing concept. I usually like to explain them as different “directions” of communication.
	* IBOutlets let your code tell the object in the storyboard to do something.
	* IBActions let objects in the storyboard tell your code to do something.

### 1) Build and Run
1. Instruct the students to change the background color of the View Controller in the storyboard and make sure that color shows up in the simulator.
	* This will make sure everyone’s Xcode and Simulator are working properly.
1. Lastly, make sure they change the Size under “Simulated Metrics” to match the size of the device they are using in the simulator.
	* This makes it so we don’t need to worry about AutoLayout in this class.
	* [Reference Screenshot](/ImagesForGuide/interfaceBuilder01.png)


### 2) Drag in Views
1. Instruct the students to drag in a UIButton, a UITextField and a UILabel.
	* [Reference Screenshot](/ImagesForGuide/interfaceBuilder02.png)
1. Connect 3 IBOulets (1 for each object in the storyboard) and 1 IBAction (for the button)
	* [Objective-C Reference Screenshot](/ImagesForGuide/interfaceBuilder03_objc.png)
	* [Swift Reference Screenshot](/ImagesForGuide/interfaceBuilder03_swift.png)
1. Insert an NSLog statement into the IBAction and make sure all students can click the button to cause the log output.
	* This is also a good opportunity to show how breakpoints can be used to make sure a button is working.

### 3) Configure the IBAction
1. Configure the code so tapping the button takes the text from the UITextField and puts it into the UILabel.
	* [Objective-C Reference Screenshot](/ImagesForGuide/interfaceBuilder4_objc.png)
	* [Swift Reference Screenshot](/ImagesForGuide/interfaceBuilder4_swift.png)
1. Have the students experiment with typing text into the simulator and clicking the update button to move it to the label.
1. Optionally, have the keyboard dismiss when clicking update
1. Optionally, show how to get multiple lines of text in the text label.

### Project Files
* [Project Files at the end of this section](http://github.com/mobilebridge/iosbridge-rottentomatoes/releases/tag/v0.2-InterfaceBuilderDone)
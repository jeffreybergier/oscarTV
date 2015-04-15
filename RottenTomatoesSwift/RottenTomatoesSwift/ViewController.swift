//
//  ViewController.swift
//  RottenTomatoesSwift
//
//  Created by Jeffrey Bergier on 4/13/15.
//  Copyright (c) 2015 MobileBridge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var upperTextField: UITextField!
    @IBOutlet weak var upperUpdateButton: UIButton!
    @IBOutlet weak var lowerTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func update(sender: UIButton) {
        let textFromTextField = self.upperTextField.text
        self.lowerTextLabel.text = textFromTextField
    }

}


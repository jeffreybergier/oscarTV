//
//  MovieTableViewCell.swift
//  RottenTomatoesSwift
//
//  Created by Jeffrey Bergier on 4/15/15.
//  Copyright (c) 2015 MobileBridge. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    var posterURL: NSURL?
    
}

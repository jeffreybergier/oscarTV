//
//  MovieTableViewCell.swift
//  RottenTomatoesSwift
//
//  Created by Jeffrey Bergier on 4/15/15.
//  Copyright (c) 2015 MobileBridge. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    var model: Movie? {
        didSet {
            guard let newMovie = self.model else  { return }
            self.movieTitleLabel.text = newMovie.title
            self.movieDescriptionLabel.text = newMovie.description
            self.moviePosterImageView.image = .None
        }
    }
    
    @IBOutlet private weak var moviePosterImageView: UIImageView!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var movieDescriptionLabel: UILabel!
    
    func updateDisplayImages(newImage: UIImage) {
        self.moviePosterImageView.image = newImage
    }
    
    var posterURL: NSURL?
    
}

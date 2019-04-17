//
//  MovieCell.swift
//  MovieRx
//
//  Created by Gustavo Henrique on 17/04/19.
//  Copyright © 2019 Gustavo Henrique. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieImgView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!


    func configure(viewModel: MovieViewModel) {
        movieNameLabel.text = viewModel.title
        movieDescriptionLabel.text = viewModel.overView
        movieReleaseDateLabel.text = viewModel.relaseDate
        ratingLabel.text = viewModel.rating
        movieImgView.downloaded(from: viewModel.posterUrl)
    }
    
}

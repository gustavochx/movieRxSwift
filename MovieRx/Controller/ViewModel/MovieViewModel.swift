//
//  MovieViewModel.swift
//  MovieRx
//
//  Created by Gustavo Henrique on 17/04/19.
//  Copyright © 2019 Gustavo Henrique. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


struct MovieViewModel {

    private var movie: Movie

    private static let dateFormatter: DateFormatter = {
        $0.dateStyle = .medium
        $0.timeStyle = .none
        return $0
    }(DateFormatter())

    init(newMovie: Movie) {
        self.movie = newMovie
    }

    var title: String{
        return self.movie.title
    }

    var overView: String{
        return self.movie.overview
    }

    var posterUrl: URL{
        return self.movie.posterURL
    }

    var relaseDate: String{
        return MovieViewModel.dateFormatter.string(from: self.movie.releaseDate)
    }

    var rating: String {
        let rating = Int(self.movie.voteAverage)
        return (0..<rating).reduce("") { (acc,_) -> String in
            return acc + "⭐️"
        }
    }

}

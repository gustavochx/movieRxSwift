//
//  MovieSearchViewModel.swift
//  MovieRx
//
//  Created by Gustavo Henrique on 17/04/19.
//  Copyright © 2019 Gustavo Henrique. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieSearchViewModel {

    private let movieService: MovieService
    private let disposeBag = DisposeBag()
    private let _movies = BehaviorRelay<[Movie]>(value: [])
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _info = BehaviorRelay<String?>(value: nil)

    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    var movies: Driver<[Movie]> {
        return _movies.asDriver()
    }
    var info: Driver<String?> {
        return _info.asDriver()
    }
    var hasInfo: Bool {
        return _info.value != nil
    }
    var numberOfMovies: Int {
        return _movies.value.count
    }


    init(query: Driver<String>, newMovieService: MovieService) {
        self.movieService = newMovieService
        query.throttle(1.0).distinctUntilChanged().drive(onNext: { [weak self] (queryString) in
            self?.searchMovie(query: queryString)
            if queryString.isEmpty {
                self?._movies.accept([])
                self?._info.accept("Start searching your favorite movies")
            }
        }).disposed(by: disposeBag)
    }

    func viewModelForMovie(at index:Int) -> MovieViewModel? {
        guard index < _movies.value.count else {
            return nil
        }
        return MovieViewModel(newMovie: _movies.value[index])
    }

    private func searchMovie(query: String?) {
        guard let query = query, !query.isEmpty else {
            return
        }

        self._movies.accept([])
        self._isFetching.accept(true)
        self._info.accept(nil)

        self.movieService.searchMovie(query: query, params: nil, successHandler: { [weak self](response) in
            self?._isFetching.accept(false)
            if response.totalResults == 0 {
                self?._info.accept("No result for \(query)")
            }
            self?._movies.accept(response.results)
        }) { [weak self] (error) in
            self?._isFetching.accept(false)
            self?._info.accept(error.localizedDescription)
        }
    }
}

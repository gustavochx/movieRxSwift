//
//  MovieListViewModel.swift
//  MovieRx
//
//  Created by Gustavo Henrique on 17/04/19.
//  Copyright © 2019 Gustavo Henrique. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieListViewModel {

    private let movieService: MovieService
    private let disposeBag: DisposeBag = DisposeBag()
    private let _movies = BehaviorRelay<[Movie]>(value: [])
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<String?>(value: nil)

    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }

    var movies: Driver<[Movie]>{
        return _movies.asDriver()
    }

    var error: Driver<String?>{
        return _error.asDriver()
    }

    var hasError: Bool {
        return _error.value != nil
    }

    var numberOfMovies: Int{
        return _movies.value.count
    }

    init(newEndpoint: Driver<Endpoint>, newMovieService: MovieService) {
        self.movieService = newMovieService
        newEndpoint.drive(onNext: { [weak self] (endpoint) in
                self?.fetchMovies(endpoint: endpoint)
            }).disposed(by: disposeBag)
    }

    func viewModelForMovie(at index:Int) -> MovieViewModel? {
        guard index < _movies.value.count else {
            return nil
        }
        return MovieViewModel(newMovie: _movies.value[index])
    }

    func fetchMovies(endpoint: Endpoint) {self._movies.accept([])
        self._isFetching.accept(true)
        self._error.accept(nil)
        movieService.fetchMovies(from: endpoint, params: nil, successHandler: {[weak self] (response) in
            self?._isFetching.accept(false)
            self?._movies.accept(response.results)
        }) { [weak self] (error) in
            self?._isFetching.accept(false)
            self?._error.accept(error.localizedDescription)
        }
    }

}

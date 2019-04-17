//
//  MoviesListViewController.swift
//  MovieRx
//
//  Created by Gustavo Henrique on 17/04/19.
//  Copyright © 2019 Gustavo Henrique. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MoviesListViewController: UIViewController {

    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    let disposeBag = DisposeBag()
    var movieListViewModel: MovieListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }

    private func setupViewController() {

        movieListViewModel = MovieListViewModel(newEndpoint: segmentedControl.rx.selectedSegmentIndex
            .map { Endpoint(index: $0) ?? .nowPlaying }
            .asDriver(onErrorJustReturn: .nowPlaying)
            ,newMovieService: Gateway.shared)

        movieListViewModel.movies.drive(onNext: {[unowned self] (_) in
            self.moviesTableView.reloadData()
        }).disposed(by: disposeBag)

        movieListViewModel.isFetching.drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

        movieListViewModel.error.drive(onNext: {[unowned self] (error) in
            self.infoLabel.isHidden = !self.movieListViewModel.hasError
            self.infoLabel.text = error
        }).disposed(by: disposeBag)

        setupTableView()
    }

    private func setupTableView() {
        moviesTableView.tableFooterView = UIView()
        moviesTableView.rowHeight = UITableView.automaticDimension
        moviesTableView.estimatedRowHeight = 100
        moviesTableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
    }

}

extension MoviesListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieListViewModel.numberOfMovies
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        if let vm = movieListViewModel.viewModelForMovie(at: indexPath.row) {
            cell.configure(viewModel: vm)
        }

        return cell
    }
}

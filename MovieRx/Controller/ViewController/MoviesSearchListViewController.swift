//
//  MoviesSearchListViewController.swift
//  MovieRx
//
//  Created by Gustavo Henrique on 17/04/19.
//  Copyright © 2019 Gustavo Henrique. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MoviesSearchListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    var moviesSearchViewModel: MovieSearchViewModel!
    let disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }

    private func setupViewController() {

        setupNavigationController()
        let searchBar = self.navigationItem.searchController!.searchBar

        moviesSearchViewModel = MovieSearchViewModel(query: searchBar.rx.text.orEmpty.asDriver(), newMovieService: Gateway.shared)
        moviesSearchViewModel.movies.drive(onNext: { [unowned self](_) in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)

        moviesSearchViewModel.isFetching.drive(activityIndicatorView.rx.isAnimating).disposed(by: disposeBag)

        moviesSearchViewModel.info.drive(onNext: { [unowned self](info) in
            self.infoLabel.isHidden = !self.moviesSearchViewModel.hasInfo
            self.infoLabel.text = info
        }).disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked.asDriver(onErrorJustReturn: ()).drive(onNext: { [unowned searchBar] in
            searchBar.resignFirstResponder()
        }).disposed(by: disposeBag)

        searchBar.rx.cancelButtonClicked.asDriver(onErrorJustReturn: ()).drive(onNext: { [unowned searchBar] in
            searchBar.resignFirstResponder()
        }).disposed(by: disposeBag)

        setupTableView()

    }

    private func setupNavigationController() {
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        self.definesPresentationContext = true
        navigationItem.searchController?.dimsBackgroundDuringPresentation = false
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController?.searchBar.sizeToFit()
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
    }

}

extension MoviesSearchListViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesSearchViewModel.numberOfMovies
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        if let viewModel = moviesSearchViewModel.viewModelForMovie(at: indexPath.row) {
            cell.configure(viewModel: viewModel)
        }
        return cell
    }
}

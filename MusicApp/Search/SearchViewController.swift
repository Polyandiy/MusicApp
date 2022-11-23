//
//  SearchViewControllers.swift
//  MusicApp
//
//  Created by Поляндий on 23.11.2022.
//

import UIKit

protocol SearchDisplayLogic: class
{
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData)

}

class SearchViewController: UIViewController, SearchDisplayLogic {
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic & SearchDataPassing)?

    @IBOutlet weak var table: UITableView!

    let searchController = UISearchController(searchResultsController: nil)
    private var searchViewModel = SearchViewModel.init(cells: [])
    private var timer: Timer?

    // MARK: - Setup Clean Code Design Pattern

    private func setup() {
        let viewController =        self
        let interactor =            SearchInteractor()
        let presenter =             SearchPresenter()
        let router =                SearchRouter()
        viewController.interactor = interactor
        viewController.router =     router
        interactor.presenter =      presenter
        presenter.viewController =  viewController
        router.viewController =     viewController
    }

    // MARK: - Routing



    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
//        doSomething()
        setup()
        setupSearchBar()
        setupTableView()
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    private func setupTableView() {
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    //MARK: - receive events from UI
    

    
    // MARK: - request data from SearchInteractor

//    func doSomething() {
//        let request = Search.Model.Request()
//        interactor?.makeRequest(request: request)
//    }


    // MARK: - display view model from SearchPresenter

    func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
        //nameTextField.text = viewModel.name
        switch viewModel {
        case .some:
            print("viewController .some")
        case .displayTracks(let searchViewModel):
            print("viewController .displayTracks")
            self.searchViewModel = searchViewModel
            table.reloadData()
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let cellViewModel = searchViewModel.cells[indexPath.row]
        cell.textLabel?.text = "\(cellViewModel.trackName)\n\(cellViewModel.artistName)"
        cell.textLabel?.numberOfLines = 2
        return cell
    }
}

//MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (_) in
            self?.interactor?.makeRequest(request: Search.Model.Request.RequestType.getTracks(searchTerm: searchText))
        })
    }
}


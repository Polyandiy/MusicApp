//
//  SearchViewControllers.swift
//  MusicApp
//
//  Created by Поляндий on 23.11.2022.
//

import UIKit

protocol SearchDisplayLogic: AnyObject {
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic & SearchDataPassing)?
    
    @IBOutlet weak var table: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    private var searchViewModel = SearchViewModel.init(cells: [])
    private var timer: Timer?
    private lazy var footerView = FooterView()
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    // MARK: - Setup Clean Code Design Pattern
    
    private func setup() {
        let viewController =         self
        let interactor =             SearchInteractor()
        let presenter =              SearchPresenter()
        let router =                 SearchRouter()
        viewController.interactor =  interactor
        viewController.router =      router
        interactor.presenter =       presenter
        presenter.viewController =   viewController
        router.viewController =      viewController
    }
    
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
        //table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.register(UINib(nibName: "TrackCell", bundle: nil), forCellReuseIdentifier: TrackCell.reuseID)
        table.tableFooterView = footerView
    }
    
    // MARK: - display view model from SearchPresenter
    
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
        //nameTextField.text = viewModel.name
        switch viewModel {
        case .displayTracks(let searchViewModel):
            print("viewController .displayTracks")
            self.searchViewModel = searchViewModel
            table.reloadData()
            footerView.hideLoader()
        case .gisplayFooterView:
            footerView.showLoadel()
        }
    }
}


   //MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseID, for: indexPath) as! TrackCell
        let cellViewModel = searchViewModel.cells[indexPath.row]
        //cell.trackImageView.backgroundColor = .blue
        cell.set(viewModel: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter searchterm above..."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchViewModel.cells.count  > 0 ? 0 : 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = searchViewModel.cells[indexPath.row]
//        let window = UIApplication.shared.keyWindow
//        let trackDetailView: TrackDetailView = TrackDetailView.loadNib()
//        trackDetailView.frame  = (window?.frame(forAlignmentRect: UIScreen.main.bounds))!
//        trackDetailView.set(viewModel: cellViewModel)
//        trackDetailView.delegate = self
        self.tabBarDelegate?.maximizeTrackDetailController(viewModel: cellViewModel)
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

//MARK: - TrackMovingDelegate
    
extension SearchViewController: TrackMovingDelegate {
    
    private func getTrack(isForwardTrack: Bool) -> SearchViewModel.Cell? {
        guard let indexPath = table.indexPathForSelectedRow else { return nil }
        table.deselectRow(at: indexPath, animated: true)
        var nextIndexPath: IndexPath!
        
        if isForwardTrack {
            nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if nextIndexPath.row == searchViewModel.cells.count {
                nextIndexPath.row = 0
            }
        } else {
            nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if nextIndexPath.row == -1 {
                nextIndexPath.row = searchViewModel.cells.count - 1
            }
        }
        table.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        let cellVM = searchViewModel.cells[nextIndexPath.row]
        return cellVM
    }
    
    func moveBackToPreviousTrack() -> SearchViewModel.Cell? {
        return getTrack(isForwardTrack: false)
    }
    
    func moveForwardToNextTrack() -> SearchViewModel.Cell? {
        return getTrack(isForwardTrack: true)
    }
    
    
}


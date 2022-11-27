//
//  TrackCell.swift
//  MusicApp
//
//  Created by Поляндий on 23.11.2022.
//

import UIKit
import SDWebImage

protocol TrackCellViewModelProtocol {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionName: String { get }
}

class TrackCell: UITableViewCell {
     
    static let reuseID = "TrackCell"
    var cell: SearchViewModel.Cell?
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var addTrackButton: UIButton!
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackImageView.image = nil
    }
    
    func set(viewModel: SearchViewModel.Cell) {
        self.cell = viewModel
        
        let savedTracks = UserDefaults.standard.savedTracks()
        let hasFavouriteTracks = savedTracks.first(where: {
            $0.trackName == self.cell?.trackName && $0.artistName == self.cell?.artistName
        }) != nil
        
        if hasFavouriteTracks {
            addTrackButton.isHidden = true
        } else {
            addTrackButton.isHidden = false
        }
        
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        
        guard let url = URL(string: viewModel.iconUrlString ?? "") else {return}
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    @IBAction func addTrackAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        guard let cell = cell else { return }
        addTrackButton.isHidden = true
        var listOfTracks = defaults.savedTracks()
        listOfTracks.append(cell)
        
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks, requiringSecureCoding: false) {
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
            print("успешно")
        }
    }
}

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
    var cell: SearchViewModel.Cell
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackImageView.image = nil
    }
    
    func set(viewModel: SearchViewModel.Cell) {
        
        self.cell = viewModel
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        
        guard let url = URL(string: viewModel.iconUrlString ?? "") else {return}
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    @IBAction func addTrackAction(_ sender: Any) {
//        print("add track")
//        let defaults = UserDefaults.standard
//        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: SearchViewModel.Cell.self, requiringSecureCoding: false) {
//            defaults.set(savedData, forKey: "tracks")
//        }
    }
}

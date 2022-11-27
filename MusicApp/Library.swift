//
//  Library.swift
//  MusicApp
//
//  Created by Поляндий on 27.11.2022.
//

import SwiftUI
import URLImage

struct Library: View {
    
    @State var tracks = UserDefaults.standard.savedTracks()
    @State var track: SearchViewModel.Cell!
    var tabBarDelegate: MainTabBarControllerDelegate?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button(action: {
                            print("play")
                            self.track = self.tracks[0]
                            self.tabBarDelegate?.maximizeTrackDetailController(viewModel: self.track)
                        }, label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9369442463, green: 0.3679696321, blue: 0.426602304, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9408460259, green: 0.9526903033, blue: 0.9524819255, alpha: 1)))
                                .cornerRadius(10)
                        })
                        Button(action: {
                            print("refresh")
                            self.tracks = UserDefaults.standard.savedTracks()
                        }, label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9369442463, green: 0.3679696321, blue: 0.426602304, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9408460259, green: 0.9526903033, blue: 0.9524819255, alpha: 1)))
                                .cornerRadius(10)
                        })
                    }
                }.padding().frame(height: 50)
                Divider().padding(.leading).padding(.trailing)
                
                List {
                    ForEach(tracks) { track in
                        LibraryCell(cell: track).simultaneousGesture(TapGesture().onEnded({ _ in
                            
                            let keyWindow = UIApplication.shared.connectedScenes
                                .filter({$0.activationState == .foregroundActive})
                                .map({$0 as? UIWindowScene})
                                .compactMap({$0})
                                .first?.windows
                                .filter({$0.isKeyWindow}).first
                            let tabBarVC = keyWindow?.rootViewController as? MainTabBarController
                            tabBarVC?.trackDetailView.delegate = self
                            
                            self.track = track
                            self.tabBarDelegate?.maximizeTrackDetailController(viewModel: self.track)
                        }))
                    }.onDelete(perform: delete)
                }
            }
            .navigationTitle("Library")
        }
    }
    
    func delete(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey )
        }
    }
}


struct LibraryCell: View {
    
    var cell: SearchViewModel.Cell
    
    var body: some View {
        HStack {
            URLImage(URL(string: cell.iconUrlString ?? "")!) { Image in
                Image
                    .resizable()
                    .frame(width: 60,height: 60)
                    .cornerRadius(2)
            }
            VStack(alignment: .leading) {
                Text("\(cell.trackName)")
                Text("\(cell.artistName)")
            }
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}

extension Library: TrackMovingDelegate {
    func moveBackToPreviousTrack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if myIndex - 1 == -1 {
            nextTrack = tracks[tracks.count - 1]
        } else {
            nextTrack = tracks[myIndex - 1]
        }
        self.track = nextTrack
        return nextTrack
    }
    
    func moveForwardToNextTrack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if myIndex + 1 == tracks.count {
            nextTrack = tracks[0]
        } else {
            nextTrack = tracks[myIndex + 1]
        }
        self.track = nextTrack
        return nextTrack
    }
}

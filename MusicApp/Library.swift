//
//  Library.swift
//  MusicApp
//
//  Created by Поляндий on 27.11.2022.
//

import SwiftUI
import URLImage

struct Library: View {
    var tracks = UserDefaults.standard.savedTracks()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button(action: {
                            print("play")
                        }, label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9369442463, green: 0.3679696321, blue: 0.426602304, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9408460259, green: 0.9526903033, blue: 0.9524819255, alpha: 1)))
                                .cornerRadius(10)
                        })
                        Button(action: {
                            print("refresh")
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
                
                List(tracks) { track in
                    LibraryCell(cell: track)
                }
            }
                .navigationTitle("Library")
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

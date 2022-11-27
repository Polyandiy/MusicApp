//
//  Library.swift
//  MusicApp
//
//  Created by Поляндий on 27.11.2022.
//

import SwiftUI

struct Library: View {
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
                
                List {
                    LibraryCell()
                    Text("Two")
                    Text("Three")
                    Text("Four")
                    Text("Five")
                }
            }
            
                .navigationTitle("Library")
        }
    }
}
//#colorLiteral(red: 0.9408460259, green: 0.9526903033, blue: 0.9524819255, alpha: 1)

struct LibraryCell: View {
    var body: some View {
        HStack {
            Image("Image")
                .resizable()
                .frame(width: 60,height: 60)
                .cornerRadius(2)
            VStack {
                Text("Track name")
                Text("Author  name")
            }
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}

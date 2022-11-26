//
//  ib.swift
//  MusicApp
//
//  Created by Поляндий on 26.11.2022.
//

import UIKit

extension UIView {
    
    class func loadNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
}

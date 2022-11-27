//
//  CMTime + Extension.swift
//  MusicApp
//
//  Created by Поляндий on 24.11.2022.
//

import UIKit
import AVKit

extension CMTime {
    
    func toDisplayString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else {return ""}
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
        return timeFormatString
    }
}

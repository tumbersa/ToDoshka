//
//  Orientation.swift
//  ToDoshka
//
//  Created by Глеб Капустин on 29.06.2024.
//

import UIKit

struct Orientation {
    static var isLandscape: Bool {
        get {
            let orientation = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.interfaceOrientation
            return orientation!.isLandscape
        }
    }
    static var isPortrait: Bool {
        get {
            let orientation = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.interfaceOrientation
            return orientation!.isPortrait
        }
    }
}

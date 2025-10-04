//
//  SDIcons.swift
//  SDIconsKit
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import SwiftUI

public enum SDIcons {
    case scroll
    
    var name: String {
        switch self {
        case .scroll:
            return "scroll"
        }
    }
    
    var bundle: Bundle {
        Bundle.packageBundle("SDIconsKit_SDIconsKit")
    }
    
    public var uiImage: UIImage {
        guard let image = UIImage(
            named: name,
            in: bundle,
            compatibleWith: nil
        ) else {
            return UIImage()
        }
        return image
    }
    
    public var image: Image {
        Image(name, bundle: bundle).resizable()
    }
}

//
//  ImageCashManager.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 06.09.2023.
//

import UIKit

class ImageCashManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}

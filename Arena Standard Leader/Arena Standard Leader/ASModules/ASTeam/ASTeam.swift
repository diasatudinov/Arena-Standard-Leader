//
//  ASTeam.swift
//  Arena Standard Leader
//
//

import SwiftUI

struct Team: Codable, Hashable, Identifiable {
    let id = UUID()
    var name: String
    var jobTitle: String
    var energyBalance: Double
    var note: String
    
    var imageData: Data?
    
    var image: UIImage? {
        get {
            guard let imageData else { return nil }
            return UIImage(data: imageData)
        }
        set {
            imageData = newValue?.jpegData(compressionQuality: 0.8)
        }
    }
    
}

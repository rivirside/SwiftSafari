//
//  Berries.swift
//  SwiftSafari
//
//  Created by Tomer Zilbershtein on 1/4/23.
//

import Foundation



class Berry: Identifiable, ObservableObject {
    let id = UUID()
    
    @Published var position: Vector
    @Published var fresh: Bool = true
    
    
    init(position: Vector) {
        self.position = position
    }
}


extension Berry {

}

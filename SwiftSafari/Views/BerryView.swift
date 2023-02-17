//
//  BerryView.swift
//  SwiftSafari
//
//  Created by Tomer Zilbershtein on 1/5/23.
//

import SwiftUI

struct BerryView: View {
    
    @ObservedObject var berry: Berry
    
    let size: CGFloat
    
    init(_ berry: Berry, _ size: CGFloat) {
        self.berry = berry
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .frame(width: self.size, height: self.size)
                .offset(x: CGFloat(berry.position.x-250), y: CGFloat(berry.position.y-250))
        }
    }
}

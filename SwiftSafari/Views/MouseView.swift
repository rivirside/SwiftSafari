//
//  MouseView.swift
//  SwiftSafari
//
//  Created by Tomer Zilbershtein on 1/5/23.
//

import SwiftUI

struct MouseView: View {
    
    @ObservedObject var mouse: Mouse
    let size: CGFloat
    
    init(_ mouse: Mouse, _ size: CGFloat) {
        self.mouse = mouse
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(self.mouseColor(mouse: mouse))
                .frame(width: self.size, height: self.size)
                .offset(x: CGFloat(mouse.position.x-250), y: CGFloat(mouse.position.y-250))
        }
    }
    
    
    func mouseColor(mouse: Mouse) -> Color {
        
        if mouse.dead {
            return .red
        }
        
        return .purple
    }
}

//struct MouseView_Previews: PreviewProvider {
//    static var previews: some View {
//        MouseView()
//    }
//}

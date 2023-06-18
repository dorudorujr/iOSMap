//
//  DraggableView.swift
//  iOSMap
//
//  Created by 杉岡成哉 on 2023/06/18.
//

import SwiftUI

struct DraggableView<Content: View>: View {
    @GestureState private var dragState = DragState.inactive
    @State var position = UIScreen.main.bounds.height * 0.7
    var content: () -> Content
    
    var body: some View {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation.height)
            }
            .onEnded(onDragEnded)
        
        GeometryReader { geometry in
            VStack {
                Handle()
                content()
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
            .background(Color.white)
            .cornerRadius(10)
            .offset(y: max(self.position + self.dragState.translation, 0))
            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0), value: dragState)
            .gesture(drag)
        }
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        let cardTopEdgeLocation = self.position + drag.translation.height
        let positionAbove: CGFloat
        let positionBelow: CGFloat
        let closestPosition: CGFloat
        
        positionAbove = UIScreen.main.bounds.height * 0.3
        positionBelow = UIScreen.main.bounds.height * 0.7
        
        if (cardTopEdgeLocation - positionAbove) < (positionBelow - cardTopEdgeLocation) {
            closestPosition = positionAbove
        } else {
            closestPosition = positionBelow
        }
        
        if verticalDirection > 0 {
            self.position = positionBelow
        } else {
            self.position = positionAbove
        }
    }
    
    enum DragState: Equatable {
        case inactive
        case dragging(translation: CGFloat)

        var translation: CGFloat {
            switch self {
            case .inactive:
                return 0
            case .dragging(let translation):
                return translation
            }
        }

        var isActive: Bool {
            switch self {
            case .inactive:
                return false
            case .dragging:
                return true
            }
        }
    }
}

struct Handle: View {
    var body: some View {
        Rectangle()
            .fill(Color.secondary)
            .frame(width: 60, height: 5)
            .cornerRadius(3.0)
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 4, trailing: 0))
    }
}

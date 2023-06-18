//
//  DraggableView.swift
//  iOSMap
//
//  Created by 杉岡成哉 on 2023/06/18.
//

import SwiftUI

struct DraggableView<Content: View>: View {
    @GestureState private var dragState = DragState.inactive
    @State private var position: CGFloat = 0
    @State private var currentPositionState: PositionState = .small(70)
    let minHeight: CGFloat
    var content: () -> Content
    
    var body: some View {
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
            .gesture(
                DragGesture()
                    // .updating: gestureの値が変更されると指定されたGestureStateの値を更新する
                    .updating(self.$dragState) { drag, state, transaction in
                        state = .dragging(translation: drag.translation.height)
                    }
                    // .onEnded: gestureが終わった時
                    .onEnded { drag in
                        // location: 現在のドラッグ位置
                        // predictedEndLocation: ドラッグが終了したと予測される位置
                        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
                        
                        // 上スワイプか下スワイプかどうか
                        if verticalDirection > 0 {
                            // 下スワイプ
                            switch self.currentPositionState {
                            case .large:
                                self.position = PositionState.medium.height(viewHeight: geometry.size.height)
                                self.currentPositionState = PositionState.medium
                            case .medium:
                                self.position = PositionState.small(minHeight).height(viewHeight: geometry.size.height)
                                self.currentPositionState = PositionState.small(minHeight)
                            case .small:
                                self.position = PositionState.small(minHeight).height(viewHeight: geometry.size.height)
                                self.currentPositionState = PositionState.small(minHeight)
                            }
                        } else {
                            // 上スワイプ
                            switch self.currentPositionState {
                            case .large:
                                self.position = PositionState.large.height(viewHeight: geometry.size.height)
                                self.currentPositionState = PositionState.large
                            case .medium:
                                self.position = PositionState.large.height(viewHeight: geometry.size.height)
                                self.currentPositionState = PositionState.large
                            case .small:
                                self.position = PositionState.medium.height(viewHeight: geometry.size.height)
                                self.currentPositionState = PositionState.medium
                            }
                        }
                    }
            )
            .onAppear {
                self.position = geometry.size.height - minHeight
            }
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
    }
    
    enum PositionState {
        case large
        case medium
        case small(CGFloat)
        
        func height(viewHeight: CGFloat) -> CGFloat {
            switch self {
            case .large:
                return 0
            case .medium:
                return viewHeight * 0.5
            case .small(let height):
                return viewHeight - height
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

import SwiftUI
import MapKit
import ComposableArchitecture

struct MapView: View {
    let store: StoreOf<MapCore>
    @ObservedObject var viewStore: ViewStore<MapCore.State, MapCore.Action>
    
    init(store: StoreOf<MapCore>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: { $0 }, action: { $0 }))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                UIMapView(viewStore: viewStore)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        viewStore.send(.onAppear)
                    }
                DraggableView(minHeight: geometry.safeAreaInsets.bottom + SearchBar.height + Handle.totalHeight) {
                    MenuView(store: self.store.scope(state: \.menu, action: MapCore.Action.menu))
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

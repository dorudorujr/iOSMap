
import SwiftUI
import MapKit
import ComposableArchitecture

struct ContentView: View {
    let store: StoreOf<MapCore>
    @ObservedObject var viewStore: ViewStore<MapCore.State, MapCore.Action>
    
    init(store: StoreOf<MapCore>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: { $0 }, action: { $0 }))
    }
    
    var body: some View {
        UIMapView(viewStore: viewStore)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                viewStore.send(.onAppear)
            }
    }
}

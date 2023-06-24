import ComposableArchitecture
import SwiftUI

struct MenuView: View {
    let store: StoreOf<MenuCore>
    @ObservedObject var viewStore: ViewStore<MenuCore.State, MenuCore.Action>
    
    init(store: StoreOf<MenuCore>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: { $0 }, action: { $0 }))
    }
    
    var body: some View {
        VStack {
            SearchBar(text: viewStore.binding(\.$searchText))
        }
    }
}

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
        UIMapView(viewStore: viewStore)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                viewStore.send(.onAppear)
            }
            .sheet(isPresented: .constant(true)) {
                MenuView()
                    .presentationDetents([.medium, .large, .height(70)])
                    .interactiveDismissDisabled(true)
                    .onAppear {
                        guard let windows = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                            return
                        }
                        
                        if let controller = windows.windows.first?.rootViewController?.presentedViewController,
                           let sheet = controller.presentationController as? UISheetPresentationController {
                            controller.presentingViewController?.view.tintAdjustmentMode = .normal
                            sheet.largestUndimmedDetentIdentifier = .large
                        } else {
                            print("NO CONTROLLER FOUND")
                        }
                    }
            }
    }
}

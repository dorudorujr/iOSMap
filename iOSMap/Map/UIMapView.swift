import SwiftUI
import MapKit

struct UIMapView: UIViewRepresentable {
    let mkMapView = MKMapView()
    func makeUIView(context: Context) -> MKMapView {
        return mkMapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.delegate = context.coordinator
    }
    
    func makeCoordinator() -> Coordinator {
        .init(view: mkMapView)
    }
}

extension UIMapView {
    class Coordinator: NSObject {
        var view: MKMapView
        
        init(view: MKMapView) {
            self.view = view
        }
    }
}

extension UIMapView.Coordinator: MKMapViewDelegate {
    
}

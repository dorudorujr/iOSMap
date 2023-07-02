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
        GeometryReader { geometry in
            VStack(spacing: 20) {
                SearchBar(text: viewStore.binding(\.$searchText))
                VStack {
                    VStack(spacing: .zero) {
                        HStack {
                            Text("よく使う項目")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fontWeight(.bold)
                            Spacer()
                            Text("さらに表示")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                VStack {
                                    Image(systemName: "house.fill")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 35, height: 35)
                                        .foregroundColor(.blue)
                                        .padding(12)
                                        .background(Circle().fill(Color(UIColor.systemGray5)))
                                    Text("自宅")
                                        .font(.subheadline)
                                    Text("追加")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .frame(width: geometry.size.width - 60)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                            .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 1)
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
}

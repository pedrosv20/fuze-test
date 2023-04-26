import ComposableArchitecture
import CSTVMatchesService
import SwiftUI

public struct MatchesListView: View {
    var store: StoreOf<MatchesList>
    
    public init(store: StoreOf<MatchesList>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            WithViewStore(store) { viewStore in
                
                List {
                    ForEach(viewStore.matchesData, id: \.id) { match in
                        matchView(match)
                            .onTapGesture {
                                viewStore.send(.matchselected(match.id))
                            }
                    }
                }
                .navigationDestination(
                    isPresented: viewStore.binding(
                        get: \.goToDetail,
                        send: { MatchesList.Action.shouldShowDetail($0) }
                    ),
                    destination: {
                        MatchDetailView(
                            store: .init(
                                initialState: .init(
                                    selectedMatch: viewStore.matchDetailSelected ?? ""),
                                reducer: MatchDetail()
                            )
                        ) 
                    }
                )
                .edgesIgnoringSafeArea(.all)
                .onAppear { viewStore.send(.onAppear) }
            }
        }
    }
    
    public func matchView(_ match: MatchesData) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .overlay {
            VStack {
                HStack {
                    if let opponents = match.opponents[safe: 0],
                       let opponent1 = opponents.opponent {
                        teamView(opponent1)
                    }
                    
                    
                    Text("VS")
                        .foregroundColor(.black)
                    
                    if let opponents = match.opponents[safe: 1],
                       let opponent1 = opponents.opponent {
                        teamView(opponent1)
                    }
                }
                .padding(.top, 16)

                Spacer()

                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.black)
                
                HStack {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.red)
                    Text(match.league.name)
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding([.bottom, .leading], 8)
            }
        }
            .frame(height: UIScreen.main.bounds.width * 0.5)
            .foregroundColor(Color.green)
    }
    
    func teamView(_ opponent: MatchesData.Opponent) -> some View {
        VStack(spacing: .zero) {
            Circle()
                .foregroundColor(.red)
            Text(opponent.name)
                .foregroundColor(.black)
        }
        .padding(.vertical)
    }
}

struct MatchesListView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesListView.init(store: .init(initialState: .init(matchesData: [.fixture()]), reducer: MatchesList()))
    }
}

// TODO: -  add design system to spacing and round corners and colors

// TODO: - adicionar em outro lugar
extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

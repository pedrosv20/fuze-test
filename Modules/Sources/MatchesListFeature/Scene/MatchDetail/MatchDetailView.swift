import ComposableArchitecture
import CSTVMatchesService
import SwiftUI

public struct MatchDetailView: View {
    var store: StoreOf<MatchDetail>
    
    public init(store: StoreOf<MatchDetail>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            if let matchesData = viewStore.matchesData {
                matchView(matchesData)
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
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

struct MatchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MatchDetailView.init(store: .init(initialState: .init(selectedMatch: "", matchesData: .fixture()), reducer: MatchDetail()))
    }
}

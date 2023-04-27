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
            if
                let matchData = viewStore.matchData,
                let playersTeam1 = viewStore.playersTeam1,
                let playersTeam2 = viewStore.playersTeam2 {
                VStack {
                    // TODO: - Get serie name
                    matchView(matchData, playersTeam1, playersTeam2)
                }
                .navigationTitle(matchData.league.name)
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .onAppear { viewStore.send(.onAppear) }
                    .navigationTitle("")
            }
        }
        
    }
    
    public func matchView(_ match: MatchesData, _ playersTeam1: [Players], _ playersTeam2: [Players]) -> some View {
            VStack {
                HStack {
                    if let opponents = match.opponents[safe: 0],
                       let opponent1 = opponents.opponent {
                        teamView(opponent1)
                    }
                    
                    
                    Text("VS")
                        .foregroundColor(.black)
                    
                    if let opponents = match.opponents[safe: 1],
                       let opponent2 = opponents.opponent {
                        teamView(opponent2)
                    }
                }
                .padding(.top, 16)

                Text("Hoje as 21") // TODO: -  get hour
                
                // PlayersView
                HStack {
                    playersView(playersTeam1, alignment: .leading)
                    playersView(playersTeam2, alignment: .trailing)
                }
            }
            .foregroundColor(Color.green)
    }

    func teamView(_ opponent: MatchesData.Opponent) -> some View {
        VStack(spacing: .zero) {
            Circle()
                .foregroundColor(.red)
                .padding(26)
            Text(opponent.name)
                .foregroundColor(.black)
        }
        .padding(.vertical)
    }

    func playersView(_ players: [Players], alignment: HorizontalAlignment) -> some View {
        VStack(spacing: 16) {
            ForEach(players, id: \.name) { player in
                Rectangle()
                    .roundedCorner(8, corners: alignment == .leading ? [.bottomRight, .topRight] : [.bottomLeft, .topLeft])
                    .foregroundColor(.red)
                    .overlay {
                        HStack {
                            VStack(alignment: .trailing) {
                                Text(player.name)
                                Text("nome completo"/*"\(player.firstName) \(player.lastName)"*/)
                            }
                            .frame(alignment: .trailing)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 60, height: 60)
                                .foregroundColor(.blue)
                                .offset(x: -5, y: -7)
                        }
                        .environment(\.layoutDirection, alignment == .leading ? .leftToRight : .rightToLeft)
                        
                    }
            }
        }
        .padding(.vertical)
    }
}

//struct MatchDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MatchDetailView.init(store: .init(initialState: .init(selectedMatch: "", matchData: .fixture()), reducer: MatchDetail()))
//    }
//}


struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

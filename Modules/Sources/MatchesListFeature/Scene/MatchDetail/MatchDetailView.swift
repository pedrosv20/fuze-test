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
            ZStack {
                Color(hex: "161621")
                    .ignoresSafeArea()
                if
                    let matchData = viewStore.matchData,
                    let playersTeam1 = viewStore.playersTeam1,
                    let playersTeam2 = viewStore.playersTeam2 {
                    VStack {
                        matchView(matchData, playersTeam1, playersTeam2)
                    }
                    .navigationTitle(matchData.league.name)
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(Visibility.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
                    
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .onAppear { viewStore.send(.onAppear) }
                        .navigationTitle("")
                }
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
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                    
                    if let opponents = match.opponents[safe: 1],
                       let opponent2 = opponents.opponent {
                        teamView(opponent2)
                    }
                }
                .padding(.top, 16)

                Text("Hoje, 21:00")
                    .font(.system(size: 12))
                    .foregroundColor(.white)// TODO: -  get hour
                
                // PlayersView
                HStack {
                    playersView(playersTeam1, alignment: .leading)
                    playersView(playersTeam2, alignment: .trailing)
                }
            }
    }

    func teamView(_ opponent: MatchesData.Opponent) -> some View {
        VStack(spacing: .zero) {
            Circle()
                .foregroundColor(.clear)
                .padding(26)
                .overlay {
                    AsyncImage(url: URL(string: opponent.imageURL ?? "")) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(26)
                    } placeholder: {
                        if let imageURL = opponent.imageURL,
                           let _ = URL(string: imageURL) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Circle().foregroundColor(.gray)
                        }
                         
                    }
                }
            Text(opponent.name)
                .foregroundColor(.white)
                .font(.system(size: 10))
        }
        .padding(.vertical)
    }

    func playersView(_ players: [Players], alignment: HorizontalAlignment) -> some View {
        VStack(spacing: 16) {
            ForEach(players, id: \.name) { player in
                Rectangle()
                    .roundedCorner(8, corners: alignment == .leading ? [.bottomRight, .topRight] : [.bottomLeft, .topLeft])
                    .foregroundColor(Color(hex: "272639"))
                    .overlay {
                        HStack(spacing: 12) {
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(player.name)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                Text("\(player.firstName) \(player.lastName)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                            }
                            .frame(alignment: .trailing)
                            
                            AsyncImage(url: player.imageURL) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                            } placeholder: {
                                if player.imageURL != nil {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    RoundedRectangle(cornerRadius: 8)
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.gray)
                                }
                                
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 8))
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

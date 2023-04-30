import ComposableArchitecture
import CSTVMatchesService
import DesignSystem
import SharedExtensions
import SwiftUI

public struct MatchDetailView: View {
    var store: StoreOf<MatchDetail>
    
    public init(store: StoreOf<MatchDetail>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                DS.Colors.mainBackground
                    .ignoresSafeArea()
                if
                    let playersTeam1 = viewStore.playersTeam1,
                    let playersTeam2 = viewStore.playersTeam2 {
                    VStack {
                        matchView(viewStore.matchData, playersTeam1, playersTeam2)
                    }
                    .navigationTitle(viewStore.matchData.league.name)
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
                if let opponents = match.opponents[safe: 0] {
                    teamView(opponents.opponent)
                }
                
                
                Text("VS")
                    .setCustomFontTo(.regular(size: DS.FontSize.small12))
                    .foregroundColor(DS.Colors.white.opacity(0.20)) // DS opacity
                
                if let opponents = match.opponents[safe: 1] {
                    teamView(opponents.opponent)
                }
            }
            .padding(.top, DS.Spacing.m)
            
            if match.status == .running {
                VStack {
                    RoundedRectangle(cornerRadius: DS.CornerRadius.xs)
                        .foregroundColor( Color.red)
                        .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.12)
                        .overlay {
                            Text("Live")
                                .setCustomFontTo(.bold(size: DS.FontSize.small12))
                                .foregroundColor(DS.Colors.white)
                        }
                    
                    Text("Hoje \(match.beginAt.formatted(date: .omitted, time: .shortened))")
                        .setCustomFontTo(.bold(size: DS.FontSize.small12))
                        .foregroundColor(DS.Colors.white)
                }
                
            } else {
                Text(match.beginAt.formatted(date: .abbreviated, time: .shortened))
                    .setCustomFontTo(.bold(size: DS.FontSize.small12))
                    .foregroundColor(DS.Colors.white)
            }
            
            
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
                .padding(DS.Spacing.xl)
                .overlay {
                    AsyncImage(url: URL(string: opponent.imageURL ?? "")) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(DS.Spacing.l)
                    } placeholder: {
                        if let imageURL = opponent.imageURL,
                           let _ = URL(string: imageURL) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Circle().foregroundColor(DS.Colors.placeholder)
                        }
                    }
                }

            Text(opponent.name)
                .setCustomFontTo(.bold(size: DS.FontSize.small12))
                .foregroundColor(DS.Colors.white)
        }
        .padding(.vertical)
    }
    
    func playersView(_ players: [Players], alignment: HorizontalAlignment) -> some View {
        VStack(spacing: DS.Spacing.m) {
            ForEach(0..<5) { value in
                if let player = players[safe: value] {
                    Rectangle()
                        .roundedCorner(DS.CornerRadius.xs, corners: alignment == .leading ? [.bottomRight, .topRight] : [.bottomLeft, .topLeft])
                        .foregroundColor(DS.Colors.rowBackground)
                        .overlay {
                            HStack(spacing: DS.Spacing.s) {
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(player.name)
                                        .setCustomFontTo(.bold(size: DS.FontSize.medium))
                                        .foregroundColor(DS.Colors.white)
                                        .minimumScaleFactor(0.4)
                                        .lineLimit(1)
                                    if let firstName = player.firstName, let lastName = player.lastName {
                                        Text("\(firstName) \(lastName)")
                                            .setCustomFontTo(.regular(size: DS.FontSize.small12))
                                            .foregroundColor(DS.Colors.white)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.3)
                                    }
                                }
                                .frame(alignment: .trailing)
                                
                                AsyncImage(url: player.imageURL) { image in
                                    image
                                        .resizable()
                                        .frame(minWidth: 30, maxWidth: 60, minHeight: 30, maxHeight: 60)
                                } placeholder: {
                                    if player.imageURL != nil {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        RoundedRectangle(cornerRadius: DS.CornerRadius.xs)
                                            .frame(minWidth: 30, maxWidth: 60, minHeight: 30, maxHeight: 60)
                                            .foregroundColor(DS.Colors.placeholder)
                                    }
                                    
                                }
                                .clipShape(RoundedRectangle(cornerRadius: DS.CornerRadius.xs))
                                .offset(x: -5, y: -7)
                            }
                            .environment(\.layoutDirection, alignment == .leading ? .leftToRight : .rightToLeft)
                        }
                } else {
                    Rectangle()
                        .roundedCorner(DS.CornerRadius.xs, corners: alignment == .leading ? [.bottomRight, .topRight] : [.bottomLeft, .topLeft])
                        .foregroundColor(DS.Colors.rowBackground)
                        .overlay {
                            HStack(spacing: DS.Spacing.s) {
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("")
                                    Text("")
                                    
                                }
                                .frame(alignment: .trailing)
                                
                                RoundedRectangle(cornerRadius: DS.CornerRadius.xs)
                                    .frame(minWidth: 30, maxWidth: 60, minHeight: 30, maxHeight: 60)
                                    .foregroundColor(DS.Colors.placeholder)
                                    .offset(x: -5, y: -7)
                            }
                            .environment(\.layoutDirection, alignment == .leading ? .leftToRight : .rightToLeft)
                            
                        }
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

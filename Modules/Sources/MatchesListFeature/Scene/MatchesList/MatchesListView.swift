import ComposableArchitecture
import CSTVMatchesService
import DesignSystem
import SwiftUI

public struct MatchesListView: View {
    var store: StoreOf<MatchesList>
    
    public init(store: StoreOf<MatchesList>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            WithViewStore(store) { viewStore in
                ZStack {
                    DS.Colors.mainBackground
                        .ignoresSafeArea()
                    
                    
                    if viewStore.state.matchesData.isEmpty {
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .onAppear { viewStore.send(.onAppear) }
                            .background(DS.Colors.mainBackground)
                            .edgesIgnoringSafeArea(.all)
                    } else {
                        List {
                            ForEach(viewStore.matchesData, id: \.id) { match in
                                if let _ = match.opponents[safe: 0],
                                   let _ = match.opponents[safe: 1]
                                {
                                    matchView(match)
                                        .edgesIgnoringSafeArea(.horizontal)
                                        .listRowBackground(DS.Colors.mainBackground)
                                        .listRowSeparator(.hidden)
                                        .onTapGesture {
                                            viewStore.send(.matchselected(match.id))
                                        }
                                }
                                
                            }
                            
                            if viewStore.finishDownloading == false {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .onAppear {
                                            viewStore.send(.requestData)
                                        }
                                        .listRowBackground(DS.Colors.mainBackground)
                                    Spacer()
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(DS.Colors.mainBackground)
                                .background(DS.Colors.mainBackground)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                .refreshable {
                    viewStore.send(.refresh)
                }
                .background(Color.blue)
                .edgesIgnoringSafeArea([.bottom, .horizontal])
                .scrollContentBackground(.hidden)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(
                    DS.Colors.mainBackground ?? Color.black,
                    for: .navigationBar
                )
                .navigationTitle(viewStore.matchesData.isEmpty ? "" : "Partidas")
                .toolbarColorScheme(.dark, for: .navigationBar)
                .navigationDestination(
                    isPresented: viewStore.binding(
                        get: \.goToDetail,
                        send: { MatchesList.Action.shouldShowDetail($0) }
                    ),
                    destination: {
                        if let matchDetail = viewStore.matchDetailSelected {
                            MatchDetailView(
                                store: .init(
                                    initialState: .init(
                                        matchData: matchDetail
                                    ),
                                    reducer: MatchDetail()
                                )
                            )
                        }
                    }
                )
            }
        }
    }
    
    public func matchView(_ match: MatchesData) -> some View {
        RoundedRectangle(cornerRadius: DS.CornerRadius.m)
            .overlay {
                VStack {
                    HStack(alignment: .center, spacing: .zero) {
                        Spacer()
                        if let opponents = match.opponents[safe: 0] {
                            teamView(opponents.opponent)
                        }
                        
                        Text("VS")
                            .setCustomFontTo(.regular(size: DS.FontSize.small12))
                            .foregroundColor(DS.Colors.white.opacity(0.20)) // TODO: - DS opacity
                        
                        if let opponents = match.opponents[safe: 1] {
                            teamView(opponents.opponent)
                        }
                        Spacer()
                    }
                    .padding(.top, DS.Spacing.m)
                    
                    Spacer()
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(DS.Colors.white.opacity(0.20))
                    
                    HStack {
                        Circle()
                            .frame(width: 20, height: 20)
                            .overlay {
                                AsyncImage(url: URL(string: match.league.imageURL ?? "")) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    if let imageURL = match.league.imageURL,
                                       let _ = URL(string: imageURL) {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        Circle().foregroundColor(DS.Colors.placeholder)
                                    }
                                    
                                }
                            }
                        Text("\(match.league.name) \(match.serie.fullName)")
                            .setCustomFontTo(.regular(size: DS.FontSize.small10))
                            .foregroundColor(DS.Colors.white)
                        
                        Spacer()
                    }
                    .padding([.bottom, .leading], DS.Spacing.xs)
                }
            }
            .overlay(alignment: .topTrailing) {
                if match.status == .running {
                    Rectangle()
                        .foregroundColor( Color.red)
                        .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.06)
                        .roundedCorner(DS.CornerRadius.m, corners: [.bottomLeft, .topRight] )
                        .overlay {
                            Text("AGORA")
                                .setCustomFontTo(.bold(size: DS.FontSize.small10))
                                .foregroundColor(DS.Colors.white)
                                .minimumScaleFactor(0.5)
                        }
                } else {
                    Rectangle()
                        .foregroundColor(DS.Colors.timeRectangle?.opacity(0.2))
                        .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.width * 0.06)
                        .roundedCorner(DS.CornerRadius.m, corners: [.bottomLeft, .topRight] )
                        .overlay {
                            Text(
                                match.beginAt.formatted(
                                    date: .abbreviated,
                                    time: .shortened
                                )
                            )
                            .setCustomFontTo(.bold(size: DS.FontSize.small10))
                            .foregroundColor(DS.Colors.white)
//                            .minimumScaleFactor(0.8)
                        }
                }
            }
            .frame(height: UIScreen.main.bounds.width * 0.45)
            .foregroundColor(DS.Colors.rowBackground)
    }
    
    func teamView(_ opponent: MatchesData.Opponent) -> some View {
        VStack(spacing: DS.Spacing.xxs) {
            Circle()
                .frame(width: 60, height: 60)

                .overlay {
                    AsyncImage(url: URL(string: opponent.imageURL ?? "")) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
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
            
            
            HStack {
                Spacer()
                Text(opponent.name)
                    .setCustomFontTo(.bold(size: DS.FontSize.small12))
                    .foregroundColor(DS.Colors.white)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .minimumScaleFactor(0.5)
                Spacer()
            }
            .padding(.top, DS.Spacing.xs)
            
        }
        .padding(.vertical)
    }
}

struct MatchesListView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesListView.init(store: .init(initialState: .init(matchesData: [.fixture()]), reducer: MatchesList()))
    }
}

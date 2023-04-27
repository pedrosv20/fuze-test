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
            ZStack {
                Color(hex: "161621")
                    .ignoresSafeArea()
                
                WithViewStore(store) { viewStore in
                    if viewStore.state.matchesData.isEmpty {
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .onAppear { viewStore.send(.onAppear) }
                            .background(Color(hex: "161621"))
                            .edgesIgnoringSafeArea(.all)
                    } else {
                        List {
                            ForEach(viewStore.matchesData, id: \.id) { match in
                                if let _ = match.opponents[safe: 0],
                                   let _ = match.opponents[safe: 1]
                                {
                                    matchView(match)
                                        .listRowBackground(Color(hex: "161621"))
                                        .onTapGesture {
                                            viewStore.send(.matchselected(match.id))
                                        }
                                }
                                
                            }
                            
                            if viewStore.finishDownloading == false {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .onAppear {
                                            viewStore.send(.requestData)
                                        }
                                        .listRowBackground(Color(hex: "161621"))
                                    Spacer()
                                }
                                .background(Color.clear)
                                
                            }
                        }
                        .refreshable {
                            viewStore.send(.refresh)
                        }
                        .background(Color(hex: "161621"))
                        .edgesIgnoringSafeArea([.bottom, .horizontal])
                        .scrollContentBackground(.hidden)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .toolbarBackground(
                            Color(hex: "161621") ?? Color.black,
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
        }
    }
    
    public func matchView(_ match: MatchesData) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .overlay {
                VStack {
                    HStack(alignment: .center, spacing: .zero) {
                        Spacer()
                        if let opponents = match.opponents[safe: 0] {
                            teamView(opponents.opponent)
                        }
                        
                        Text("VS")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                        
                        if let opponents = match.opponents[safe: 1] {
                            teamView(opponents.opponent)
                        }
                        Spacer()
                    }
                    .padding(.top, 16)
                    
                    Spacer()
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.black)
                    
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
                                        Circle().foregroundColor(.gray)
                                    }
                                    
                                }
                            }
                        Text("\(match.league.name) \(match.serie.fullName)")
                            .foregroundColor(.white)
                            .font(.system(size: 8))
                        
                        Spacer()
                    }
                    .padding([.bottom, .leading], 8)
                }
            }
            .overlay(alignment: .topTrailing) {
                if match.status == .running {
                    Rectangle()
                        .foregroundColor( Color.red)
                        .frame(width: UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.width * 0.05)
                        .roundedCorner(8, corners: [.bottomLeft, .topRight] )
                        .overlay {
                            Text("Agora")
                                .foregroundColor(.white)
                                .padding()
                                .minimumScaleFactor(0.5)
                        }
                } else {
                    Rectangle()
                        .foregroundColor(Color(hex: "FAFAFA")?.opacity(0.2))
                        .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.06)
                        .roundedCorner(8, corners: [.bottomLeft, .topRight] )
                        .overlay {
                            Text(
                                match.beginAt.formatted(
                                    date: .abbreviated,
                                    time: .shortened
                                )
                            )
                            .foregroundColor(.white)
                            .padding()
                            .minimumScaleFactor(0.5)
                        }
                }
            }
            .frame(height: UIScreen.main.bounds.width * 0.5)
            .foregroundColor(Color(hex: "272639"))
    }
    
    func teamView(_ opponent: MatchesData.Opponent) -> some View {
        VStack(spacing: 4) {
            Circle()
                .padding()
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
                            Circle().foregroundColor(.gray)
                        }
                        
                    }
                }
            
            
            HStack {
                Spacer()
                Text(opponent.name)
                    .foregroundColor(.white)
                    .font(Font.headline.weight(.bold))
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .minimumScaleFactor(0.2)
                Spacer()
            }
            
        }
        .padding(.vertical)
    }
}

struct MatchesListView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesListView.init(store: .init(initialState: .init(matchesData: [.fixture()]), reducer: MatchesList()))
    }
}

// TODO: -  Create design system to spacing and round corners and colors

// TODO: - Common Extension Modules
extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

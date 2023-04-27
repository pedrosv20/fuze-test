import Combine
import SwiftUI
import CSTVMatchesServiceLive
import CSTVMatchesService
import MatchesListFeature

public class Teste {
    var cancellables: Set<AnyCancellable> = []
    public init() {}
}
struct ContentView: View {
    var teste: Teste = .init()
    var body: some View {
        MatchesListView(store: .init(initialState: .init(matchesData: []), reducer: MatchesList()))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

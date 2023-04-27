import Combine
import SwiftUI
import MatchesListFeature

struct ContentView: View {
    var body: some View {
        MatchesListView(store: .init(initialState: .init(matchesData: []), reducer: MatchesList()))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

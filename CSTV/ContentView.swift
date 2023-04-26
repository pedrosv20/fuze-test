import Combine
import SwiftUI
import CSGOMatchesServiceLive
import CSGOMatchesService

public class Teste {
    var cancellables: Set<AnyCancellable> = []
    public init() {}
}
struct ContentView: View {
    var teste: Teste = .init()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .onAppear {
            CSTVMatchesService.live.getMatchesList().sink(receiveCompletion: { _ in }, receiveValue: { response in
                print(response.map { $0.name })
            })
            .store(in: &teste.cancellables)
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

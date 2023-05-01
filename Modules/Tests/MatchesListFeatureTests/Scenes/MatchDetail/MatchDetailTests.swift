import Combine
import ComposableArchitecture
import Foundation
import XCTest
import CSTVMatchesService
@testable import MatchesListFeature

public final class MatchDetailTests: XCTestCase {
    func test_onAppear_shouldDownloadPlayersLists() {
        // Given
        let testScheduler = DispatchQueue.test
        let store = TestStore(
            initialState: MatchDetail.State(matchData: .fixture(opponents: [
                .fixture(opponent: .fixture(id: "123")),
                .fixture(opponent: .fixture(id: "321"))
            ])),
            reducer: MatchDetail()
        ) {
            $0.mainQueue = testScheduler.eraseToAnyScheduler()
            $0.cstvMatchesService = .mock()
        }

        let model1ToBeReturend: [Players] = [.fixture()]
        let model2ToBeReturned: [Players] = [.fixture()]

        CSTVMatchesService.getPlayersResponseToBeReturned = Just(model1ToBeReturend)
            .setFailureType(to: CommonErrors.self)
            .eraseToAnyPublisher()

        // When
        store.send(.onAppear)
        testScheduler.advance()

        // Then
        store.receive(.init(.requestDataTeam1))
        store.receive(.init(.requestDataTeam2))

        store.receive(.init(.handleRequestedDataTeam1(.success(model1ToBeReturend)))) {
            $0.playersTeam1 = model1ToBeReturend
        }


        store.receive(.init(.handleRequestedDataTeam2(.success(model2ToBeReturned)))) {
            $0.playersTeam2 = model2ToBeReturned
        }
    }

    func test_onAppear_whenAPIReturnsError_retryShouldDownloadPlayersLists() {
        // Given
        let testScheduler = DispatchQueue.test
        let store = TestStore(
            initialState: MatchDetail.State(matchData: .fixture(
                opponents: [
                    .fixture(opponent: .fixture(id: "123")),
                    .fixture(opponent: .fixture(id: "321"))
                ])
            ),
            reducer: MatchDetail()
        ) {
            $0.mainQueue = testScheduler.eraseToAnyScheduler()
            $0.cstvMatchesService = .mock()
        }

        let modelToBeReturned: [Players] = [.fixture()]

        CSTVMatchesService.getPlayersResponseToBeReturned = Fail(error: .text("api returned error"))
            .eraseToAnyPublisher()

        // When
        store.send(.onAppear)
        testScheduler.advance()

        store.receive(.init(.requestDataTeam1))
        store.receive(.init(.requestDataTeam2))

        store.receive(.init(.handleRequestedDataTeam1(.failure(.text("api returned error"))))) {
            $0.error = .text("api returned error")
        }

        store.receive(.init(.handleRequestedDataTeam2(.failure(.text("api returned error")))))

        // Then
        CSTVMatchesService.getPlayersResponseToBeReturned = Just(modelToBeReturned)
            .setFailureType(to: CommonErrors.self)
            .eraseToAnyPublisher()

        store.send(.refresh) {
            $0.error = nil
            $0.playersTeam1 = nil
            $0.playersTeam2 = nil
        }

        testScheduler.advance()
        store.receive(.init(.onAppear))
        
        store.receive(.init(.requestDataTeam1))
        store.receive(.init(.requestDataTeam2))

        store.receive(.init(.handleRequestedDataTeam1(.success(modelToBeReturned)))) {
            $0.playersTeam1 = modelToBeReturned
        }
        
        store.receive(.init(.handleRequestedDataTeam2(.success(modelToBeReturned)))) {
            $0.playersTeam2 = modelToBeReturned
        }
        
    }
}

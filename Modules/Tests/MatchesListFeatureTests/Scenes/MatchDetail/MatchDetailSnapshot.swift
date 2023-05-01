import Foundation
import ComposableArchitecture
import MatchesListFeature
import SnapshotTesting
import CSTVMatchesService
import XCTest
import SwiftUI

public final class MatchDetailSnapshot: XCTestCase {
    func test_matchDetail_with5players() {
        assertSnapshot(
            matching: UIHostingController(rootView: MatchDetailView(
                store: .init(
                    initialState: .init(
                        matchData: .fixture(),
                        playersTeam1: [
                            .fixture(),
                            .fixture(),
                            .fixture(),
                            .fixture(),
                            .fixture()
                        ],
                        playersTeam2: [
                            .fixture(),
                            .fixture(),
                            .fixture(),
                            .fixture(),
                            .fixture()
                        ],
                        error: nil
                    ),
                    reducer: MatchDetail()
                )
            )),
            as: .image(on: .iPhone13)
        )
    }
    
    func test_matchDetail_withLessThan5players() {
        assertSnapshot(
            matching: UIHostingController(rootView: MatchDetailView(
                store: .init(
                    initialState: .init(
                        matchData: .fixture(),
                        playersTeam1: [
                            .fixture(),
                            .fixture()
                        ],
                        playersTeam2: [
                            .fixture(),
                            .fixture(),
                            .fixture(),
                            .fixture()
                        ],
                        error: nil
                    ),
                    reducer: MatchDetail()
                )
            )),
            as: .image(on: .iPhone13)
        )
    }
    
    func test_matchDetail_withMoreThan5players() {
        assertSnapshot(
            matching: UIHostingController(rootView: MatchDetailView(
                store: .init(
                    initialState: .init(
                        matchData: .fixture(),
                        playersTeam1: [
                            .fixture(),
                            .fixture(),
                            .fixture(),
                            .fixture(),
                            .fixture(),
                            .fixture()
                        ],
                        playersTeam2: [
                            .fixture(),
                            .fixture(),
                            .fixture(),
                            .fixture(),
                            .fixture(),
                            .fixture()
                        ],
                        error: nil
                    ),
                    reducer: MatchDetail()
                )
            )),
            as: .image(on: .iPhone13)
        )
    }
    
    func test_matchDetail_withError() {
        assertSnapshot(
            matching: UIHostingController(rootView: MatchDetailView(
                store: .init(
                    initialState: .init(
                        matchData: .fixture(),
                        error: CommonErrors.text("snapshot test error")
                    ),
                    reducer: MatchDetail()
                )
            )),
            as: .image(on: .iPhone13)
        )
    }

}

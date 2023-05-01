import Foundation
import ComposableArchitecture
import MatchesListFeature
import SnapshotTesting
import CSTVMatchesService
import XCTest
import SwiftUI

public final class MatchesListSnapshot: XCTestCase {
    func test_matchesList_withMatches() {
        assertSnapshot(
            matching: UIHostingController(rootView: MatchesListView(
                store: .init(
                    initialState: .init(
                        matchesData: [
                            .fixture(),
                            .fixture(),
                            .fixture(),
                            .fixture(),
                            .fixture(),
                            .fixture()
                        ]
                    ),
                    reducer: MatchesList()
                )
            )),
            as: .image(on: .iPhone13)
        )
    }
    
    func test_matchesList_withError() {
        assertSnapshot(
            matching: UIHostingController(rootView: MatchesListView(
                store: .init(
                    initialState: .init(
                        matchesData: [],
                        error: CommonErrors.text("snapshot test error")
                    ),
                    reducer: MatchesList()
                )
            )),
            as: .image(on: .iPhone13)
        )
    }

}

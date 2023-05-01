import Combine
import ComposableArchitecture
import Foundation
import XCTest
import CSTVMatchesService
@testable import MatchesListFeature

public final class MatchesListTests: XCTestCase {
    func test_requestData_whenAPIReturnsEmptyArray_shouldReturnNewDataAndFinishDownloading() {
        // Given
        let testScheduler = DispatchQueue.test
        let store = TestStore(
            initialState: MatchesList.State(
                matchesData: []),
            reducer: MatchesList()
        ) {
            $0.mainQueue = testScheduler.eraseToAnyScheduler()
            $0.cstvMatchesService = .mock()
        }
        let modelToBeReturend: [MatchesData] = []
        CSTVMatchesService.getMatchesListResponseToBeReturned = Just(modelToBeReturend)
            .setFailureType(to: CommonErrors.self)
            .eraseToAnyPublisher()

        // When
        store.send(.onAppear)
        testScheduler.advance()
        
        // Then
        store.receive(.requestData) {
            $0.currentPage = 1
        }
        store.receive(.handleRequestedData(.success([]))) {
            $0.matchesData = []
            $0.finishDownloading = true
        }
    }
    
    func test_requestData_whenAPIReturnsData_andApiHasOnlyOnePage_shouldSetNewData() {
        // Given
        let testScheduler = DispatchQueue.test
        let store = TestStore(
            initialState: MatchesList.State(
                matchesData: []),
            reducer: MatchesList()
        ) {
            $0.mainQueue = testScheduler.eraseToAnyScheduler()
            $0.cstvMatchesService = .mock()
        }

        let modelToBeReturend: [MatchesData] = [
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture()
        ]

        CSTVMatchesService.getMatchesListResponseToBeReturned = Just(modelToBeReturend)
            .setFailureType(to: CommonErrors.self)
            .eraseToAnyPublisher()

        // When
        store.send(.onAppear)
        testScheduler.advance()
        
        // Then
        store.receive(.requestData) {
            $0.currentPage = 1
        }
        store.receive(.handleRequestedData(.success(modelToBeReturend))) {
            $0.matchesData = modelToBeReturend
            $0.finishDownloading = true
        }
    }
    
    func test_requestData_whenAPIReturnsData_andApiHasMoreThanOnePage_shouldSetNewData() {
        // Given
        let testScheduler = DispatchQueue.test
        let store = TestStore(
            initialState: MatchesList.State(
                matchesData: []),
            reducer: MatchesList()
        ) {
            $0.mainQueue = testScheduler.eraseToAnyScheduler()
            $0.cstvMatchesService = .mock()
        }

        let firstModelToBeReturned: [MatchesData] = [
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture()
        ]

        CSTVMatchesService.getMatchesListResponseToBeReturned = Just(firstModelToBeReturned)
            .setFailureType(to: CommonErrors.self)
            .eraseToAnyPublisher()

        // When
        store.send(.onAppear)
        testScheduler.advance()
        
        // Then
        store.receive(.requestData) {
            $0.currentPage = 1
        }
        store.receive(.handleRequestedData(.success(firstModelToBeReturned))) {
            $0.matchesData = firstModelToBeReturned
            $0.finishDownloading = false
        }
        
        let secondModelToBeReturned: [MatchesData] = [
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
        ]
        
        CSTVMatchesService.getMatchesListResponseToBeReturned = Just(secondModelToBeReturned)
            .setFailureType(to: CommonErrors.self)
            .eraseToAnyPublisher()
        
        store.send(.requestData) {
            $0.currentPage = 2
        }
        testScheduler.advance()
        
        store.receive(.handleRequestedData(.success(secondModelToBeReturned))) {
            $0.matchesData = firstModelToBeReturned + secondModelToBeReturned
            $0.finishDownloading = true
        }
    }
    
    func test_requestData_whenAPIReturnsError_errorShouldNotBeNil() {
        // Given
        let testScheduler = DispatchQueue.test
        let store = TestStore(
            initialState: MatchesList.State(
                matchesData: []),
            reducer: MatchesList()
        ) {
            $0.mainQueue = testScheduler.eraseToAnyScheduler()
            $0.cstvMatchesService = .mock()
        }
        let errorToBeReturned = CommonErrors.text("Request Failed")
        CSTVMatchesService.getMatchesListResponseToBeReturned = Fail(error: errorToBeReturned)
            .eraseToAnyPublisher()

        // When
        store.send(.onAppear)
        testScheduler.advance()
        
        // Then
        store.receive(.requestData) {
            $0.currentPage = 1
        }
        store.receive(.handleRequestedData(.failure(errorToBeReturned))) {
            $0.error = errorToBeReturned
        }
    }
    
    func test_requestData_whenAPIReturnsErrorAndRefresh_errorShouldBeNil() {
        // Given
        let testScheduler = DispatchQueue.test
        let store = TestStore(
            initialState: MatchesList.State(
                matchesData: []),
            reducer: MatchesList()
        ) {
            $0.mainQueue = testScheduler.eraseToAnyScheduler()
            $0.cstvMatchesService = .mock()
        }
        let errorToBeReturned = CommonErrors.text("Request Failed")
        CSTVMatchesService.getMatchesListResponseToBeReturned = Fail(error: errorToBeReturned)
            .eraseToAnyPublisher()

        // When
        store.send(.onAppear)
        testScheduler.advance()
        
        // Then
        store.receive(.requestData) {
            $0.currentPage = 1
        }
        store.receive(.handleRequestedData(.failure(errorToBeReturned))) {
            $0.error = errorToBeReturned
        }
        
        let modelToBeReturned: [MatchesData] = [.fixture()]
        CSTVMatchesService.getMatchesListResponseToBeReturned = Just(modelToBeReturned)
            .setFailureType(to: CommonErrors.self)
            .eraseToAnyPublisher()

        store.send(.refresh) {
            $0.error = nil
            $0.currentPage = 0
            $0.shouldResetData = true
        }
        testScheduler.advance()
        
        store.receive(.requestData) {
            $0.currentPage = 1
        }
        store.receive(.handleRequestedData(.success(modelToBeReturned))) {
            $0.error = nil
            $0.shouldResetData = false
            $0.matchesData = modelToBeReturned
            $0.finishDownloading = true
        }
    }
    
    func test_matchSelected_whenIDisInModel_itShouldShowDetail() {
        // Given
        let matchIDToBeSelected: String = "matchTestID"
        let modelToBeSelected: MatchesData = .fixture(id: matchIDToBeSelected)
        let testScheduler = DispatchQueue.test
        let store = TestStore(
            initialState: MatchesList.State(
                matchesData: [
                    modelToBeSelected,
                    .fixture(),
                    .fixture()
                ]
            ),
            reducer: MatchesList()
        ) {
            $0.mainQueue = testScheduler.eraseToAnyScheduler()
            $0.cstvMatchesService = .mock()
        }

        // When
        store.send(.matchSelected(matchIDToBeSelected)) {
            $0.matchDetailSelected = modelToBeSelected
        }
        testScheduler.advance()
        
        // Then
        store.receive(.shouldShowDetail(true)) {
            $0.goToDetail = true
        }
    }
    
    func test_matchSelected_whenIDisNotInModel_itShouldNotShowDetail() {
        // Given
        let matchIDToBeSelected: String = "matchTestID"
        let testScheduler = DispatchQueue.test
        let store = TestStore(
            initialState: MatchesList.State(
                matchesData: [
                    .fixture(),
                    .fixture(),
                    .fixture()
                ]
            ),
            reducer: MatchesList()
        ) {
            $0.mainQueue = testScheduler.eraseToAnyScheduler()
            $0.cstvMatchesService = .mock()
        }

        // When Then
        store.send(.matchSelected(matchIDToBeSelected))
    }
    
    func test_shouldShowDetailFalse_whenDetailIsShowing_itShouldHideDetail_andSetSelectedMatchToNil() {
        // Given
        let testScheduler = DispatchQueue.test
        let store = TestStore(
            initialState: MatchesList.State(
                matchesData: [
                    .fixture(),
                    .fixture(),
                    .fixture()
                ],
                goToDetail: true,
                matchDetailSelected: .fixture()
            ),
            reducer: MatchesList()
        ) {
            $0.mainQueue = testScheduler.eraseToAnyScheduler()
            $0.cstvMatchesService = .mock()
        }

        // When Then
        store.send(.shouldShowDetail(false)) {
            $0.goToDetail = false
            $0.matchDetailSelected = nil
        }
    }
}

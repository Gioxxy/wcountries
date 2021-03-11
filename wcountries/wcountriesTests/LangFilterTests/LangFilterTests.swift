//
//  LangFilterTests.swift
//  wcountriesTests
//
//  Created by Gionatan Cernusco on 11/03/21.
//

import XCTest
@testable import wcountries

class LangFilterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_getLanguages_shouldReturnData(){
        // Given
        let sut: LangFilterViewModel = LangFilterViewModel(LangFilterCoordinator(navigationController: SwipeBackNavigationController()), manager: TestableLangFilterManager(), selectedIso639_2: "ita")
        let expetaction = XCTestExpectation(description: "Expected to get languages")
        expetaction.expectedFulfillmentCount = 3
        
        // When
        sut.getLanguages(
            onStart: {
                expetaction.fulfill()
            },
            onCompletion: {
                expetaction.fulfill()
            },
            onSuccess: { model in
                expetaction.fulfill()
            },
            onError: { error in
                XCTFail()
            }
        )
        
        wait(for: [expetaction], timeout: 5.0)
        
        // Then
        XCTAssertGreaterThan(sut.languages.count, 0)
        XCTAssertEqual(sut.unselectedLanguages.count, sut.languages.count - sut.selectedLanguages.count)
        XCTAssertEqual(sut.selectedLanguages.count, 1)
        XCTAssertEqual(sut.selectedLanguages[0].name, "Italian")
        XCTAssertEqual(sut.selectedLanguages[0].iso639_2, "ita")
    }
    
    func test_onSearch_shouldUpdateListView(){
        // Given
        let sut: LangFilterViewModel = LangFilterViewModel(LangFilterCoordinator(navigationController: SwipeBackNavigationController()), manager: TestableLangFilterManager(), selectedIso639_2: nil)
        let expetaction = XCTestExpectation(description: "Expected to update list view")
        
        sut.updateListView = {
            expetaction.fulfill()
        }
        
        // When
        sut.onSearch(text: "Search text")
        
        wait(for: [expetaction], timeout: 5.0)
    }
    
    func test_onSearchEnd_shouldUpdateListView(){
        // Given
        let sut: LangFilterViewModel = LangFilterViewModel(LangFilterCoordinator(navigationController: SwipeBackNavigationController()), manager: TestableLangFilterManager(), selectedIso639_2: nil)
        let expetaction = XCTestExpectation(description: "Expected to update list view")
        
        sut.updateListView = {
            expetaction.fulfill()
        }
        
        // When
        sut.onSearchEnd()
        
        wait(for: [expetaction], timeout: 5.0)
    }
    
    func test_onLanguageSelected_shouldUpdateLanguages(){
        // Given
        let sut: LangFilterViewModel = LangFilterViewModel(LangFilterCoordinator(navigationController: SwipeBackNavigationController()), manager: TestableLangFilterManager(), selectedIso639_2: nil)
        let expetaction = XCTestExpectation(description: "Expected to update viewModel languages")
        
        // When
        sut.getLanguages(
            onSuccess: { viewModel in
                expetaction.fulfill()
            }
        )
        
        wait(for: [expetaction], timeout: 5.0)
        
        if let italian = sut.languages.first(where: { $0.iso639_2 == "ita" }) {
            sut.onLanguageSelected(viewModel: italian)
        } else {
           XCTFail()
        }
        
        // Then
        XCTAssertGreaterThan(sut.selectedLanguages.count, 0)
        XCTAssertEqual(sut.unselectedLanguages.count, sut.languages.count - sut.selectedLanguages.count)
        XCTAssertEqual(sut.languages.filter({ $0.isSelected }).count, 1)
        XCTAssertEqual(sut.selectedLanguages[0].name, "Italian")
        XCTAssertEqual(sut.selectedLanguages[0].iso639_2, "ita")
        XCTAssertEqual(sut.selectedLanguages[0].isSelected, true)
    }
    
    func test_onLanguageDeselected_shouldUpdateLanguages(){
        // Given
        let sut: LangFilterViewModel = LangFilterViewModel(LangFilterCoordinator(navigationController: SwipeBackNavigationController()), manager: TestableLangFilterManager(), selectedIso639_2: nil)
        let expetaction = XCTestExpectation(description: "Expected to update viewModel languages")
        
        // When
        sut.getLanguages(
            onSuccess: { viewModel in
                expetaction.fulfill()
            }
        )
        
        wait(for: [expetaction], timeout: 5.0)
        
        // Then
        XCTAssertEqual(sut.selectedLanguages.count, 0)
        XCTAssertEqual(sut.unselectedLanguages.count, sut.languages.count)
        XCTAssertEqual(sut.languages.filter({ $0.isSelected }).count, 0)
    }
}

extension LangFilterTests {
    private class TestableLangFilterManager: LangFilterManager {
        override func getLanguages(onSuccess: ((_ mainModel: [LangFilterModel])->Void)? = nil, onError: ((String)->Void)? = nil){
            onSuccess?(LangFilterTests.langFilterModel)
        }
    }
    
    static var langFilterModel: [LangFilterModel]{
        guard let url = Bundle(for: Self.self).url(forResource: "LangFilterTestData", withExtension: "json") else {
            fatalError()
        }
        do{
            let data = try Data(contentsOf: url)
            let jsonDecoder = JSONDecoder()
            let langFilterModel: [LangFilterModel] = try jsonDecoder.decode([LangFilterModel].self, from: data)
            return langFilterModel
        }catch{
            fatalError()
        }
    }
}

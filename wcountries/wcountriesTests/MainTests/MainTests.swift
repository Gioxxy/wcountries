//
//  MainTests.swift
//  MainTests
//
//  Created by Gionatan Cernusco on 26/02/21.
//

import XCTest
@testable import wcountries

class MainTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_getCountries_shouldReturnData(){
        // Given
        let sut: MainViewModel = MainViewModel(MainCoordinator(navigationController: SwipeBackNavigationController()), manager: TestableMainManager())
        let expetaction = XCTestExpectation(description: "Expected to get countries")
        expetaction.expectedFulfillmentCount = 3
        
        sut.showLoader = {
            expetaction.fulfill()
        }
        sut.dismissLoader = {
            expetaction.fulfill()
        }
        sut.updateGridView = {
            expetaction.fulfill()
        }
        sut.showError = { error in
            XCTFail()
        }
        
        // When
        sut.getCountries()
        
        wait(for: [expetaction], timeout: 5.0)
        
        // Then
        XCTAssertEqual(sut.countries[0].name, "ITALY")
        XCTAssertEqual(sut.countries[0].alpha2Code, "IT")
        XCTAssertEqual(sut.countries[0].imageURL, URL(string: "https://flagcdn.com/h60/it.png"))
    }
    
    func test_didSelectContinent_shouldSelectContinentAndReturnData(){
        // Given
        let sut: MainViewModel = MainViewModel(MainCoordinator(navigationController: SwipeBackNavigationController()), manager: TestableMainManager())
        let expetaction = XCTestExpectation(description: "Expected to get countries by continent")
        expetaction.expectedFulfillmentCount = 3
        let continent = MainViewModel.RegionViewModel(.Europe, isSelected: true)
        
        sut.showLoader = {
            expetaction.fulfill()
        }
        sut.dismissLoader = {
            expetaction.fulfill()
        }
        sut.updateGridView = {
            expetaction.fulfill()
        }
        sut.showError = { error in
            XCTFail()
        }
        
        // When
        sut.didSelectContinent(continent: continent)
        
        wait(for: [expetaction], timeout: 5.0)
        
        // Then
        XCTAssertEqual(sut.countries[0].name, "ITALY")
        XCTAssertEqual(sut.countries[0].alpha2Code, "IT")
        XCTAssertEqual(sut.countries[0].imageURL, URL(string: "https://flagcdn.com/h60/it.png"))
        XCTAssertTrue(sut.selectedContinent === continent)
    }
    
    func test_didDeselectContinent_shouldDeselectContinentAndReturnData(){
        // Given
        let sut: MainViewModel = MainViewModel(MainCoordinator(navigationController: SwipeBackNavigationController()), manager: TestableMainManager())
        let expetaction = XCTestExpectation(description: "Expected to get countries by continent")
        expetaction.expectedFulfillmentCount = 3
        
        sut.showLoader = {
            expetaction.fulfill()
        }
        sut.dismissLoader = {
            expetaction.fulfill()
        }
        sut.updateGridView = {
            expetaction.fulfill()
        }
        sut.showError = { error in
            XCTFail()
        }
        
        // When
        sut.didDeselectContinent()
        
        wait(for: [expetaction], timeout: 5.0)
        
        // Then
        XCTAssertEqual(sut.countries[0].name, "ITALY")
        XCTAssertEqual(sut.countries[0].alpha2Code, "IT")
        XCTAssertEqual(sut.countries[0].imageURL, URL(string: "https://flagcdn.com/h60/it.png"))
        XCTAssertTrue(sut.selectedContinent == nil)
    }
    
    func test_filterByLanguage_shouldSlectLanguageAndReturnData(){
        // Given
        let coordinator = MainCoordinator(navigationController: SwipeBackNavigationController())
        let sut: MainViewModel = MainViewModel(coordinator, manager: TestableMainManager())
        let expetaction = XCTestExpectation(description: "Expected to get countries by language")
        expetaction.expectedFulfillmentCount = 3
        let language = "ita"
        
        sut.showLoader = {
            expetaction.fulfill()
        }
        sut.dismissLoader = {
            expetaction.fulfill()
        }
        sut.updateGridView = {
            expetaction.fulfill()
        }
        sut.showError = { error in
            XCTFail()
        }
        
        // When
        coordinator.filterByLanguage?(language)
        
        wait(for: [expetaction], timeout: 5.0)
        
        // Then
        XCTAssertEqual(sut.countries[0].name, "ITALY")
        XCTAssertEqual(sut.countries[0].alpha2Code, "IT")
        XCTAssertEqual(sut.countries[0].imageURL, URL(string: "https://flagcdn.com/h60/it.png"))
        XCTAssertTrue(sut.selectedIso639_2 == language)
    }
    
    func test_cleanLanguageFilter_shouldDeselectLanguageAndReturnData(){
        // Given
        let coordinator = MainCoordinator(navigationController: SwipeBackNavigationController())
        let sut: MainViewModel = MainViewModel(coordinator, manager: TestableMainManager())
        let expetaction = XCTestExpectation(description: "Expected to get countries by language")
        expetaction.expectedFulfillmentCount = 3
        
        sut.showLoader = {
            expetaction.fulfill()
        }
        sut.dismissLoader = {
            expetaction.fulfill()
        }
        sut.updateGridView = {
            expetaction.fulfill()
        }
        sut.showError = { error in
            XCTFail()
        }
        
        // When
        coordinator.cleanLanguageFilter?()
        
        wait(for: [expetaction], timeout: 5.0)
        
        // Then
        XCTAssertEqual(sut.countries[0].name, "ITALY")
        XCTAssertEqual(sut.countries[0].alpha2Code, "IT")
        XCTAssertEqual(sut.countries[0].imageURL, URL(string: "https://flagcdn.com/h60/it.png"))
        XCTAssertTrue(sut.selectedIso639_2 == nil)
    }
    
    func test_didTapOnCountry_shouldStartDetail(){
        // Given
        let mainCoordinator = MainCoordinator(navigationController: SwipeBackNavigationController())
        let sut = MainViewModel(mainCoordinator, manager: TestableMainManager())
        
        // When
        sut.getCountries()
        sut.didTapOnCountry(viewModel: MainViewModel.CountryViewModel(name: "Italy", alpha2Code: "IT"))
        
        // Then
        XCTAssertGreaterThan(mainCoordinator.childCoordinators.count, 0)
    }
    
    func test_didTapOnFilterButton_shouldStartLangFilter(){
        // Given
        let mainCoordinator = MainCoordinator(navigationController: SwipeBackNavigationController())
        let sut = MainViewModel(mainCoordinator, manager: TestableMainManager())
        
        // When
        sut.didTapOnFilterButton()
        
        // Then
        XCTAssertGreaterThan(mainCoordinator.childCoordinators.count, 0)
    }
    
    func test_MainViewModel_shouldAssignValues(){
        // Given
        let coordinator = MainCoordinator(navigationController: SwipeBackNavigationController())
        let manager = TestableMainManager()
        
        // When
        let sut: MainViewModel = MainViewModel(coordinator, manager: manager)
        
        // Then
        XCTAssertEqual(sut.regions.map({ $0.type}), [RegionType.Africa, RegionType.Americas, RegionType.Asia, RegionType.Europe, RegionType.Oceania])
    }
    
    
}

extension MainTests {
    private class TestableMainManager: MainManager {
        override func getCountries(onSuccess: ((_ mainModel: [MainCountryModel])->Void)? = nil, onError: ((String)->Void)? = nil){
            onSuccess?(MainTests.mainCountryModel)
        }
        
        override func getCountriesBy(continent: MainViewModel.RegionViewModel, onSuccess: ((_ mainModel: [MainCountryModel])->Void)? = nil, onError: ((String)->Void)? = nil){
            onSuccess?(MainTests.mainCountryModel)
        }
        
        // Get countries by language code iso639_2
        override func getCountriesBy(iso639_2: String, onSuccess: ((_ mainModel: [MainCountryModel])->Void)? = nil, onError: ((String)->Void)? = nil){
            onSuccess?(MainTests.mainCountryModel)
        }
    }
    
    static var mainCountryModel: [MainCountryModel]{
        guard let url = Bundle(for: Self.self).url(forResource: "MainCountryModelTestData", withExtension: "json") else {
            fatalError()
        }
        do{
            let data = try Data(contentsOf: url)
            let jsonDecoder = JSONDecoder()
            let mainCountryModel: [MainCountryModel] = try jsonDecoder.decode([MainCountryModel].self, from: data)
            return mainCountryModel
        }catch{
            fatalError()
        }
    }
}

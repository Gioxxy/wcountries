//
//  DetailTests.swift
//  wcountriesTests
//
//  Created by Gionatan Cernusco on 11/03/21.
//

import XCTest
@testable import wcountries

class DetailTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_getCountry_shouldReturnData(){
        // Given
        let mainCountryModel = MainCountryModel(name: "Italy", alpha2Code: "IT", alpha3Code: "ITA")
        let coordinator = DetailCoordinator(navigationController: UINavigationController(), model: mainCountryModel)
        let sut: DetailViewModel = DetailViewModel(coordinator, manager: TestableDetailManager(), model: mainCountryModel)
        let expetaction = XCTestExpectation(description: "Expected to get country")
        expetaction.expectedFulfillmentCount = 3
        
        XCTAssertEqual(sut.country.name, mainCountryModel.name)
        XCTAssertEqual(sut.country.alpha3Code, mainCountryModel.alpha3Code)

        // When
        sut.getCountry(
            alpha3Code: sut.country.alpha3Code,
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
        XCTAssertEqual(sut.country.name, "ITALY")
        XCTAssertEqual(sut.country.alpha3Code, "ITA")
        XCTAssertEqual(sut.country.imageURL, URL(string: "https://flagcdn.com/h120/it.png"))
        XCTAssertEqual(sut.country.region?.type, .Europe)
        XCTAssertEqual(sut.country.region?.imageName, "europe")
        XCTAssertEqual(sut.neighboringCountries?.title, "Neighboring countries")
        XCTAssertEqual(
            sut.neighboringCountries?.neighboringCountries.map({ $0.alpha2Code }),
            ["AT", "FR", "SM", "SI", "CH", "VA"]
        )
        XCTAssertEqual(sut.neighboringCountries?.neighboringCountries[0].alpha2Code, "AT")
        XCTAssertEqual(sut.neighboringCountries?.neighboringCountries[0].imageURL, URL(string: "https://flagcdn.com/h60/at.png"))
        XCTAssertEqual(sut.country.currencySymbol, "€")
        XCTAssertEqual(sut.country.details[0].title, "Native name")
        XCTAssertEqual(sut.country.details[0].detail, "Italia")
        XCTAssertEqual(sut.country.details[1].title, "Capital")
        XCTAssertEqual(sut.country.details[1].detail, "Rome")
        XCTAssertEqual(sut.country.details[2].title, "Population")
        XCTAssertEqual(sut.country.details[2].detail, "60,665,551")
        XCTAssertEqual(sut.country.details[3].title, "Latitude longitude")
        XCTAssertEqual(sut.country.details[3].detail, "42.83333333, 12.83333333")
        XCTAssertEqual(sut.country.details[4].title, "Area")
        XCTAssertEqual(sut.country.details[4].detail, "301,336.00 Km²")
        XCTAssertEqual(sut.country.details[5].title, "Language")
        XCTAssertEqual(sut.country.details[5].detail, "Italian")
        XCTAssertEqual(sut.country.details[6].title, "Timezone")
        XCTAssertEqual(sut.country.details[6].detail, "UTC+01:00")
    }
    
    func test_onNeighboringCountryDidTap_shouldStartDetail(){
        // Given
        let model = MainCountryModel(name: "Italy", alpha2Code: "IT", alpha3Code: "ITA")
        let detailCoordinator = DetailCoordinator(navigationController: UINavigationController(), model: model)
        let sut = DetailViewModel(detailCoordinator, manager: TestableDetailManager(), model: model)
        let expetaction = XCTestExpectation(description: "Expected to get country")
        
        // When
        sut.getCountry(
            alpha3Code: model.alpha3Code,
            onSuccess: { viewModel in
                expetaction.fulfill()
            })
        
        wait(for: [expetaction], timeout: 5.0)
        
        sut.onNeighboringCountryDidTap(country: DetailViewModel.NeighboringCountry(alpha2Code: "AT"))
        
        // Then
        XCTAssertGreaterThan(detailCoordinator.childCoordinators.count, 0)
    }
}

extension DetailTests {
    private class TestableDetailManager: DetailManager {
        override func getCountry(alpha3Code: String, onSuccess: ((_ mainModel: CountryModel)->Void)? = nil, onError: ((String)->Void)? = nil){
            onSuccess?(countryModel)
        }
        
        override func getNeighboringCountries(alpha3Codes: [String], onSuccess: (([MainCountryModel]) -> Void)? = nil, onError: ((String) -> Void)? = nil) {
            onSuccess?(neighboringCountriesModel)
        }
    }
    
    static var countryModel: CountryModel{
        guard let url = Bundle(for: Self.self).url(forResource: "CountryModelTestData", withExtension: "json") else {
            fatalError()
        }
        do{
            let data = try Data(contentsOf: url)
            let jsonDecoder = JSONDecoder()
            let mainCountryModel: CountryModel = try jsonDecoder.decode(CountryModel.self, from: data)
            return mainCountryModel
        }catch{
            fatalError()
        }
    }
    
    static var neighboringCountriesModel: [MainCountryModel]{
        guard let url = Bundle(for: Self.self).url(forResource: "DetailMainCountryModelTestData", withExtension: "json") else {
            fatalError()
        }
        do{
            let data = try Data(contentsOf: url)
            let jsonDecoder = JSONDecoder()
            let neighboringCountriesModel: [MainCountryModel] = try jsonDecoder.decode([MainCountryModel].self, from: data)
            return neighboringCountriesModel
        }catch{
            fatalError()
        }
    }
}

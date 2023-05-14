//
//  Under_The_WeatherTests.swift
//  Under The WeatherTests
//
//  Created by Matthew Lock on 29/04/2023.
//

import XCTest
@testable import Under_The_Weather

final class Under_The_WeatherTests: XCTestCase {
    
    var sut: DataService!
    
    override func setUpWithError() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        sut = DataManager(urlSession: urlSession)
    }

    override func tearDownWithError() throws {
        sut = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.error = nil
    }

    func testPrefixCitiesSearchInDataManagerWithValidCity_ReturnsSuccess() throws {
        //Given
        let expectation = expectation(description: "Load home city")
        let jsonString = "[{\"name\": \"London\", \"place_id\": \"london\", \"adm_area1\": \"England\", \"adm_area2\": \"Greater London\", \"country\": \"United Kingdom\", \"lat\": \"23.2N\", \"lon\": \"15.3E\", \"timezone\": \"Europe/London\", \"type\": \"settlement\"}]"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        //When
        sut.prefixCitySearch(city: "London", completionHandler: { (_) in
        //Then
            XCTAssertEqual(self.sut.originCity, "London")
            expectation.fulfill()
        })
        
        self.wait(for: [expectation], timeout: 3)
    }

    func testPrefixCitiesSearchInDataManagerWithInvalidAPIKey_ThrowsError() throws {
        //Given
        let expectation = expectation(description: "Load home city with Invalid API Details")
        let jsonString = "[{\"name\": \"London\", \"place_id\": \"london\", \"adm_area1\": \"England\", \"adm_area2\": \"Greater London\", \"country\": \"United Kingdom\", \"lat\": \"23.2N\", \"lon\": \"15.3E\", \"timezone\": \"Europe/London\", \"type\": \"settlement\"}]"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        //When
        // MUST INVALIDATE API KEY
        sut.prefixCitySearch(city: "London", completionHandler: { (_) in
        //Then
            XCTAssertEqual(self.sut.originCity, "London")
            expectation.fulfill()
        })
        
        self.wait(for: [expectation], timeout: 3)
    }
    
    func testPrefixCitiesSearchInDataManagerWithInvalidDataResponse_ThrowsError() throws {
        //Given
        let expectation = expectation(description: "Load home city from invalid data ")
        let jsonString = "[{\"name\": \"London\", \"place_id\": \"london\", \"adm_area1\": \"England\", \"adm_area2\": \"Greater London\", \"country\": \"United Kingdom\", \"lat\": \"23.2N\", \"lon\": \"15.3E\", \"timezone\": \"Europe/London\", \"type\": \"settlement\"/}]"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        //When
        
        sut.prefixCitySearch(city: "London", completionHandler: { (result) in
            //Then
            switch result {
            case .success(_):
                XCTFail("This should not happen")
            case .failure(let error):
                XCTAssertNil(self.sut.originCity)
                XCTAssertEqual(error.localizedDescription, NetworkError.validationError.localizedDescription)
                expectation.fulfill()
            }
        })
        
        self.wait(for: [expectation], timeout: 3)
    }
    
}

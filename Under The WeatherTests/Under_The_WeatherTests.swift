//
//  Under_The_WeatherTests.swift
//  Under The WeatherTests
//
//  Created by Matthew Lock on 29/04/2023.
//

import XCTest
@testable import Under_The_Weather

final class Under_The_WeatherTests: XCTestCase {
    
    var sut: NetworkService!
    
    override func setUpWithError() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        sut = NetworkService(urlSession: urlSession)
    }

    override func tearDownWithError() throws {
        sut = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.error = nil
    }

    func testCitiesSearchInNetworkServiceWithValidCity_ReturnsSuccess() throws {
        //Given
        let expectation = expectation(description: "Load city results")
        let jsonString = "[{\"name\": \"London\", \"place_id\": \"london\", \"adm_area1\": \"England\", \"adm_area2\": \"Greater London\", \"country\": \"United Kingdom\", \"lat\": \"23.2N\", \"lon\": \"15.3E\", \"timezone\": \"Europe/London\", \"type\": \"settlement\"}]"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)

        //When
        sut.citySearch(city: "London", completionHandler: { result in
        //Then
            switch result {
            case .success(let success):
                XCTAssertEqual(success.first?.name, "London")
                XCTAssertEqual(success.first?.place_id, "london")
                XCTAssertEqual(success.first?.adm_area1, "England")
                XCTAssertEqual(success.first?.country, "United Kingdom")
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        })
        
        self.wait(for: [expectation], timeout: 2)
    }
    
    func testCitiesSearchInNetworkServiceWithInvalidDataResponse_ThrowsError() throws {
        //Given
        let expectation = expectation(description: "Load home city from invalid data ")
        let jsonString = "[{\"name\": \"London\", \"place_id\": \"london\", \"adm_area1\": \"England\", \"adm_area2\": \"Greater London\", \"country\": \"United Kingdom\", \"lat\": \"23.2N\", \"lon\": \"15.3E\", \"timezone\": \"Europe/London\", \"type\": \"settlement\"/}]"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        //When
        
        sut.citySearch(city: "London", completionHandler: { result in
            //Then
            switch result {
            case .success(_):
                XCTFail("This should not happen")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.validationError.localizedDescription)
                expectation.fulfill()
            }
        })
        
        self.wait(for: [expectation], timeout: 2)
    }
    
}

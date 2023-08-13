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

    func testCitiesSearchWithValidCity_ReturnsSuccess() throws {
        //Given
        let expectation = expectation(description: "Load city results")
        let jsonString = "[{\"name\": \"London\", \"place_id\": \"london\", \"adm_area1\": \"England\", \"adm_area2\": \"Greater London\", \"country\": \"United Kingdom\", \"lat\": \"23.2N\", \"lon\": \"15.3E\", \"timezone\": \"Europe/London\", \"type\": \"settlement\"}]"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        
        //When
        sut.citySearch(city: "London", completionHandler: { result in
            
        //Then
            switch result {
            case .success(let response):
                XCTAssertEqual(response.first?.name, "London")
                XCTAssertEqual(response.first?.place_id, "london")
                XCTAssertEqual(response.first?.adm_area1, "England")
                XCTAssertEqual(response.first?.country, "United Kingdom")
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        })
        self.wait(for: [expectation], timeout: 2)
    }
    
    func testCitiesSearchWithInValidCity_ReturnsError() throws {
        //Given
        let expectation = expectation(description: "Load city results from invalid search term")

        //When
        sut.citySearch(city: "vre43", completionHandler: { result in
            
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
    
    func testCitiesSearchWithInvalidDataResponse_ThrowsError() throws {
        //Given
        let expectation = expectation(description: "Load home city from invalid data")
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
    
    func testFetchCityImagesWithValidRequestProvidesCityImage() throws {
        //Given
        let expectation = expectation(description: "Load city image")
        let jsonString = "{\"hits\": [{\"previewURL\": \"https://cdn.pixabay.com/photo/2014/11/13/23/34/palace-530055_150.jpg/\"}]}"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        
        //When
        sut.fetchCityImages(city: "London", completionHandler: { result in
            
            //Then
            switch result {
            case .success(let response):
                XCTAssertEqual(response, "https://cdn.pixabay.com/photo/2014/11/13/23/34/palace-530055_150.jpg/")
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        })
        
        self.wait(for: [expectation], timeout: 2)
    }
    
}

//
//  Under_The_Weather_UserDefault_Tests.swift
//  Under The WeatherTests
//
//  Created by Matthew Lock on 24/08/2023.
//

import XCTest
@testable import Under_The_Weather

final class Under_The_Weather_UserDefault_Tests: XCTestCase {
    
    private var userDefaultTestKey = "userDefaultsTestKey"
    
    var sut: DataStorageMock!
    
    @MainActor override func setUp() {
        let dummyUserCity = [UserCity(name: "London", place_id: "london", country: "United Kingdom", image: "https://cdn.pixabay.com/photo/2014/11/13/23/34/palace-530055_150.jpg")]
        
        sut = DataStorageMock()
        sut.userTestKey = userDefaultTestKey
        sut.addUserCity(cityObject: dummyUserCity)
    }
    
    override func tearDown(){
        UserDefaults.standard.removeObject(forKey: userDefaultTestKey)
    }
    
    @MainActor func testAddCityToUserDefaults() {
        //When
        sut.userCities = nil
        sut.loadUserCities()

        //Then
        XCTAssertNotNil(sut.userCities)
    }
    
    @MainActor func testDecodeDataFromUserDefaults() {
        //When
        sut.loadUserCities()
        let savedUserCities = sut.decodeToUserCityObject()

        //Then
        XCTAssertEqual(savedUserCities.count, 1)
    }

}

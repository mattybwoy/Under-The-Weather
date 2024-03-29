//
//  MockURLProtocol.swift
//  Under The WeatherTests
//
//  Created by Matthew Lock on 13/05/2023.
//

import Foundation

class MockURLProtocol: URLProtocol {

    static var stubResponseData: Data?
    static var error: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let networkError = MockURLProtocol.error {
            client?.urlProtocol(self, didFailWithError: networkError)
        } else {
            client?.urlProtocol(self, didLoad: MockURLProtocol.stubResponseData ?? Data())
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}

}

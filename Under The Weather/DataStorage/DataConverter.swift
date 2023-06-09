//
//  DataConverter.swift
//  Under The Weather
//
//  Created by Matthew Lock on 09/06/2023.
//

import Foundation

public struct DataConverter {
    
    //var city: Cities
    
    func convertCity(city: Cities) -> Data? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(city)
            return data
        }
        catch {
            print("Unable to convert \(city)")
        }
        return nil
    }
}

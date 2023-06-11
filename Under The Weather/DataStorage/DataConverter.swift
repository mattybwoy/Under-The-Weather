//
//  DataConverter.swift
//  Under The Weather
//
//  Created by Matthew Lock on 09/06/2023.
//

import Foundation

public struct DataConverter {
    
    func encodeCity(city: Cities) -> Data? {
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
    
    func decodeCities(data: Data) -> [Cities] {
        do {
            let decoder = JSONDecoder()
            let cities = try decoder.decode([Cities].self, from: data)
            return cities
        } catch {
            print("Unable to Decode Cities (\(error))")
        }
        return []
    }
    
}

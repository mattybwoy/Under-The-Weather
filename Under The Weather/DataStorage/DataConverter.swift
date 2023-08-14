//
//  DataConverter.swift
//  Under The Weather
//
//  Created by Matthew Lock on 09/06/2023.
//

import Foundation

public struct DataConverter {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    func encodeCities(cities: [UserCity]) -> Data? {
        do {
            let data = try encoder.encode(cities)
            return data
        }
        catch {
            print("Unable to convert \(cities)")
        }
        return nil
    }
    
    func decodeCities(data: Data) -> [UserCity] {
        do {
            let cities = try decoder.decode([UserCity].self, from: data)
            return cities
        } catch {
            print("Unable to Decode Cities (\(error))")
        }
        return []
    }
    
}

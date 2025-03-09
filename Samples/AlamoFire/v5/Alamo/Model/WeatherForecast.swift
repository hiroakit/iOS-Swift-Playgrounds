//
//  WeatherForecast.swift
//  Alamo
//
//  Created by hiroakit on 2025/03/09.
//

import Foundation

struct WeatherForecast: Identifiable, Decodable {
    var id: UUID { UUID() }
    let summary: String
}

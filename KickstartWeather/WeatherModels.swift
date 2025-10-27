import Foundation

// MARK: - OpenWeatherMap API Response Models

struct WeatherResponse: Codable {
    let coord: Coordinates
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String
    let sys: Sys
}

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
}

struct Wind: Codable {
    let speed: Double
    let deg: Int?
}

struct Sys: Codable {
    let country: String
    let sunrise: Int
    let sunset: Int
}

// MARK: - Display Model

struct WeatherData {
    let cityName: String
    let temperature: Double
    let feelsLike: Double
    let condition: String
    let conditionDescription: String
    let humidity: Int
    let windSpeed: Double
    let icon: String

    init(from response: WeatherResponse) {
        self.cityName = response.name
        self.temperature = response.main.temp
        self.feelsLike = response.main.feelsLike
        self.condition = response.weather.first?.main ?? "Unknown"
        self.conditionDescription = response.weather.first?.description.capitalized ?? "No description"
        self.humidity = response.main.humidity
        self.windSpeed = response.wind.speed
        self.icon = response.weather.first?.icon ?? "01d"
    }

    var temperatureString: String {
        return String(format: "%.0f°", temperature)
    }

    var feelsLikeString: String {
        return String(format: "Feels like %.0f°", feelsLike)
    }

    var humidityString: String {
        return "\(humidity)%"
    }

    var windSpeedString: String {
        return String(format: "%.1f m/s", windSpeed)
    }

    // Map OpenWeatherMap icon codes to SF Symbols
    var systemIconName: String {
        switch icon {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.fill"
        case "02d": return "cloud.sun.fill"
        case "02n": return "cloud.moon.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "smoke.fill"
        case "09d", "09n": return "cloud.rain.fill"
        case "10d": return "cloud.sun.rain.fill"
        case "10n": return "cloud.moon.rain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "snow"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "questionmark.circle.fill"
        }
    }
}

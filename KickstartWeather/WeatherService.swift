import Foundation
import CoreLocation

class WeatherService {
    private let apiKey: String
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherData {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude)),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]

        guard let url = components?.url else {
            throw WeatherError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw WeatherError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            if httpResponse.statusCode == 401 {
                throw WeatherError.invalidAPIKey
            }
            throw WeatherError.httpError(statusCode: httpResponse.statusCode)
        }

        do {
            let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            return WeatherData(from: weatherResponse)
        } catch {
            throw WeatherError.decodingError(error)
        }
    }
}

enum WeatherError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidAPIKey
    case httpError(statusCode: Int)
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidAPIKey:
            return "Invalid API key. Please check your OpenWeatherMap API key."
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode weather data: \(error.localizedDescription)"
        }
    }
}

import SwiftUI
import CoreLocation

struct WeatherView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var weatherData: WeatherData?
    @State private var isLoading = false
    @State private var errorMessage: String?

    // Replace with your OpenWeatherMap API key
    private let apiKey = "YOUR_OPENWEATHERMAP_API_KEY"

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                if isLoading {
                    loadingView
                } else if let weather = weatherData {
                    weatherContentView(weather: weather)
                } else {
                    emptyStateView
                }
            }
            .padding()
        }
        .onChange(of: locationManager.location) { _, newLocation in
            if let location = newLocation {
                fetchWeather(for: location)
            }
        }
        .onChange(of: locationManager.errorMessage) { _, error in
            if let error = error {
                errorMessage = error
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }

    // MARK: - Subviews

    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)

            Text("Fetching weather...")
                .font(.headline)
                .foregroundStyle(.white)
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "location.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.white.opacity(0.8))

            if let error = errorMessage ?? locationManager.errorMessage {
                Text(error)
                    .font(.body)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            } else {
                Text("Tap to get weather")
                    .font(.headline)
                    .foregroundStyle(.white)
            }

            Button(action: {
                locationManager.requestLocation()
            }) {
                Label("Get Weather", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(15)
            }
        }
    }

    private func weatherContentView(weather: WeatherData) -> some View {
        VStack(spacing: 30) {
            // City name
            Text(weather.cityName)
                .font(.system(size: 36, weight: .medium))
                .foregroundStyle(.white)

            // Weather icon
            Image(systemName: weather.systemIconName)
                .font(.system(size: 100))
                .foregroundStyle(.white)
                .symbolRenderingMode(.hierarchical)

            // Temperature
            Text(weather.temperatureString)
                .font(.system(size: 70, weight: .thin))
                .foregroundStyle(.white)

            // Feels like
            Text(weather.feelsLikeString)
                .font(.title3)
                .foregroundStyle(.white.opacity(0.8))

            // Condition description
            Text(weather.conditionDescription)
                .font(.title2)
                .foregroundStyle(.white)
                .padding(.bottom, 20)

            // Weather details grid
            HStack(spacing: 40) {
                WeatherDetailView(
                    icon: "humidity.fill",
                    label: "Humidity",
                    value: weather.humidityString
                )

                WeatherDetailView(
                    icon: "wind",
                    label: "Wind",
                    value: weather.windSpeedString
                )
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(20)

            Spacer()

            // Refresh button
            Button(action: {
                locationManager.requestLocation()
            }) {
                Label("Refresh", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(15)
            }
        }
        .padding(.top, 40)
    }

    // MARK: - Computed Properties

    private var gradientColors: [Color] {
        guard let weather = weatherData else {
            return [Color.blue, Color.purple]
        }

        // Change gradient based on weather condition
        switch weather.condition.lowercased() {
        case "clear":
            return [Color.blue, Color.cyan]
        case "clouds":
            return [Color.gray, Color.blue.opacity(0.6)]
        case "rain", "drizzle":
            return [Color.gray, Color.blue.opacity(0.8)]
        case "thunderstorm":
            return [Color.gray.opacity(0.8), Color.purple.opacity(0.6)]
        case "snow":
            return [Color.white.opacity(0.8), Color.blue.opacity(0.4)]
        case "mist", "fog", "haze":
            return [Color.gray.opacity(0.6), Color.white.opacity(0.6)]
        default:
            return [Color.blue, Color.purple]
        }
    }

    // MARK: - Helper Methods

    private func fetchWeather(for location: CLLocation) {
        isLoading = true
        errorMessage = nil

        let service = WeatherService(apiKey: apiKey)

        Task {
            do {
                let weather = try await service.fetchWeather(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
                await MainActor.run {
                    self.weatherData = weather
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}

// MARK: - Weather Detail View

struct WeatherDetailView: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(.white)

            Text(label)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))

            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    WeatherView()
}

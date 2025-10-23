# Kickstart Weather

A lightweight SwiftUI weather app for iOS 18 that uses Core Location to get your current position and fetches live weather data from OpenWeatherMap.

## Features

- Real-time weather data from OpenWeatherMap API
- Automatic location detection using Core Location
- Beautiful gradient backgrounds that change based on weather conditions
- SF Symbols weather icons
- Display of temperature, feels like, humidity, and wind speed
- Simple and clean SwiftUI interface

## Requirements

- Xcode 16.0 or later
- iOS 18.0 or later
- xcodegen (for project generation)
- OpenWeatherMap API key

## Setup

### 1. Install xcodegen

If you don't have xcodegen installed, install it using Homebrew:

```bash
brew install xcodegen
```

### 2. Get an OpenWeatherMap API Key

1. Go to [OpenWeatherMap](https://openweathermap.org/api)
2. Sign up for a free account
3. Generate an API key from your account dashboard

### 3. Configure the API Key

Open `KickstartWeather/WeatherView.swift` and replace `YOUR_OPENWEATHERMAP_API_KEY` with your actual API key:

```swift
private let apiKey = "your_actual_api_key_here"
```

### 4. Generate the Xcode Project

Run xcodegen to generate the Xcode project:

```bash
xcodegen generate
```

This will create `KickstartWeather.xcodeproj` based on the `project.yml` configuration.

### 5. Open and Run

```bash
open KickstartWeather.xcodeproj
```

Then build and run the project on a simulator or device (iOS 18.0+).

## Project Structure

```
KickstartWeather/
├── KickstartWeather/
│   ├── KickstartWeatherApp.swift  # Main app entry point
│   ├── WeatherView.swift          # Main weather UI
│   ├── WeatherModels.swift        # Data models for OpenWeatherMap API
│   ├── WeatherService.swift       # API service for fetching weather
│   ├── LocationManager.swift      # Core Location manager
│   └── Info.plist                 # App configuration
├── project.yml                     # xcodegen configuration
└── README.md                       # This file
```

## How It Works

1. **Location Services**: The app requests location permission when launched
2. **Weather Fetching**: Once location is obtained, it fetches weather data from OpenWeatherMap
3. **UI Display**: Weather data is displayed with appropriate icons and colors
4. **Dynamic Backgrounds**: The gradient background changes based on weather conditions (Clear, Clouds, Rain, etc.)

## Customization

### Weather Icons

Weather icons are mapped from OpenWeatherMap icon codes to SF Symbols in `WeatherModels.swift`. You can customize the mapping in the `systemIconName` computed property.

### Background Colors

Background gradients are defined in `WeatherView.swift` in the `gradientColors` computed property. You can customize colors for different weather conditions.

### Units

The app currently uses metric units (Celsius, m/s). To change to imperial units, modify the `units` parameter in `WeatherService.swift` from `"metric"` to `"imperial"`.

## Troubleshooting

### Location Permission Denied

If the app doesn't have location permission:
1. Go to Settings > Privacy & Security > Location Services
2. Find "Weather" (or KickstartWeather)
3. Set permission to "While Using the App"

### API Key Issues

If you see an "Invalid API key" error:
1. Verify your API key is correct
2. Make sure your OpenWeatherMap account is activated
3. API keys can take a few minutes to become active after creation

### Build Errors

If you encounter build errors:
1. Make sure you're using Xcode 16.0 or later
2. Verify iOS deployment target is set to 18.0
3. Clean build folder (Shift+Cmd+K) and rebuild

## License

This project is open source and available under the MIT License.

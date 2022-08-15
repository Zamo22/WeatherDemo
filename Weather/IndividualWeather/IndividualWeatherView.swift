//
//  Created by Zaheer Moola on 2022/08/14.
//

import SwiftUI

struct IndividualWeatherView: View {
    @StateObject var viewModel: WeatherViewModel

    var body: some View {
        Group {
            switch viewModel.weatherViewState {
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                // TODO: Use a lottie animation here
            case .error:
                Text("An error occurred")
            case .loaded(let currentWeather, let forecast):
                ZStack {
                    Color(currentWeather
                        .weatherCondition.colorName)
                    VStack{
                        CurrentWeatherView(currentWeather: currentWeather)
                        ForecastView(weatherForecast: forecast)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct CurrentWeatherView: View {
    let currentWeather: CurrentWeather

    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                Image(currentWeather.weatherCondition.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                VStack(spacing: 16) {
                    if let place = currentWeather.placeName {
                        Text(place)
                            .font(.title)
                    }
                    VStack(spacing: 5) {
                        Text("\(Int(currentWeather.temperatures.temp))°")
                            .font(.system(size: 50))

                        Text(currentWeather.weather.first?.main ?? "-")
                            .font(.title3)
                    }
                }
                .foregroundColor(.white)
                .padding(.top, 50)
            }

            HStack {
                if let minTemp = currentWeather.temperatures.minTemp {
                    InfoView(info: "\(Int(minTemp))°", description: "min")
                }
                if let feelsLike = currentWeather.temperatures.feelsLike {
                    InfoView(info: "\(Int(feelsLike))°", description: "feels like")
                }
                if let maxTemp = currentWeather.temperatures.maxTemp {
                    InfoView(info: "\(Int(maxTemp))°", description: "max")
                }
            }

            Rectangle().fill(.white).frame(height: 1)
        }
    }

    private struct InfoView: View {
        let info: String
        let description: String

        var body: some View {
            VStack {
                Text(info)
                Text(description)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
        }
    }
}

struct ForecastView: View {
    let weatherForecast: [WeatherForecastItem]

    var body: some View {
        ForEach(weatherForecast, id: \.forecastTime) { forecast in
            HStack {
                Text(forecast.forecastTime.day)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                Image(forecast.weatherCondition.iconName)
                    .frame(width: 24, height: 24)
                Text("\(Int(forecast.temperatures.temp))°")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing)
            }
            .padding(.top)
            .foregroundColor(.white)
        }
    }
}

struct IndividualWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        IndividualWeatherView(viewModel: WeatherViewModel.preview)
    }
}

//
//  Created by Zaheer Moola on 2022/08/14.
//

import SwiftUI

struct IndividualWeatherView: View {
    @StateObject var viewModel: WeatherViewModel

    var body: some View {
        Group {
            if let currentWeather = viewModel.currentWeather {
                ZStack {
                    Color(viewModel.currentWeather?
                        .weatherCondition.colorName ?? "sunnyColor")
                    VStack{
                        CurrentWeatherView(currentWeather: currentWeather)
                        Spacer()
                    }
                }
            } else {
                // TODO: Use a lottie animation here
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .onAppear {
            viewModel.getCurrentWeather()
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

                VStack(spacing: 5) {
                    Text("\(Int(currentWeather.temperatures.temp))°")
                        .font(.system(size: 50))
                        .foregroundColor(.white)

                    Text(currentWeather.weather.first?.main ?? "-")
                        .font(.title)
                        .foregroundColor(.white)
                }
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
                    .foregroundColor(.white)
                Text(description)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct ForecastView: View {
    var body: some View {
        Text("")
    }
}


struct IndividualWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        IndividualWeatherView(viewModel: WeatherViewModel.preview)
    }
}

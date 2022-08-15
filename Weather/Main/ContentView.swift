//
//  Created by Zaheer Moola on 2022/08/12.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var mainViewModel = MainViewModel()

    var body: some View {
        Group {
            switch mainViewModel.viewState {
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            case .locationError:
                Text("Error getting location")
            case .permissionDenied:
                Text("You have denied permissions")
            case .loaded:
                WeatherView()
            }
        }.onAppear {
            mainViewModel.getCurrentLocation()
        }
        .environmentObject(mainViewModel)
    }
}

struct WeatherView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @State private var showSettings = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            TabView {
                ForEach(mainViewModel.pages, id: \.self) { coordinate in
                    let viewModel = WeatherViewModel(withLocation: coordinate)
                    IndividualWeatherView(viewModel: viewModel)
                }
            }
            .tabViewStyle(PageTabViewStyle())

            Button(action: settingsButtonTapped) {
                Image(systemName: "ellipsis")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding([.top, .trailing])
            }
        }
        .sheet(isPresented: $showSettings, onDismiss: {
            mainViewModel.refreshIfNeeded()
        }) {
            SettingsView()
        }
    }

    func settingsButtonTapped() {
        showSettings.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

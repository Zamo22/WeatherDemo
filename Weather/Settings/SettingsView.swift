//
//  Created by Zaheer Moola on 2022/08/15.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()

    var body: some View {
        SettingsPickerView(viewModel: viewModel)
    }
}

struct SettingsPickerView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Display weather in:")
            Picker("Display weather in:", selection: $viewModel.unitOfMeasurement) {
                ForEach(UnitMeasurement.allCases) {
                    Text($0.commonName)
                }
            }
            .pickerStyle(.segmented)

        }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

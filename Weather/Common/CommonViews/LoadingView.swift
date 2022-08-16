//
//  Created by Zaheer Moola on 2022/08/16.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        LottieView(name: "loader", loopMode: .loop)
            .frame(width: 205, height: 250)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

//
//  Created by Zaheer Moola on 2022/08/14.
//

enum WeatherCondition: String {
    case cloudy
    case rainy
    case sunny

    var imageName: String {
        self.rawValue
    }

    var colorName: String {
        switch self {
        case .cloudy:
            return "cloudyColor"
        case .rainy:
            return "rainyColor"
        case .sunny:
            return "sunnyColor"
        }
    }
}

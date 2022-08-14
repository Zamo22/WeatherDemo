//
//  Created by Zaheer Moola on 2022/08/14.
//

enum WeatherCondition: String {
    case thunderstorm
    case drizle
    case rainy
    case snow
    case atmosphere
    case sunny
    case cloudy

    static func build(fromCode code: Int) -> Self {
        switch code {
        case 200..<300:
            return .thunderstorm
        case 300..<400:
            return .drizle
        case 500..<600:
            return .rainy
        case 600..<700:
            return .snow
        case 700..<800:
            return .atmosphere
        case 800:
            return .sunny
        case 801..<900:
            return .cloudy

        default:
            return .sunny
        }
    }

    var imageName: String {
        switch self {
        case .cloudy, .atmosphere:
            return "cloudy"
        case .rainy, .thunderstorm, .drizle, .snow:
            return "rainy"
        case .sunny:
            return "sunny"
        }
    }

    /* Note: I am intentionally ignoring a number of conditions for simplicity and lack of designs to only concentrate on 3 conditions */
    var colorName: String {
        switch self {
        case .cloudy, .atmosphere:
            return "cloudyColor"
        case .rainy, .thunderstorm, .drizle, .snow:
            return "rainyColor"
        case .sunny:
            return "sunnyColor"
        }
    }

    var iconName: String {
        switch self {
        case .thunderstorm:
            return "thunderstormIcon"
        case .drizle:
            return "drizzleIcon"
        case .rainy:
            return "rainIcon"
        case .snow:
            return "snowIcon"
        case .atmosphere:
            return "mistIcon"
        case .sunny:
            return "clearIcon"
        case .cloudy:
            return "scatteredCloudsIcon"
        }
    }
}

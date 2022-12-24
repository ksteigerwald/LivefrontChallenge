import SwiftUI

public extension Color {
    /// Namespace to prevent naming collisions with static accessors on
    /// SwiftUI's Color.
    ///
    /// Xcode's autocomplete allows for easy discovery of design system colors.
    /// At any call site that requires a color, type `Color.DesignSystem.<esc>`
    struct DesignSystem {
        public static let primary100 = Color(red: 0.7883830666542053, green: 0.8407424688339233, blue: 0.9529411792755127, opacity: 1)
        public static let primary200 = Color(red: 0.5176470875740051, green: 0.5843137502670288, blue: 0.7254902124404907, opacity: 1)
        public static let primary300 = Color(red: 0.2980392277240753, green: 0.3607843220233917, blue: 0.4941176474094391, opacity: 1)
        public static let primary400 = Color(red: 0.13333334028720856, green: 0.1764705926179886, blue: 0.2666666805744171, opacity: 1)
        public static let primaryBase = Color(red: 0.06666667014360428, green: 0.0941176488995552, blue: 0.15294118225574493, opacity: 1)
        public static let secondary100 = Color(red: 0.9716129302978516, green: 0.9883871078491211, blue: 0.9870967864990234, opacity: 1)
        public static let secondary200 = Color(red: 0.7411764860153198, green: 0.8901960849761963, blue: 0.8823529481887817, opacity: 1)
        public static let secondary300 = Color(red: 0.6549019813537598, green: 0.8509804010391235, blue: 0.843137264251709, opacity: 1)
        public static let secondary400 = Color(red: 0.48627451062202454, green: 0.7803921699523926, blue: 0.7686274647712708, opacity: 1)
        public static let secondaryBase = Color(red: 0.1411764770746231, green: 0.6313725709915161, blue: 0.6117647290229797, opacity: 1)
        public static let alertsErrorLight = Color(red: 1, green: 0.4431372582912445, blue: 0.4431372582912445, opacity: 1)
        public static let alertsErrorBase = Color(red: 1, green: 0.27843138575553894, blue: 0.27843138575553894, opacity: 1)
        public static let alertsErrorDark = Color(red: 0.8666666746139526, green: 0.20000000298023224, blue: 0.20000000298023224, opacity: 1)
        public static let alertsWarningLight = Color(red: 0.9921568632125854, green: 0.8784313797950745, blue: 0.27843138575553894, opacity: 1)
        public static let alertsWarningBase = Color(red: 0.9803921580314636, green: 0.800000011920929, blue: 0.08235294371843338, opacity: 1)
        public static let alertsWarningDark = Color(red: 0.9176470637321472, green: 0.7019608020782471, blue: 0.0313725508749485, opacity: 1)
        public static let alertsSuccessLight = Color(red: 0.29019609093666077, green: 0.8705882430076599, blue: 0.501960813999176, opacity: 1)
        public static let alertsSuccessBase = Color(red: 0.13333334028720856, green: 0.772549033164978, blue: 0.3686274588108063, opacity: 1)
        public static let alertsSuccessDark = Color(red: 0.08627451211214066, green: 0.6392157077789307, blue: 0.29019609093666077, opacity: 1)
        public static let othersAmber = Color(red: 0.9882352948188782, green: 0.8274509906768799, blue: 0.3019607961177826, opacity: 1)
        public static let othersSky = Color(red: 0.21960784494876862, green: 0.7411764860153198, blue: 0.9725490212440491, opacity: 1)
        public static let othersTeal = Color(red: 0.1764705926179886, green: 0.8313725590705872, blue: 0.7490196228027344, opacity: 1)
        public static let othersOrange = Color(red: 0.9843137264251709, green: 0.572549045085907, blue: 0.23529411852359772, opacity: 1)
        public static let othersWhite = Color(red: 1, green: 1, blue: 1, opacity: 1)
        public static let othersCamaron = Color(red: 1, green: 0.501960813999176, blue: 0.572549045085907, opacity: 1)
        public static let othersPortage = Color(red: 0.5333333611488342, green: 0.4941176474094391, blue: 0.9764705896377563, opacity: 1)
        public static let greyscale900 = Color(red: 0.06666667014360428, green: 0.0941176488995552, blue: 0.15294118225574493, opacity: 1)
        public static let greyscale800 = Color(red: 0.12156862765550613, green: 0.16078431904315948, blue: 0.21568627655506134, opacity: 1)
        public static let greyscale700 = Color(red: 0.21568627655506134, green: 0.2549019753932953, blue: 0.3176470696926117, opacity: 1)
        public static let greyscale600 = Color(red: 0.29411765933036804, green: 0.3333333432674408, blue: 0.38823530077934265, opacity: 1)
        public static let greyscale500 = Color(red: 0.41960784792900085, green: 0.4470588266849518, blue: 0.501960813999176, opacity: 1)
        public static let greyscale400 = Color(red: 0.6117647290229797, green: 0.6392157077789307, blue: 0.686274528503418, opacity: 1)
        public static let greyscale300 = Color(red: 0.8196078538894653, green: 0.8352941274642944, blue: 0.8588235378265381, opacity: 1)
        public static let greyscale200 = Color(red: 0.8980392217636108, green: 0.9058823585510254, blue: 0.9215686321258545, opacity: 1)
        public static let greyscale100 = Color(red: 0.9529411792755127, green: 0.95686274766922, blue: 0.9647058844566345, opacity: 1)
        public static let greyscale50 = Color(red: 0.9764705896377563, green: 0.9803921580314636, blue: 0.9843137264251709, opacity: 1)
    }
}


import SwiftUI

public extension Font {
    /// Namespace to prevent naming collisions with static accessors on
    /// SwiftUI's Font.
    ///
    /// Xcode's autocomplete allows for easy discovery of design system fonts.
    /// At any call site that requires a font, type `Font.DesignSystem.<esc>`
    struct DesignSystem {
        public static let display1 = Font.custom("LibreBaskerville-Bold", size: 48)
        public static let display2 = Font.custom("LibreBaskerville-Bold", size: 40)
        public static let headingH1 = Font.custom("LibreBaskerville-Bold", size: 32)
        public static let headingH2 = Font.custom("LibreBaskerville-Bold", size: 24)
        public static let headingH3 = Font.custom("LibreBaskerville-Bold", size: 20)
        public static let headingH4 = Font.custom("LibreBaskerville-Bold", size: 18)
        public static let bodyXlargeRegular = Font.system(size: 18, weight: .regular, design: .default)
        public static let bodyXlargeMedium = Font.system(size: 18, weight: .medium, design: .default)
        public static let bodyXlargeSemibold = Font.system(size: 18, weight: .semibold, design: .default)
        public static let bodyXlargeBold = Font.system(size: 18, weight: .bold, design: .default)
        public static let headingH5 = Font.custom("LibreBaskerville-Bold", size: 16)
        public static let bodyLargeRegular = Font.system(size: 16, weight: .regular, design: .default)
        public static let bodyLargeMedium = Font.system(size: 16, weight: .medium, design: .default)
        public static let bodyLargeSemibold = Font.system(size: 16, weight: .semibold, design: .default)
        public static let bodyLargeBold = Font.system(size: 16, weight: .bold, design: .default)
        public static let headingH6 = Font.custom("LibreBaskerville-Bold", size: 14)
        public static let bodyMediumRegular = Font.system(size: 14, weight: .regular, design: .default)
        public static let bodyMediumMedium = Font.system(size: 14, weight: .medium, design: .default)
        public static let bodyMediumSemibold = Font.system(size: 14, weight: .semibold, design: .default)
        public static let bodyMediumBold = Font.system(size: 14, weight: .bold, design: .default)
        public static let bodySmallRegular = Font.system(size: 12, weight: .regular, design: .default)
        public static let bodySmallMedium = Font.system(size: 12, weight: .medium, design: .default)
        public static let bodySmallSemibold = Font.system(size: 12, weight: .semibold, design: .default)
        public static let bodySmallBold = Font.system(size: 12, weight: .bold, design: .default)
        public static let bodyXsmallRegular = Font.system(size: 10, weight: .regular, design: .default)
        public static let bodyXsmallMedium = Font.system(size: 10, weight: .medium, design: .default)
        public static let bodyXsmallSemibold = Font.system(size: 10, weight: .semibold, design: .default)
        public static let bodyXsmallBold = Font.system(size: 10, weight: .bold, design: .default)
    }
}

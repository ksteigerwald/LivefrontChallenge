import SwiftUI
    
public struct Spacing {
    /// Namespace to prevent naming collisions.
    ///
    /// Xcode's autocomplete allows for easy discovery of design system spacing.
    /// At any call site that requires spacing, type `Spacing.DesignSystem.<esc>`
    public struct DesignSystem {
    }
}

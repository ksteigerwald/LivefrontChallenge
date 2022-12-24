import SwiftUI

public struct Effect {
    /// Namespace to prevent naming collisions.
    ///
    /// Xcode's autocomplete allows for easy discovery of design system effects.
    /// At any call site that requires an effect, type `Effect.DesignSystem.<esc>`
    public struct DesignSystem {

    }
}

public extension View {
}
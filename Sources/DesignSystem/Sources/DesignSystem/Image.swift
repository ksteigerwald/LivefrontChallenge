import Foundation
import SwiftUI

public extension Image {
    /// Namespace to prevent naming collisions with static accessors on
    /// SwiftUI's Image.
    ///
    /// Xcode's autocomplete allows for easy discovery of design system images.
    /// At any call site that requires an image, type `Image.DesignSystem.<esc>`
    struct DesignSystem {
        public static let spePlaceholder = loadImageFromBundle(name: "spePlaceholder")
    }
}


/// Loads an image from the DesignSystem module. The image is assumed to be in
/// pdf format.
///
/// - Parameter name: The name of the image to load
/// - Returns: If the named image is found in the DesignSystem module, it is
///            returned. Otherwise, a questionmark image is returned as a
///            placeholder.
private func loadImageFromBundle(name: String) -> Image {
    guard let pdfURL = Bundle.module.url(forResource: name, withExtension: "pdf"),
          let pdfImage = pdfImage(fromURL: pdfURL)
    else { return Image(systemName: "questionmark.square") }
    return Image(uiImage: pdfImage).renderingMode(.original)
}

/// Given a URL to a pdf on disk, returns a rendered UIImage of the pdf.
///
/// - Parameter fromURL: The URL that the pdf resides at
/// - Returns: A UIImage representation of the PDF
///
/// [Implementation source](https://www.hackingwithswift.com/example-code/core-graphics/how-to-render-a-pdf-to-an-image)
private func pdfImage(fromURL url: URL) -> UIImage? {
    guard let document = CGPDFDocument(url as CFURL) else { return nil }
    guard let page = document.page(at: 1) else { return nil }

    let pageRect = page.getBoxRect(.mediaBox)
    let renderer = UIGraphicsImageRenderer(size: pageRect.size)
    let image = renderer.image { context in
        context.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
        context.cgContext.scaleBy(x: 1.0, y: -1.0)
        context.cgContext.drawPDFPage(page)
    }

    return image
}

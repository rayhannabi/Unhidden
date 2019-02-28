// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSFont
  internal typealias Font = NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
  internal typealias Font = UIFont
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum FontFamily {
  internal enum Metropolis {
    internal static let black = FontConvertible(name: "Metropolis-Black", family: "Metropolis", path: "Metropolis-Black.otf")
    internal static let blackItalic = FontConvertible(name: "Metropolis-BlackItalic", family: "Metropolis", path: "Metropolis-BlackItalic.otf")
    internal static let bold = FontConvertible(name: "Metropolis-Bold", family: "Metropolis", path: "Metropolis-Bold.otf")
    internal static let boldItalic = FontConvertible(name: "Metropolis-BoldItalic", family: "Metropolis", path: "Metropolis-BoldItalic.otf")
    internal static let extraBold = FontConvertible(name: "Metropolis-ExtraBold", family: "Metropolis", path: "Metropolis-ExtraBold.otf")
    internal static let extraBoldItalic = FontConvertible(name: "Metropolis-ExtraBoldItalic", family: "Metropolis", path: "Metropolis-ExtraBoldItalic.otf")
    internal static let extraLight = FontConvertible(name: "Metropolis-ExtraLight", family: "Metropolis", path: "Metropolis-ExtraLight.otf")
    internal static let extraLightItalic = FontConvertible(name: "Metropolis-ExtraLightItalic", family: "Metropolis", path: "Metropolis-ExtraLightItalic.otf")
    internal static let light = FontConvertible(name: "Metropolis-Light", family: "Metropolis", path: "Metropolis-Light.otf")
    internal static let lightItalic = FontConvertible(name: "Metropolis-LightItalic", family: "Metropolis", path: "Metropolis-LightItalic.otf")
    internal static let medium = FontConvertible(name: "Metropolis-Medium", family: "Metropolis", path: "Metropolis-Medium.otf")
    internal static let mediumItalic = FontConvertible(name: "Metropolis-MediumItalic", family: "Metropolis", path: "Metropolis-MediumItalic.otf")
    internal static let regular = FontConvertible(name: "Metropolis-Regular", family: "Metropolis", path: "Metropolis-Regular.otf")
    internal static let regularItalic = FontConvertible(name: "Metropolis-RegularItalic", family: "Metropolis", path: "Metropolis-RegularItalic.otf")
    internal static let semiBold = FontConvertible(name: "Metropolis-SemiBold", family: "Metropolis", path: "Metropolis-SemiBold.otf")
    internal static let semiBoldItalic = FontConvertible(name: "Metropolis-SemiBoldItalic", family: "Metropolis", path: "Metropolis-SemiBoldItalic.otf")
    internal static let thin = FontConvertible(name: "Metropolis-Thin", family: "Metropolis", path: "Metropolis-Thin.otf")
    internal static let thinItalic = FontConvertible(name: "Metropolis-ThinItalic", family: "Metropolis", path: "Metropolis-ThinItalic.otf")
    internal static let all: [FontConvertible] = [black, blackItalic, bold, boldItalic, extraBold, extraBoldItalic, extraLight, extraLightItalic, light, lightItalic, medium, mediumItalic, regular, regularItalic, semiBold, semiBoldItalic, thin, thinItalic]
  }
  internal static let allCustomFonts: [FontConvertible] = [Metropolis.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  internal func font(size: CGFloat) -> Font! {
    return Font(font: self, size: size)
  }

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    let bundle = Bundle(for: BundleToken.self)
    return bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension Font {
  convenience init!(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(OSX)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}

private final class BundleToken {}

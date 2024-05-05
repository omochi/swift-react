public struct Style: Hashable & RawRepresentable & CustomStringConvertible {
    public typealias RawValue = [String: String]

    public init(rawValue: [String: String]) {
        self.rawValue = rawValue
    }

    public var rawValue: [String: String]

    public init(_ value: [String: String]) {
        self.rawValue = value
    }

    public subscript(name: String) -> String? {
        get { rawValue[name] }
        set { rawValue[name] = newValue }
    }

    public var keys: some Collection<String> {
        rawValue.keys
    }

    public func set(_ name: String, to value: String) -> Style {
        var copy = self
        copy[name] = value
        return copy
    }

    public mutating func merge(_ other: Style) {
        rawValue.merge(other.rawValue) { $1 }
    }

    public var description: String {
        let keys = self.keys.sorted()
        let lines: [String] = keys.map { (key) in
            let value = self[key]!
            return "\(key): \(value);"
        }
        return lines.joined(separator: "\n")
    }
}

extension Style: ExpressibleByDictionaryLiteral {
    public typealias Key = String
    public typealias Value = String

    public init(dictionaryLiteral: (Key, Value)...) {
        let value = Dictionary(uniqueKeysWithValues: dictionaryLiteral)
        self.init(value)
    }
}

extension Style: Sequence {
    public typealias Element = (key: Key, value: Value)

    public func makeIterator() -> some IteratorProtocol<Element> {
        rawValue.makeIterator()
    }
}

extension Style {
    // @codegen(setters)
    public func internalTextAutosizingStatus(_ value: String) -> Style {
        set("-internal-text-autosizing-status", to: value)
    }

    public func accelerator(_ value: String) -> Style {
        set("accelerator", to: value)
    }

    public func accentColor(_ value: String) -> Style {
        set("accent-color", to: value)
    }

    public func wapAccesskey(_ value: String) -> Style {
        set("-wap-accesskey", to: value)
    }

    public func additiveSymbols(_ value: String) -> Style {
        set("additive-symbols", to: value)
    }

    public func alignContent(_ value: String) -> Style {
        set("align-content", to: value)
    }

    public func webkitAlignContent(_ value: String) -> Style {
        set("-webkit-align-content", to: value)
    }

    public func alignItems(_ value: String) -> Style {
        set("align-items", to: value)
    }

    public func webkitAlignItems(_ value: String) -> Style {
        set("-webkit-align-items", to: value)
    }

    public func alignSelf(_ value: String) -> Style {
        set("align-self", to: value)
    }

    public func webkitAlignSelf(_ value: String) -> Style {
        set("-webkit-align-self", to: value)
    }

    public func alignmentBaseline(_ value: String) -> Style {
        set("alignment-baseline", to: value)
    }

    public func all(_ value: String) -> Style {
        set("all", to: value)
    }

    public func alt(_ value: String) -> Style {
        set("alt", to: value)
    }

    public func webkitAlt(_ value: String) -> Style {
        set("-webkit-alt", to: value)
    }

    public func anchorDefault(_ value: String) -> Style {
        set("anchor-default", to: value)
    }

    public func anchorName(_ value: String) -> Style {
        set("anchor-name", to: value)
    }

    public func anchorScroll(_ value: String) -> Style {
        set("anchor-scroll", to: value)
    }

    public func animation(_ value: String) -> Style {
        set("animation", to: value)
    }

    public func animationComposition(_ value: String) -> Style {
        set("animation-composition", to: value)
    }

    public func animationDelay(_ value: String) -> Style {
        set("animation-delay", to: value)
    }

    public func mozAnimationDelay(_ value: String) -> Style {
        set("-moz-animation-delay", to: value)
    }

    public func msAnimationDelay(_ value: String) -> Style {
        set("-ms-animation-delay", to: value)
    }

    public func webkitAnimationDelay(_ value: String) -> Style {
        set("-webkit-animation-delay", to: value)
    }

    public func animationDirection(_ value: String) -> Style {
        set("animation-direction", to: value)
    }

    public func mozAnimationDirection(_ value: String) -> Style {
        set("-moz-animation-direction", to: value)
    }

    public func msAnimationDirection(_ value: String) -> Style {
        set("-ms-animation-direction", to: value)
    }

    public func webkitAnimationDirection(_ value: String) -> Style {
        set("-webkit-animation-direction", to: value)
    }

    public func animationDuration(_ value: String) -> Style {
        set("animation-duration", to: value)
    }

    public func mozAnimationDuration(_ value: String) -> Style {
        set("-moz-animation-duration", to: value)
    }

    public func msAnimationDuration(_ value: String) -> Style {
        set("-ms-animation-duration", to: value)
    }

    public func webkitAnimationDuration(_ value: String) -> Style {
        set("-webkit-animation-duration", to: value)
    }

    public func animationFillMode(_ value: String) -> Style {
        set("animation-fill-mode", to: value)
    }

    public func mozAnimationFillMode(_ value: String) -> Style {
        set("-moz-animation-fill-mode", to: value)
    }

    public func msAnimationFillMode(_ value: String) -> Style {
        set("-ms-animation-fill-mode", to: value)
    }

    public func webkitAnimationFillMode(_ value: String) -> Style {
        set("-webkit-animation-fill-mode", to: value)
    }

    public func animationIterationCount(_ value: String) -> Style {
        set("animation-iteration-count", to: value)
    }

    public func mozAnimationIterationCount(_ value: String) -> Style {
        set("-moz-animation-iteration-count", to: value)
    }

    public func msAnimationIterationCount(_ value: String) -> Style {
        set("-ms-animation-iteration-count", to: value)
    }

    public func webkitAnimationIterationCount(_ value: String) -> Style {
        set("-webkit-animation-iteration-count", to: value)
    }

    public func mozAnimation(_ value: String) -> Style {
        set("-moz-animation", to: value)
    }

    public func msAnimation(_ value: String) -> Style {
        set("-ms-animation", to: value)
    }

    public func animationName(_ value: String) -> Style {
        set("animation-name", to: value)
    }

    public func mozAnimationName(_ value: String) -> Style {
        set("-moz-animation-name", to: value)
    }

    public func msAnimationName(_ value: String) -> Style {
        set("-ms-animation-name", to: value)
    }

    public func webkitAnimationName(_ value: String) -> Style {
        set("-webkit-animation-name", to: value)
    }

    public func animationPlayState(_ value: String) -> Style {
        set("animation-play-state", to: value)
    }

    public func mozAnimationPlayState(_ value: String) -> Style {
        set("-moz-animation-play-state", to: value)
    }

    public func msAnimationPlayState(_ value: String) -> Style {
        set("-ms-animation-play-state", to: value)
    }

    public func webkitAnimationPlayState(_ value: String) -> Style {
        set("-webkit-animation-play-state", to: value)
    }

    public func animationRange(_ value: String) -> Style {
        set("animation-range", to: value)
    }

    public func animationRangeEnd(_ value: String) -> Style {
        set("animation-range-end", to: value)
    }

    public func animationRangeStart(_ value: String) -> Style {
        set("animation-range-start", to: value)
    }

    public func animationTimeline(_ value: String) -> Style {
        set("animation-timeline", to: value)
    }

    public func animationTimingFunction(_ value: String) -> Style {
        set("animation-timing-function", to: value)
    }

    public func mozAnimationTimingFunction(_ value: String) -> Style {
        set("-moz-animation-timing-function", to: value)
    }

    public func msAnimationTimingFunction(_ value: String) -> Style {
        set("-ms-animation-timing-function", to: value)
    }

    public func webkitAnimationTimingFunction(_ value: String) -> Style {
        set("-webkit-animation-timing-function", to: value)
    }

    public func webkitAnimationTrigger(_ value: String) -> Style {
        set("-webkit-animation-trigger", to: value)
    }

    public func webkitAnimation(_ value: String) -> Style {
        set("-webkit-animation", to: value)
    }

    public func appRegion(_ value: String) -> Style {
        set("app-region", to: value)
    }

    public func webkitAppRegion(_ value: String) -> Style {
        set("-webkit-app-region", to: value)
    }

    public func appearance(_ value: String) -> Style {
        set("appearance", to: value)
    }

    public func mozAppearance(_ value: String) -> Style {
        set("-moz-appearance", to: value)
    }

    public func webkitAppearance(_ value: String) -> Style {
        set("-webkit-appearance", to: value)
    }

    public func ascentOverride(_ value: String) -> Style {
        set("ascent-override", to: value)
    }

    public func aspectRatio(_ value: String) -> Style {
        set("aspect-ratio", to: value)
    }

    public func webkitAspectRatio(_ value: String) -> Style {
        set("-webkit-aspect-ratio", to: value)
    }

    public func audioLevel(_ value: String) -> Style {
        set("audio-level", to: value)
    }

    public func azimuth(_ value: String) -> Style {
        set("azimuth", to: value)
    }

    public func backdropFilter(_ value: String) -> Style {
        set("backdrop-filter", to: value)
    }

    public func webkitBackdropFilter(_ value: String) -> Style {
        set("-webkit-backdrop-filter", to: value)
    }

    public func backfaceVisibility(_ value: String) -> Style {
        set("backface-visibility", to: value)
    }

    public func mozBackfaceVisibility(_ value: String) -> Style {
        set("-moz-backface-visibility", to: value)
    }

    public func msBackfaceVisibility(_ value: String) -> Style {
        set("-ms-backface-visibility", to: value)
    }

    public func webkitBackfaceVisibility(_ value: String) -> Style {
        set("-webkit-backface-visibility", to: value)
    }

    public func background(_ value: String) -> Style {
        set("background", to: value)
    }

    public func backgroundAttachment(_ value: String) -> Style {
        set("background-attachment", to: value)
    }

    public func webkitBackgroundAttachment(_ value: String) -> Style {
        set("-webkit-background-attachment", to: value)
    }

    public func backgroundBlendMode(_ value: String) -> Style {
        set("background-blend-mode", to: value)
    }

    public func backgroundClip(_ value: String) -> Style {
        set("background-clip", to: value)
    }

    public func mozBackgroundClip(_ value: String) -> Style {
        set("-moz-background-clip", to: value)
    }

    public func webkitBackgroundClip(_ value: String) -> Style {
        set("-webkit-background-clip", to: value)
    }

    public func backgroundColor(_ value: String) -> Style {
        set("background-color", to: value)
    }

    public func webkitBackgroundColor(_ value: String) -> Style {
        set("-webkit-background-color", to: value)
    }

    public func webkitBackgroundComposite(_ value: String) -> Style {
        set("-webkit-background-composite", to: value)
    }

    public func backgroundImage(_ value: String) -> Style {
        set("background-image", to: value)
    }

    public func webkitBackgroundImage(_ value: String) -> Style {
        set("-webkit-background-image", to: value)
    }

    public func mozBackgroundInlinePolicy(_ value: String) -> Style {
        set("-moz-background-inline-policy", to: value)
    }

    public func backgroundOrigin(_ value: String) -> Style {
        set("background-origin", to: value)
    }

    public func mozBackgroundOrigin(_ value: String) -> Style {
        set("-moz-background-origin", to: value)
    }

    public func webkitBackgroundOrigin(_ value: String) -> Style {
        set("-webkit-background-origin", to: value)
    }

    public func backgroundPosition(_ value: String) -> Style {
        set("background-position", to: value)
    }

    public func webkitBackgroundPosition(_ value: String) -> Style {
        set("-webkit-background-position", to: value)
    }

    public func backgroundPositionX(_ value: String) -> Style {
        set("background-position-x", to: value)
    }

    public func webkitBackgroundPositionX(_ value: String) -> Style {
        set("-webkit-background-position-x", to: value)
    }

    public func backgroundPositionY(_ value: String) -> Style {
        set("background-position-y", to: value)
    }

    public func webkitBackgroundPositionY(_ value: String) -> Style {
        set("-webkit-background-position-y", to: value)
    }

    public func backgroundRepeat(_ value: String) -> Style {
        set("background-repeat", to: value)
    }

    public func webkitBackgroundRepeat(_ value: String) -> Style {
        set("-webkit-background-repeat", to: value)
    }

    public func backgroundRepeatX(_ value: String) -> Style {
        set("background-repeat-x", to: value)
    }

    public func backgroundRepeatY(_ value: String) -> Style {
        set("background-repeat-y", to: value)
    }

    public func backgroundSize(_ value: String) -> Style {
        set("background-size", to: value)
    }

    public func mozBackgroundSize(_ value: String) -> Style {
        set("-moz-background-size", to: value)
    }

    public func webkitBackgroundSize(_ value: String) -> Style {
        set("-webkit-background-size", to: value)
    }

    public func webkitBackground(_ value: String) -> Style {
        set("-webkit-background", to: value)
    }

    public func basePalette(_ value: String) -> Style {
        set("base-palette", to: value)
    }

    public func baselineShift(_ value: String) -> Style {
        set("baseline-shift", to: value)
    }

    public func baselineSource(_ value: String) -> Style {
        set("baseline-source", to: value)
    }

    public func behavior(_ value: String) -> Style {
        set("behavior", to: value)
    }

    public func mozBinding(_ value: String) -> Style {
        set("-moz-binding", to: value)
    }

    public func blockEllipsis(_ value: String) -> Style {
        set("block-ellipsis", to: value)
    }

    public func msBlockProgression(_ value: String) -> Style {
        set("-ms-block-progression", to: value)
    }

    public func blockSize(_ value: String) -> Style {
        set("block-size", to: value)
    }

    public func blockStep(_ value: String) -> Style {
        set("block-step", to: value)
    }

    public func blockStepAlign(_ value: String) -> Style {
        set("block-step-align", to: value)
    }

    public func blockStepInsert(_ value: String) -> Style {
        set("block-step-insert", to: value)
    }

    public func blockStepRound(_ value: String) -> Style {
        set("block-step-round", to: value)
    }

    public func blockStepSize(_ value: String) -> Style {
        set("block-step-size", to: value)
    }

    public func bookmarkLabel(_ value: String) -> Style {
        set("bookmark-label", to: value)
    }

    public func bookmarkLevel(_ value: String) -> Style {
        set("bookmark-level", to: value)
    }

    public func bookmarkState(_ value: String) -> Style {
        set("bookmark-state", to: value)
    }

    public func border(_ value: String) -> Style {
        set("border", to: value)
    }

    public func webkitBorderAfterColor(_ value: String) -> Style {
        set("-webkit-border-after-color", to: value)
    }

    public func webkitBorderAfterStyle(_ value: String) -> Style {
        set("-webkit-border-after-style", to: value)
    }

    public func webkitBorderAfter(_ value: String) -> Style {
        set("-webkit-border-after", to: value)
    }

    public func webkitBorderAfterWidth(_ value: String) -> Style {
        set("-webkit-border-after-width", to: value)
    }

    public func webkitBorderBeforeColor(_ value: String) -> Style {
        set("-webkit-border-before-color", to: value)
    }

    public func webkitBorderBeforeStyle(_ value: String) -> Style {
        set("-webkit-border-before-style", to: value)
    }

    public func webkitBorderBefore(_ value: String) -> Style {
        set("-webkit-border-before", to: value)
    }

    public func webkitBorderBeforeWidth(_ value: String) -> Style {
        set("-webkit-border-before-width", to: value)
    }

    public func borderBlock(_ value: String) -> Style {
        set("border-block", to: value)
    }

    public func borderBlockColor(_ value: String) -> Style {
        set("border-block-color", to: value)
    }

    public func borderBlockEnd(_ value: String) -> Style {
        set("border-block-end", to: value)
    }

    public func borderBlockEndColor(_ value: String) -> Style {
        set("border-block-end-color", to: value)
    }

    public func borderBlockEndStyle(_ value: String) -> Style {
        set("border-block-end-style", to: value)
    }

    public func borderBlockEndWidth(_ value: String) -> Style {
        set("border-block-end-width", to: value)
    }

    public func borderBlockStart(_ value: String) -> Style {
        set("border-block-start", to: value)
    }

    public func borderBlockStartColor(_ value: String) -> Style {
        set("border-block-start-color", to: value)
    }

    public func borderBlockStartStyle(_ value: String) -> Style {
        set("border-block-start-style", to: value)
    }

    public func borderBlockStartWidth(_ value: String) -> Style {
        set("border-block-start-width", to: value)
    }

    public func borderBlockStyle(_ value: String) -> Style {
        set("border-block-style", to: value)
    }

    public func borderBlockWidth(_ value: String) -> Style {
        set("border-block-width", to: value)
    }

    public func borderBottom(_ value: String) -> Style {
        set("border-bottom", to: value)
    }

    public func borderBottomColor(_ value: String) -> Style {
        set("border-bottom-color", to: value)
    }

    public func mozBorderBottomColors(_ value: String) -> Style {
        set("-moz-border-bottom-colors", to: value)
    }

    public func borderBottomLeftRadius(_ value: String) -> Style {
        set("border-bottom-left-radius", to: value)
    }

    public func webkitBorderBottomLeftRadius(_ value: String) -> Style {
        set("-webkit-border-bottom-left-radius", to: value)
    }

    public func borderBottomRightRadius(_ value: String) -> Style {
        set("border-bottom-right-radius", to: value)
    }

    public func webkitBorderBottomRightRadius(_ value: String) -> Style {
        set("-webkit-border-bottom-right-radius", to: value)
    }

    public func borderBottomStyle(_ value: String) -> Style {
        set("border-bottom-style", to: value)
    }

    public func borderBottomWidth(_ value: String) -> Style {
        set("border-bottom-width", to: value)
    }

    public func borderBoundary(_ value: String) -> Style {
        set("border-boundary", to: value)
    }

    public func borderCollapse(_ value: String) -> Style {
        set("border-collapse", to: value)
    }

    public func borderColor(_ value: String) -> Style {
        set("border-color", to: value)
    }

    public func mozBorderEndColor(_ value: String) -> Style {
        set("-moz-border-end-color", to: value)
    }

    public func webkitBorderEndColor(_ value: String) -> Style {
        set("-webkit-border-end-color", to: value)
    }

    public func borderEndEndRadius(_ value: String) -> Style {
        set("border-end-end-radius", to: value)
    }

    public func mozBorderEnd(_ value: String) -> Style {
        set("-moz-border-end", to: value)
    }

    public func borderEndStartRadius(_ value: String) -> Style {
        set("border-end-start-radius", to: value)
    }

    public func mozBorderEndStyle(_ value: String) -> Style {
        set("-moz-border-end-style", to: value)
    }

    public func webkitBorderEndStyle(_ value: String) -> Style {
        set("-webkit-border-end-style", to: value)
    }

    public func webkitBorderEnd(_ value: String) -> Style {
        set("-webkit-border-end", to: value)
    }

    public func mozBorderEndWidth(_ value: String) -> Style {
        set("-moz-border-end-width", to: value)
    }

    public func webkitBorderEndWidth(_ value: String) -> Style {
        set("-webkit-border-end-width", to: value)
    }

    public func webkitBorderFit(_ value: String) -> Style {
        set("-webkit-border-fit", to: value)
    }

    public func webkitBorderHorizontalSpacing(_ value: String) -> Style {
        set("-webkit-border-horizontal-spacing", to: value)
    }

    public func borderImage(_ value: String) -> Style {
        set("border-image", to: value)
    }

    public func mozBorderImage(_ value: String) -> Style {
        set("-moz-border-image", to: value)
    }

    public func oBorderImage(_ value: String) -> Style {
        set("-o-border-image", to: value)
    }

    public func borderImageOutset(_ value: String) -> Style {
        set("border-image-outset", to: value)
    }

    public func webkitBorderImageOutset(_ value: String) -> Style {
        set("-webkit-border-image-outset", to: value)
    }

    public func borderImageRepeat(_ value: String) -> Style {
        set("border-image-repeat", to: value)
    }

    public func webkitBorderImageRepeat(_ value: String) -> Style {
        set("-webkit-border-image-repeat", to: value)
    }

    public func borderImageSlice(_ value: String) -> Style {
        set("border-image-slice", to: value)
    }

    public func webkitBorderImageSlice(_ value: String) -> Style {
        set("-webkit-border-image-slice", to: value)
    }

    public func borderImageSource(_ value: String) -> Style {
        set("border-image-source", to: value)
    }

    public func webkitBorderImageSource(_ value: String) -> Style {
        set("-webkit-border-image-source", to: value)
    }

    public func webkitBorderImage(_ value: String) -> Style {
        set("-webkit-border-image", to: value)
    }

    public func borderImageWidth(_ value: String) -> Style {
        set("border-image-width", to: value)
    }

    public func webkitBorderImageWidth(_ value: String) -> Style {
        set("-webkit-border-image-width", to: value)
    }

    public func borderInline(_ value: String) -> Style {
        set("border-inline", to: value)
    }

    public func borderInlineColor(_ value: String) -> Style {
        set("border-inline-color", to: value)
    }

    public func borderInlineEnd(_ value: String) -> Style {
        set("border-inline-end", to: value)
    }

    public func borderInlineEndColor(_ value: String) -> Style {
        set("border-inline-end-color", to: value)
    }

    public func borderInlineEndStyle(_ value: String) -> Style {
        set("border-inline-end-style", to: value)
    }

    public func borderInlineEndWidth(_ value: String) -> Style {
        set("border-inline-end-width", to: value)
    }

    public func borderInlineStart(_ value: String) -> Style {
        set("border-inline-start", to: value)
    }

    public func borderInlineStartColor(_ value: String) -> Style {
        set("border-inline-start-color", to: value)
    }

    public func borderInlineStartStyle(_ value: String) -> Style {
        set("border-inline-start-style", to: value)
    }

    public func borderInlineStartWidth(_ value: String) -> Style {
        set("border-inline-start-width", to: value)
    }

    public func borderInlineStyle(_ value: String) -> Style {
        set("border-inline-style", to: value)
    }

    public func borderInlineWidth(_ value: String) -> Style {
        set("border-inline-width", to: value)
    }

    public func borderLeft(_ value: String) -> Style {
        set("border-left", to: value)
    }

    public func borderLeftColor(_ value: String) -> Style {
        set("border-left-color", to: value)
    }

    public func mozBorderLeftColors(_ value: String) -> Style {
        set("-moz-border-left-colors", to: value)
    }

    public func borderLeftStyle(_ value: String) -> Style {
        set("border-left-style", to: value)
    }

    public func borderLeftWidth(_ value: String) -> Style {
        set("border-left-width", to: value)
    }

    public func borderRadius(_ value: String) -> Style {
        set("border-radius", to: value)
    }

    public func mozBorderRadiusBottomleft(_ value: String) -> Style {
        set("-moz-border-radius-bottomleft", to: value)
    }

    public func mozBorderRadiusBottomright(_ value: String) -> Style {
        set("-moz-border-radius-bottomright", to: value)
    }

    public func mozBorderRadius(_ value: String) -> Style {
        set("-moz-border-radius", to: value)
    }

    public func mozBorderRadiusTopleft(_ value: String) -> Style {
        set("-moz-border-radius-topleft", to: value)
    }

    public func mozBorderRadiusTopright(_ value: String) -> Style {
        set("-moz-border-radius-topright", to: value)
    }

    public func webkitBorderRadius(_ value: String) -> Style {
        set("-webkit-border-radius", to: value)
    }

    public func borderRight(_ value: String) -> Style {
        set("border-right", to: value)
    }

    public func borderRightColor(_ value: String) -> Style {
        set("border-right-color", to: value)
    }

    public func mozBorderRightColors(_ value: String) -> Style {
        set("-moz-border-right-colors", to: value)
    }

    public func borderRightStyle(_ value: String) -> Style {
        set("border-right-style", to: value)
    }

    public func borderRightWidth(_ value: String) -> Style {
        set("border-right-width", to: value)
    }

    public func borderSpacing(_ value: String) -> Style {
        set("border-spacing", to: value)
    }

    public func mozBorderStartColor(_ value: String) -> Style {
        set("-moz-border-start-color", to: value)
    }

    public func webkitBorderStartColor(_ value: String) -> Style {
        set("-webkit-border-start-color", to: value)
    }

    public func borderStartEndRadius(_ value: String) -> Style {
        set("border-start-end-radius", to: value)
    }

    public func mozBorderStart(_ value: String) -> Style {
        set("-moz-border-start", to: value)
    }

    public func borderStartStartRadius(_ value: String) -> Style {
        set("border-start-start-radius", to: value)
    }

    public func mozBorderStartStyle(_ value: String) -> Style {
        set("-moz-border-start-style", to: value)
    }

    public func webkitBorderStartStyle(_ value: String) -> Style {
        set("-webkit-border-start-style", to: value)
    }

    public func webkitBorderStart(_ value: String) -> Style {
        set("-webkit-border-start", to: value)
    }

    public func mozBorderStartWidth(_ value: String) -> Style {
        set("-moz-border-start-width", to: value)
    }

    public func webkitBorderStartWidth(_ value: String) -> Style {
        set("-webkit-border-start-width", to: value)
    }

    public func borderStyle(_ value: String) -> Style {
        set("border-style", to: value)
    }

    public func borderTop(_ value: String) -> Style {
        set("border-top", to: value)
    }

    public func borderTopColor(_ value: String) -> Style {
        set("border-top-color", to: value)
    }

    public func mozBorderTopColors(_ value: String) -> Style {
        set("-moz-border-top-colors", to: value)
    }

    public func borderTopLeftRadius(_ value: String) -> Style {
        set("border-top-left-radius", to: value)
    }

    public func webkitBorderTopLeftRadius(_ value: String) -> Style {
        set("-webkit-border-top-left-radius", to: value)
    }

    public func borderTopRightRadius(_ value: String) -> Style {
        set("border-top-right-radius", to: value)
    }

    public func webkitBorderTopRightRadius(_ value: String) -> Style {
        set("-webkit-border-top-right-radius", to: value)
    }

    public func borderTopStyle(_ value: String) -> Style {
        set("border-top-style", to: value)
    }

    public func borderTopWidth(_ value: String) -> Style {
        set("border-top-width", to: value)
    }

    public func webkitBorderVerticalSpacing(_ value: String) -> Style {
        set("-webkit-border-vertical-spacing", to: value)
    }

    public func borderWidth(_ value: String) -> Style {
        set("border-width", to: value)
    }

    public func bottom(_ value: String) -> Style {
        set("bottom", to: value)
    }

    public func mozBoxAlign(_ value: String) -> Style {
        set("-moz-box-align", to: value)
    }

    public func webkitBoxAlign(_ value: String) -> Style {
        set("-webkit-box-align", to: value)
    }

    public func boxDecorationBreak(_ value: String) -> Style {
        set("box-decoration-break", to: value)
    }

    public func webkitBoxDecorationBreak(_ value: String) -> Style {
        set("-webkit-box-decoration-break", to: value)
    }

    public func mozBoxDirection(_ value: String) -> Style {
        set("-moz-box-direction", to: value)
    }

    public func webkitBoxDirection(_ value: String) -> Style {
        set("-webkit-box-direction", to: value)
    }

    public func webkitBoxFlexGroup(_ value: String) -> Style {
        set("-webkit-box-flex-group", to: value)
    }

    public func mozBoxFlex(_ value: String) -> Style {
        set("-moz-box-flex", to: value)
    }

    public func webkitBoxFlex(_ value: String) -> Style {
        set("-webkit-box-flex", to: value)
    }

    public func webkitBoxLines(_ value: String) -> Style {
        set("-webkit-box-lines", to: value)
    }

    public func mozBoxOrdinalGroup(_ value: String) -> Style {
        set("-moz-box-ordinal-group", to: value)
    }

    public func webkitBoxOrdinalGroup(_ value: String) -> Style {
        set("-webkit-box-ordinal-group", to: value)
    }

    public func mozBoxOrient(_ value: String) -> Style {
        set("-moz-box-orient", to: value)
    }

    public func webkitBoxOrient(_ value: String) -> Style {
        set("-webkit-box-orient", to: value)
    }

    public func mozBoxPack(_ value: String) -> Style {
        set("-moz-box-pack", to: value)
    }

    public func webkitBoxPack(_ value: String) -> Style {
        set("-webkit-box-pack", to: value)
    }

    public func webkitBoxReflect(_ value: String) -> Style {
        set("-webkit-box-reflect", to: value)
    }

    public func boxShadow(_ value: String) -> Style {
        set("box-shadow", to: value)
    }

    public func mozBoxShadow(_ value: String) -> Style {
        set("-moz-box-shadow", to: value)
    }

    public func webkitBoxShadow(_ value: String) -> Style {
        set("-webkit-box-shadow", to: value)
    }

    public func boxSizing(_ value: String) -> Style {
        set("box-sizing", to: value)
    }

    public func mozBoxSizing(_ value: String) -> Style {
        set("-moz-box-sizing", to: value)
    }

    public func webkitBoxSizing(_ value: String) -> Style {
        set("-webkit-box-sizing", to: value)
    }

    public func boxSnap(_ value: String) -> Style {
        set("box-snap", to: value)
    }

    public func breakAfter(_ value: String) -> Style {
        set("break-after", to: value)
    }

    public func breakBefore(_ value: String) -> Style {
        set("break-before", to: value)
    }

    public func breakInside(_ value: String) -> Style {
        set("break-inside", to: value)
    }

    public func bufferedRendering(_ value: String) -> Style {
        set("buffered-rendering", to: value)
    }

    public func captionSide(_ value: String) -> Style {
        set("caption-side", to: value)
    }

    public func caret(_ value: String) -> Style {
        set("caret", to: value)
    }

    public func caretAnimation(_ value: String) -> Style {
        set("caret-animation", to: value)
    }

    public func caretColor(_ value: String) -> Style {
        set("caret-color", to: value)
    }

    public func caretShape(_ value: String) -> Style {
        set("caret-shape", to: value)
    }

    public func chains(_ value: String) -> Style {
        set("chains", to: value)
    }

    public func clear(_ value: String) -> Style {
        set("clear", to: value)
    }

    public func clip(_ value: String) -> Style {
        set("clip", to: value)
    }

    public func clipPath(_ value: String) -> Style {
        set("clip-path", to: value)
    }

    public func webkitClipPath(_ value: String) -> Style {
        set("-webkit-clip-path", to: value)
    }

    public func clipRule(_ value: String) -> Style {
        set("clip-rule", to: value)
    }

    public func color(_ value: String) -> Style {
        set("color", to: value)
    }

    public func colorAdjust(_ value: String) -> Style {
        set("color-adjust", to: value)
    }

    public func webkitColorCorrection(_ value: String) -> Style {
        set("-webkit-color-correction", to: value)
    }

    public func appleColorFilter(_ value: String) -> Style {
        set("-apple-color-filter", to: value)
    }

    public func colorInterpolation(_ value: String) -> Style {
        set("color-interpolation", to: value)
    }

    public func colorInterpolationFilters(_ value: String) -> Style {
        set("color-interpolation-filters", to: value)
    }

    public func colorProfile(_ value: String) -> Style {
        set("color-profile", to: value)
    }

    public func colorRendering(_ value: String) -> Style {
        set("color-rendering", to: value)
    }

    public func colorScheme(_ value: String) -> Style {
        set("color-scheme", to: value)
    }

    public func webkitColumnAxis(_ value: String) -> Style {
        set("-webkit-column-axis", to: value)
    }

    public func webkitColumnBreakAfter(_ value: String) -> Style {
        set("-webkit-column-break-after", to: value)
    }

    public func webkitColumnBreakBefore(_ value: String) -> Style {
        set("-webkit-column-break-before", to: value)
    }

    public func webkitColumnBreakInside(_ value: String) -> Style {
        set("-webkit-column-break-inside", to: value)
    }

    public func columnCount(_ value: String) -> Style {
        set("column-count", to: value)
    }

    public func mozColumnCount(_ value: String) -> Style {
        set("-moz-column-count", to: value)
    }

    public func webkitColumnCount(_ value: String) -> Style {
        set("-webkit-column-count", to: value)
    }

    public func columnFill(_ value: String) -> Style {
        set("column-fill", to: value)
    }

    public func mozColumnFill(_ value: String) -> Style {
        set("-moz-column-fill", to: value)
    }

    public func webkitColumnFill(_ value: String) -> Style {
        set("-webkit-column-fill", to: value)
    }

    public func columnGap(_ value: String) -> Style {
        set("column-gap", to: value)
    }

    public func mozColumnGap(_ value: String) -> Style {
        set("-moz-column-gap", to: value)
    }

    public func webkitColumnGap(_ value: String) -> Style {
        set("-webkit-column-gap", to: value)
    }

    public func columnProgression(_ value: String) -> Style {
        set("column-progression", to: value)
    }

    public func webkitColumnProgression(_ value: String) -> Style {
        set("-webkit-column-progression", to: value)
    }

    public func columnRule(_ value: String) -> Style {
        set("column-rule", to: value)
    }

    public func columnRuleColor(_ value: String) -> Style {
        set("column-rule-color", to: value)
    }

    public func mozColumnRuleColor(_ value: String) -> Style {
        set("-moz-column-rule-color", to: value)
    }

    public func webkitColumnRuleColor(_ value: String) -> Style {
        set("-webkit-column-rule-color", to: value)
    }

    public func mozColumnRule(_ value: String) -> Style {
        set("-moz-column-rule", to: value)
    }

    public func columnRuleStyle(_ value: String) -> Style {
        set("column-rule-style", to: value)
    }

    public func mozColumnRuleStyle(_ value: String) -> Style {
        set("-moz-column-rule-style", to: value)
    }

    public func webkitColumnRuleStyle(_ value: String) -> Style {
        set("-webkit-column-rule-style", to: value)
    }

    public func webkitColumnRule(_ value: String) -> Style {
        set("-webkit-column-rule", to: value)
    }

    public func columnRuleWidth(_ value: String) -> Style {
        set("column-rule-width", to: value)
    }

    public func mozColumnRuleWidth(_ value: String) -> Style {
        set("-moz-column-rule-width", to: value)
    }

    public func webkitColumnRuleWidth(_ value: String) -> Style {
        set("-webkit-column-rule-width", to: value)
    }

    public func columnSpan(_ value: String) -> Style {
        set("column-span", to: value)
    }

    public func mozColumnSpan(_ value: String) -> Style {
        set("-moz-column-span", to: value)
    }

    public func webkitColumnSpan(_ value: String) -> Style {
        set("-webkit-column-span", to: value)
    }

    public func columnWidth(_ value: String) -> Style {
        set("column-width", to: value)
    }

    public func mozColumnWidth(_ value: String) -> Style {
        set("-moz-column-width", to: value)
    }

    public func webkitColumnWidth(_ value: String) -> Style {
        set("-webkit-column-width", to: value)
    }

    public func columns(_ value: String) -> Style {
        set("columns", to: value)
    }

    public func mozColumns(_ value: String) -> Style {
        set("-moz-columns", to: value)
    }

    public func webkitColumns(_ value: String) -> Style {
        set("-webkit-columns", to: value)
    }

    public func webkitCompositionFillColor(_ value: String) -> Style {
        set("-webkit-composition-fill-color", to: value)
    }

    public func webkitCompositionFrameColor(_ value: String) -> Style {
        set("-webkit-composition-frame-color", to: value)
    }

    public func contain(_ value: String) -> Style {
        set("contain", to: value)
    }

    public func containIntrinsicBlockSize(_ value: String) -> Style {
        set("contain-intrinsic-block-size", to: value)
    }

    public func containIntrinsicHeight(_ value: String) -> Style {
        set("contain-intrinsic-height", to: value)
    }

    public func containIntrinsicInlineSize(_ value: String) -> Style {
        set("contain-intrinsic-inline-size", to: value)
    }

    public func containIntrinsicSize(_ value: String) -> Style {
        set("contain-intrinsic-size", to: value)
    }

    public func containIntrinsicWidth(_ value: String) -> Style {
        set("contain-intrinsic-width", to: value)
    }

    public func container(_ value: String) -> Style {
        set("container", to: value)
    }

    public func containerName(_ value: String) -> Style {
        set("container-name", to: value)
    }

    public func containerType(_ value: String) -> Style {
        set("container-type", to: value)
    }

    public func content(_ value: String) -> Style {
        set("content", to: value)
    }

    public func contentVisibility(_ value: String) -> Style {
        set("content-visibility", to: value)
    }

    public func msContentZoomChaining(_ value: String) -> Style {
        set("-ms-content-zoom-chaining", to: value)
    }

    public func msContentZoomLimitMax(_ value: String) -> Style {
        set("-ms-content-zoom-limit-max", to: value)
    }

    public func msContentZoomLimitMin(_ value: String) -> Style {
        set("-ms-content-zoom-limit-min", to: value)
    }

    public func msContentZoomLimit(_ value: String) -> Style {
        set("-ms-content-zoom-limit", to: value)
    }

    public func msContentZoomSnap(_ value: String) -> Style {
        set("-ms-content-zoom-snap", to: value)
    }

    public func msContentZoomSnapPoints(_ value: String) -> Style {
        set("-ms-content-zoom-snap-points", to: value)
    }

    public func msContentZoomSnapType(_ value: String) -> Style {
        set("-ms-content-zoom-snap-type", to: value)
    }

    public func msContentZooming(_ value: String) -> Style {
        set("-ms-content-zooming", to: value)
    }

    public func `continue`(_ value: String) -> Style {
        set("continue", to: value)
    }

    public func counterIncrement(_ value: String) -> Style {
        set("counter-increment", to: value)
    }

    public func counterReset(_ value: String) -> Style {
        set("counter-reset", to: value)
    }

    public func counterSet(_ value: String) -> Style {
        set("counter-set", to: value)
    }

    public func cue(_ value: String) -> Style {
        set("cue", to: value)
    }

    public func cueAfter(_ value: String) -> Style {
        set("cue-after", to: value)
    }

    public func cueBefore(_ value: String) -> Style {
        set("cue-before", to: value)
    }

    public func cursor(_ value: String) -> Style {
        set("cursor", to: value)
    }

    public func webkitCursorVisibility(_ value: String) -> Style {
        set("-webkit-cursor-visibility", to: value)
    }

    public func cx(_ value: String) -> Style {
        set("cx", to: value)
    }

    public func cy(_ value: String) -> Style {
        set("cy", to: value)
    }

    public func d(_ value: String) -> Style {
        set("d", to: value)
    }

    public func appleDashboardRegion(_ value: String) -> Style {
        set("-apple-dashboard-region", to: value)
    }

    public func webkitDashboardRegion(_ value: String) -> Style {
        set("-webkit-dashboard-region", to: value)
    }

    public func descentOverride(_ value: String) -> Style {
        set("descent-override", to: value)
    }

    public func direction(_ value: String) -> Style {
        set("direction", to: value)
    }

    public func display(_ value: String) -> Style {
        set("display", to: value)
    }

    public func displayAlign(_ value: String) -> Style {
        set("display-align", to: value)
    }

    public func dominantBaseline(_ value: String) -> Style {
        set("dominant-baseline", to: value)
    }

    public func elevation(_ value: String) -> Style {
        set("elevation", to: value)
    }

    public func emptyCells(_ value: String) -> Style {
        set("empty-cells", to: value)
    }

    public func enableBackground(_ value: String) -> Style {
        set("enable-background", to: value)
    }

    public func epubCaptionSide(_ value: String) -> Style {
        set("epub-caption-side", to: value)
    }

    public func epubHyphens(_ value: String) -> Style {
        set("epub-hyphens", to: value)
    }

    public func epubTextCombine(_ value: String) -> Style {
        set("epub-text-combine", to: value)
    }

    public func epubTextEmphasis(_ value: String) -> Style {
        set("epub-text-emphasis", to: value)
    }

    public func epubTextEmphasisColor(_ value: String) -> Style {
        set("epub-text-emphasis-color", to: value)
    }

    public func epubTextEmphasisStyle(_ value: String) -> Style {
        set("epub-text-emphasis-style", to: value)
    }

    public func epubTextOrientation(_ value: String) -> Style {
        set("epub-text-orientation", to: value)
    }

    public func epubTextTransform(_ value: String) -> Style {
        set("epub-text-transform", to: value)
    }

    public func epubWordBreak(_ value: String) -> Style {
        set("epub-word-break", to: value)
    }

    public func epubWritingMode(_ value: String) -> Style {
        set("epub-writing-mode", to: value)
    }

    public func fallback(_ value: String) -> Style {
        set("fallback", to: value)
    }

    public func fieldSizing(_ value: String) -> Style {
        set("field-sizing", to: value)
    }

    public func fill(_ value: String) -> Style {
        set("fill", to: value)
    }

    public func fillBreak(_ value: String) -> Style {
        set("fill-break", to: value)
    }

    public func fillColor(_ value: String) -> Style {
        set("fill-color", to: value)
    }

    public func fillImage(_ value: String) -> Style {
        set("fill-image", to: value)
    }

    public func fillOpacity(_ value: String) -> Style {
        set("fill-opacity", to: value)
    }

    public func fillOrigin(_ value: String) -> Style {
        set("fill-origin", to: value)
    }

    public func fillPosition(_ value: String) -> Style {
        set("fill-position", to: value)
    }

    public func fillRepeat(_ value: String) -> Style {
        set("fill-repeat", to: value)
    }

    public func fillRule(_ value: String) -> Style {
        set("fill-rule", to: value)
    }

    public func fillSize(_ value: String) -> Style {
        set("fill-size", to: value)
    }

    public func filter(_ value: String) -> Style {
        set("filter", to: value)
    }

    public func msFilter(_ value: String) -> Style {
        set("-ms-filter", to: value)
    }

    public func webkitFilter(_ value: String) -> Style {
        set("-webkit-filter", to: value)
    }

    public func flex(_ value: String) -> Style {
        set("flex", to: value)
    }

    public func msFlexAlign(_ value: String) -> Style {
        set("-ms-flex-align", to: value)
    }

    public func webkitFlexAlign(_ value: String) -> Style {
        set("-webkit-flex-align", to: value)
    }

    public func flexBasis(_ value: String) -> Style {
        set("flex-basis", to: value)
    }

    public func webkitFlexBasis(_ value: String) -> Style {
        set("-webkit-flex-basis", to: value)
    }

    public func flexDirection(_ value: String) -> Style {
        set("flex-direction", to: value)
    }

    public func msFlexDirection(_ value: String) -> Style {
        set("-ms-flex-direction", to: value)
    }

    public func webkitFlexDirection(_ value: String) -> Style {
        set("-webkit-flex-direction", to: value)
    }

    public func flexFlow(_ value: String) -> Style {
        set("flex-flow", to: value)
    }

    public func msFlexFlow(_ value: String) -> Style {
        set("-ms-flex-flow", to: value)
    }

    public func webkitFlexFlow(_ value: String) -> Style {
        set("-webkit-flex-flow", to: value)
    }

    public func flexGrow(_ value: String) -> Style {
        set("flex-grow", to: value)
    }

    public func webkitFlexGrow(_ value: String) -> Style {
        set("-webkit-flex-grow", to: value)
    }

    public func msFlexItemAlign(_ value: String) -> Style {
        set("-ms-flex-item-align", to: value)
    }

    public func webkitFlexItemAlign(_ value: String) -> Style {
        set("-webkit-flex-item-align", to: value)
    }

    public func msFlexLinePack(_ value: String) -> Style {
        set("-ms-flex-line-pack", to: value)
    }

    public func webkitFlexLinePack(_ value: String) -> Style {
        set("-webkit-flex-line-pack", to: value)
    }

    public func msFlex(_ value: String) -> Style {
        set("-ms-flex", to: value)
    }

    public func msFlexNegative(_ value: String) -> Style {
        set("-ms-flex-negative", to: value)
    }

    public func msFlexOrder(_ value: String) -> Style {
        set("-ms-flex-order", to: value)
    }

    public func webkitFlexOrder(_ value: String) -> Style {
        set("-webkit-flex-order", to: value)
    }

    public func msFlexPack(_ value: String) -> Style {
        set("-ms-flex-pack", to: value)
    }

    public func webkitFlexPack(_ value: String) -> Style {
        set("-webkit-flex-pack", to: value)
    }

    public func msFlexPositive(_ value: String) -> Style {
        set("-ms-flex-positive", to: value)
    }

    public func msFlexPreferredSize(_ value: String) -> Style {
        set("-ms-flex-preferred-size", to: value)
    }

    public func flexShrink(_ value: String) -> Style {
        set("flex-shrink", to: value)
    }

    public func webkitFlexShrink(_ value: String) -> Style {
        set("-webkit-flex-shrink", to: value)
    }

    public func webkitFlex(_ value: String) -> Style {
        set("-webkit-flex", to: value)
    }

    public func flexWrap(_ value: String) -> Style {
        set("flex-wrap", to: value)
    }

    public func msFlexWrap(_ value: String) -> Style {
        set("-ms-flex-wrap", to: value)
    }

    public func webkitFlexWrap(_ value: String) -> Style {
        set("-webkit-flex-wrap", to: value)
    }

    public func float(_ value: String) -> Style {
        set("float", to: value)
    }

    public func floatDefer(_ value: String) -> Style {
        set("float-defer", to: value)
    }

    public func mozFloatEdge(_ value: String) -> Style {
        set("-moz-float-edge", to: value)
    }

    public func floatOffset(_ value: String) -> Style {
        set("float-offset", to: value)
    }

    public func floatReference(_ value: String) -> Style {
        set("float-reference", to: value)
    }

    public func floodColor(_ value: String) -> Style {
        set("flood-color", to: value)
    }

    public func floodOpacity(_ value: String) -> Style {
        set("flood-opacity", to: value)
    }

    public func flow(_ value: String) -> Style {
        set("flow", to: value)
    }

    public func flowFrom(_ value: String) -> Style {
        set("flow-from", to: value)
    }

    public func msFlowFrom(_ value: String) -> Style {
        set("-ms-flow-from", to: value)
    }

    public func webkitFlowFrom(_ value: String) -> Style {
        set("-webkit-flow-from", to: value)
    }

    public func flowInto(_ value: String) -> Style {
        set("flow-into", to: value)
    }

    public func msFlowInto(_ value: String) -> Style {
        set("-ms-flow-into", to: value)
    }

    public func webkitFlowInto(_ value: String) -> Style {
        set("-webkit-flow-into", to: value)
    }

    public func font(_ value: String) -> Style {
        set("font", to: value)
    }

    public func fontDisplay(_ value: String) -> Style {
        set("font-display", to: value)
    }

    public func fontFamily(_ value: String) -> Style {
        set("font-family", to: value)
    }

    public func fontFeatureSettings(_ value: String) -> Style {
        set("font-feature-settings", to: value)
    }

    public func mozFontFeatureSettings(_ value: String) -> Style {
        set("-moz-font-feature-settings", to: value)
    }

    public func msFontFeatureSettings(_ value: String) -> Style {
        set("-ms-font-feature-settings", to: value)
    }

    public func webkitFontFeatureSettings(_ value: String) -> Style {
        set("-webkit-font-feature-settings", to: value)
    }

    public func fontKerning(_ value: String) -> Style {
        set("font-kerning", to: value)
    }

    public func webkitFontKerning(_ value: String) -> Style {
        set("-webkit-font-kerning", to: value)
    }

    public func fontLanguageOverride(_ value: String) -> Style {
        set("font-language-override", to: value)
    }

    public func mozFontLanguageOverride(_ value: String) -> Style {
        set("-moz-font-language-override", to: value)
    }

    public func fontOpticalSizing(_ value: String) -> Style {
        set("font-optical-sizing", to: value)
    }

    public func fontPalette(_ value: String) -> Style {
        set("font-palette", to: value)
    }

    public func fontSize(_ value: String) -> Style {
        set("font-size", to: value)
    }

    public func fontSizeAdjust(_ value: String) -> Style {
        set("font-size-adjust", to: value)
    }

    public func webkitFontSizeDelta(_ value: String) -> Style {
        set("-webkit-font-size-delta", to: value)
    }

    public func webkitFontSmoothing(_ value: String) -> Style {
        set("-webkit-font-smoothing", to: value)
    }

    public func fontStretch(_ value: String) -> Style {
        set("font-stretch", to: value)
    }

    public func fontStyle(_ value: String) -> Style {
        set("font-style", to: value)
    }

    public func fontSynthesis(_ value: String) -> Style {
        set("font-synthesis", to: value)
    }

    public func fontSynthesisPosition(_ value: String) -> Style {
        set("font-synthesis-position", to: value)
    }

    public func fontSynthesisSmallCaps(_ value: String) -> Style {
        set("font-synthesis-small-caps", to: value)
    }

    public func fontSynthesisStyle(_ value: String) -> Style {
        set("font-synthesis-style", to: value)
    }

    public func fontSynthesisWeight(_ value: String) -> Style {
        set("font-synthesis-weight", to: value)
    }

    public func fontVariant(_ value: String) -> Style {
        set("font-variant", to: value)
    }

    public func fontVariantAlternates(_ value: String) -> Style {
        set("font-variant-alternates", to: value)
    }

    public func fontVariantCaps(_ value: String) -> Style {
        set("font-variant-caps", to: value)
    }

    public func fontVariantEastAsian(_ value: String) -> Style {
        set("font-variant-east-asian", to: value)
    }

    public func fontVariantEmoji(_ value: String) -> Style {
        set("font-variant-emoji", to: value)
    }

    public func fontVariantLigatures(_ value: String) -> Style {
        set("font-variant-ligatures", to: value)
    }

    public func webkitFontVariantLigatures(_ value: String) -> Style {
        set("-webkit-font-variant-ligatures", to: value)
    }

    public func fontVariantNumeric(_ value: String) -> Style {
        set("font-variant-numeric", to: value)
    }

    public func fontVariantPosition(_ value: String) -> Style {
        set("font-variant-position", to: value)
    }

    public func fontVariationSettings(_ value: String) -> Style {
        set("font-variation-settings", to: value)
    }

    public func fontWeight(_ value: String) -> Style {
        set("font-weight", to: value)
    }

    public func fontWidth(_ value: String) -> Style {
        set("font-width", to: value)
    }

    public func footnoteDisplay(_ value: String) -> Style {
        set("footnote-display", to: value)
    }

    public func footnotePolicy(_ value: String) -> Style {
        set("footnote-policy", to: value)
    }

    public func mozForceBrokenImageIcon(_ value: String) -> Style {
        set("-moz-force-broken-image-icon", to: value)
    }

    public func forcedColorAdjust(_ value: String) -> Style {
        set("forced-color-adjust", to: value)
    }

    public func gap(_ value: String) -> Style {
        set("gap", to: value)
    }

    public func glyphOrientationHorizontal(_ value: String) -> Style {
        set("glyph-orientation-horizontal", to: value)
    }

    public func glyphOrientationVertical(_ value: String) -> Style {
        set("glyph-orientation-vertical", to: value)
    }

    public func grid(_ value: String) -> Style {
        set("grid", to: value)
    }

    public func webkitGridAfter(_ value: String) -> Style {
        set("-webkit-grid-after", to: value)
    }

    public func gridArea(_ value: String) -> Style {
        set("grid-area", to: value)
    }

    public func gridAutoColumns(_ value: String) -> Style {
        set("grid-auto-columns", to: value)
    }

    public func webkitGridAutoColumns(_ value: String) -> Style {
        set("-webkit-grid-auto-columns", to: value)
    }

    public func gridAutoFlow(_ value: String) -> Style {
        set("grid-auto-flow", to: value)
    }

    public func webkitGridAutoFlow(_ value: String) -> Style {
        set("-webkit-grid-auto-flow", to: value)
    }

    public func gridAutoRows(_ value: String) -> Style {
        set("grid-auto-rows", to: value)
    }

    public func webkitGridAutoRows(_ value: String) -> Style {
        set("-webkit-grid-auto-rows", to: value)
    }

    public func webkitGridBefore(_ value: String) -> Style {
        set("-webkit-grid-before", to: value)
    }

    public func gridColumn(_ value: String) -> Style {
        set("grid-column", to: value)
    }

    public func msGridColumnAlign(_ value: String) -> Style {
        set("-ms-grid-column-align", to: value)
    }

    public func gridColumnEnd(_ value: String) -> Style {
        set("grid-column-end", to: value)
    }

    public func gridColumnGap(_ value: String) -> Style {
        set("grid-column-gap", to: value)
    }

    public func msGridColumn(_ value: String) -> Style {
        set("-ms-grid-column", to: value)
    }

    public func msGridColumnSpan(_ value: String) -> Style {
        set("-ms-grid-column-span", to: value)
    }

    public func gridColumnStart(_ value: String) -> Style {
        set("grid-column-start", to: value)
    }

    public func webkitGridColumn(_ value: String) -> Style {
        set("-webkit-grid-column", to: value)
    }

    public func msGridColumns(_ value: String) -> Style {
        set("-ms-grid-columns", to: value)
    }

    public func webkitGridColumns(_ value: String) -> Style {
        set("-webkit-grid-columns", to: value)
    }

    public func webkitGridEnd(_ value: String) -> Style {
        set("-webkit-grid-end", to: value)
    }

    public func gridGap(_ value: String) -> Style {
        set("grid-gap", to: value)
    }

    public func gridRow(_ value: String) -> Style {
        set("grid-row", to: value)
    }

    public func msGridRowAlign(_ value: String) -> Style {
        set("-ms-grid-row-align", to: value)
    }

    public func gridRowEnd(_ value: String) -> Style {
        set("grid-row-end", to: value)
    }

    public func gridRowGap(_ value: String) -> Style {
        set("grid-row-gap", to: value)
    }

    public func msGridRow(_ value: String) -> Style {
        set("-ms-grid-row", to: value)
    }

    public func msGridRowSpan(_ value: String) -> Style {
        set("-ms-grid-row-span", to: value)
    }

    public func gridRowStart(_ value: String) -> Style {
        set("grid-row-start", to: value)
    }

    public func webkitGridRow(_ value: String) -> Style {
        set("-webkit-grid-row", to: value)
    }

    public func msGridRows(_ value: String) -> Style {
        set("-ms-grid-rows", to: value)
    }

    public func webkitGridRows(_ value: String) -> Style {
        set("-webkit-grid-rows", to: value)
    }

    public func webkitGridStart(_ value: String) -> Style {
        set("-webkit-grid-start", to: value)
    }

    public func gridTemplate(_ value: String) -> Style {
        set("grid-template", to: value)
    }

    public func gridTemplateAreas(_ value: String) -> Style {
        set("grid-template-areas", to: value)
    }

    public func gridTemplateColumns(_ value: String) -> Style {
        set("grid-template-columns", to: value)
    }

    public func gridTemplateRows(_ value: String) -> Style {
        set("grid-template-rows", to: value)
    }

    public func hangingPunctuation(_ value: String) -> Style {
        set("hanging-punctuation", to: value)
    }

    public func height(_ value: String) -> Style {
        set("height", to: value)
    }

    public func msHighContrastAdjust(_ value: String) -> Style {
        set("-ms-high-contrast-adjust", to: value)
    }

    public func webkitHighlight(_ value: String) -> Style {
        set("-webkit-highlight", to: value)
    }

    public func hyphenateCharacter(_ value: String) -> Style {
        set("hyphenate-character", to: value)
    }

    public func webkitHyphenateCharacter(_ value: String) -> Style {
        set("-webkit-hyphenate-character", to: value)
    }

    public func webkitHyphenateLimitAfter(_ value: String) -> Style {
        set("-webkit-hyphenate-limit-after", to: value)
    }

    public func webkitHyphenateLimitBefore(_ value: String) -> Style {
        set("-webkit-hyphenate-limit-before", to: value)
    }

    public func hyphenateLimitChars(_ value: String) -> Style {
        set("hyphenate-limit-chars", to: value)
    }

    public func msHyphenateLimitChars(_ value: String) -> Style {
        set("-ms-hyphenate-limit-chars", to: value)
    }

    public func hyphenateLimitLast(_ value: String) -> Style {
        set("hyphenate-limit-last", to: value)
    }

    public func hyphenateLimitLines(_ value: String) -> Style {
        set("hyphenate-limit-lines", to: value)
    }

    public func msHyphenateLimitLines(_ value: String) -> Style {
        set("-ms-hyphenate-limit-lines", to: value)
    }

    public func webkitHyphenateLimitLines(_ value: String) -> Style {
        set("-webkit-hyphenate-limit-lines", to: value)
    }

    public func hyphenateLimitZone(_ value: String) -> Style {
        set("hyphenate-limit-zone", to: value)
    }

    public func msHyphenateLimitZone(_ value: String) -> Style {
        set("-ms-hyphenate-limit-zone", to: value)
    }

    public func hyphens(_ value: String) -> Style {
        set("hyphens", to: value)
    }

    public func mozHyphens(_ value: String) -> Style {
        set("-moz-hyphens", to: value)
    }

    public func msHyphens(_ value: String) -> Style {
        set("-ms-hyphens", to: value)
    }

    public func webkitHyphens(_ value: String) -> Style {
        set("-webkit-hyphens", to: value)
    }

    public func imageOrientation(_ value: String) -> Style {
        set("image-orientation", to: value)
    }

    public func mozImageRegion(_ value: String) -> Style {
        set("-moz-image-region", to: value)
    }

    public func imageRendering(_ value: String) -> Style {
        set("image-rendering", to: value)
    }

    public func imageResolution(_ value: String) -> Style {
        set("image-resolution", to: value)
    }

    public func msImeAlign(_ value: String) -> Style {
        set("-ms-ime-align", to: value)
    }

    public func imeMode(_ value: String) -> Style {
        set("ime-mode", to: value)
    }

    public func inherits(_ value: String) -> Style {
        set("inherits", to: value)
    }

    public func initialLetter(_ value: String) -> Style {
        set("initial-letter", to: value)
    }

    public func initialLetterAlign(_ value: String) -> Style {
        set("initial-letter-align", to: value)
    }

    public func webkitInitialLetter(_ value: String) -> Style {
        set("-webkit-initial-letter", to: value)
    }

    public func initialLetterWrap(_ value: String) -> Style {
        set("initial-letter-wrap", to: value)
    }

    public func initialValue(_ value: String) -> Style {
        set("initial-value", to: value)
    }

    public func inlineSize(_ value: String) -> Style {
        set("inline-size", to: value)
    }

    public func inlineSizing(_ value: String) -> Style {
        set("inline-sizing", to: value)
    }

    public func inputFormat(_ value: String) -> Style {
        set("input-format", to: value)
    }

    public func wapInputFormat(_ value: String) -> Style {
        set("-wap-input-format", to: value)
    }

    public func wapInputRequired(_ value: String) -> Style {
        set("-wap-input-required", to: value)
    }

    public func inputSecurity(_ value: String) -> Style {
        set("input-security", to: value)
    }

    public func inset(_ value: String) -> Style {
        set("inset", to: value)
    }

    public func insetArea(_ value: String) -> Style {
        set("inset-area", to: value)
    }

    public func insetBlock(_ value: String) -> Style {
        set("inset-block", to: value)
    }

    public func insetBlockEnd(_ value: String) -> Style {
        set("inset-block-end", to: value)
    }

    public func insetBlockStart(_ value: String) -> Style {
        set("inset-block-start", to: value)
    }

    public func insetInline(_ value: String) -> Style {
        set("inset-inline", to: value)
    }

    public func insetInlineEnd(_ value: String) -> Style {
        set("inset-inline-end", to: value)
    }

    public func insetInlineStart(_ value: String) -> Style {
        set("inset-inline-start", to: value)
    }

    public func msInterpolationMode(_ value: String) -> Style {
        set("-ms-interpolation-mode", to: value)
    }

    public func isolation(_ value: String) -> Style {
        set("isolation", to: value)
    }

    public func justifyContent(_ value: String) -> Style {
        set("justify-content", to: value)
    }

    public func webkitJustifyContent(_ value: String) -> Style {
        set("-webkit-justify-content", to: value)
    }

    public func justifyItems(_ value: String) -> Style {
        set("justify-items", to: value)
    }

    public func webkitJustifyItems(_ value: String) -> Style {
        set("-webkit-justify-items", to: value)
    }

    public func justifySelf(_ value: String) -> Style {
        set("justify-self", to: value)
    }

    public func webkitJustifySelf(_ value: String) -> Style {
        set("-webkit-justify-self", to: value)
    }

    public func kerning(_ value: String) -> Style {
        set("kerning", to: value)
    }

    public func layoutFlow(_ value: String) -> Style {
        set("layout-flow", to: value)
    }

    public func layoutGrid(_ value: String) -> Style {
        set("layout-grid", to: value)
    }

    public func layoutGridChar(_ value: String) -> Style {
        set("layout-grid-char", to: value)
    }

    public func layoutGridLine(_ value: String) -> Style {
        set("layout-grid-line", to: value)
    }

    public func layoutGridMode(_ value: String) -> Style {
        set("layout-grid-mode", to: value)
    }

    public func layoutGridType(_ value: String) -> Style {
        set("layout-grid-type", to: value)
    }

    public func left(_ value: String) -> Style {
        set("left", to: value)
    }

    public func letterSpacing(_ value: String) -> Style {
        set("letter-spacing", to: value)
    }

    public func lightingColor(_ value: String) -> Style {
        set("lighting-color", to: value)
    }

    public func webkitLineAlign(_ value: String) -> Style {
        set("-webkit-line-align", to: value)
    }

    public func webkitLineBoxContain(_ value: String) -> Style {
        set("-webkit-line-box-contain", to: value)
    }

    public func lineBreak(_ value: String) -> Style {
        set("line-break", to: value)
    }

    public func webkitLineBreak(_ value: String) -> Style {
        set("-webkit-line-break", to: value)
    }

    public func lineClamp(_ value: String) -> Style {
        set("line-clamp", to: value)
    }

    public func webkitLineClamp(_ value: String) -> Style {
        set("-webkit-line-clamp", to: value)
    }

    public func lineGapOverride(_ value: String) -> Style {
        set("line-gap-override", to: value)
    }

    public func lineGrid(_ value: String) -> Style {
        set("line-grid", to: value)
    }

    public func webkitLineGridSnap(_ value: String) -> Style {
        set("-webkit-line-grid-snap", to: value)
    }

    public func webkitLineGrid(_ value: String) -> Style {
        set("-webkit-line-grid", to: value)
    }

    public func lineHeight(_ value: String) -> Style {
        set("line-height", to: value)
    }

    public func lineHeightStep(_ value: String) -> Style {
        set("line-height-step", to: value)
    }

    public func lineIncrement(_ value: String) -> Style {
        set("line-increment", to: value)
    }

    public func linePadding(_ value: String) -> Style {
        set("line-padding", to: value)
    }

    public func lineSnap(_ value: String) -> Style {
        set("line-snap", to: value)
    }

    public func webkitLineSnap(_ value: String) -> Style {
        set("-webkit-line-snap", to: value)
    }

    public func oLink(_ value: String) -> Style {
        set("-o-link", to: value)
    }

    public func oLinkSource(_ value: String) -> Style {
        set("-o-link-source", to: value)
    }

    public func listStyle(_ value: String) -> Style {
        set("list-style", to: value)
    }

    public func listStyleImage(_ value: String) -> Style {
        set("list-style-image", to: value)
    }

    public func listStylePosition(_ value: String) -> Style {
        set("list-style-position", to: value)
    }

    public func listStyleType(_ value: String) -> Style {
        set("list-style-type", to: value)
    }

    public func webkitLocale(_ value: String) -> Style {
        set("-webkit-locale", to: value)
    }

    public func webkitLogicalHeight(_ value: String) -> Style {
        set("-webkit-logical-height", to: value)
    }

    public func webkitLogicalWidth(_ value: String) -> Style {
        set("-webkit-logical-width", to: value)
    }

    public func margin(_ value: String) -> Style {
        set("margin", to: value)
    }

    public func webkitMarginAfterCollapse(_ value: String) -> Style {
        set("-webkit-margin-after-collapse", to: value)
    }

    public func webkitMarginAfter(_ value: String) -> Style {
        set("-webkit-margin-after", to: value)
    }

    public func webkitMarginBeforeCollapse(_ value: String) -> Style {
        set("-webkit-margin-before-collapse", to: value)
    }

    public func webkitMarginBefore(_ value: String) -> Style {
        set("-webkit-margin-before", to: value)
    }

    public func marginBlock(_ value: String) -> Style {
        set("margin-block", to: value)
    }

    public func marginBlockEnd(_ value: String) -> Style {
        set("margin-block-end", to: value)
    }

    public func marginBlockStart(_ value: String) -> Style {
        set("margin-block-start", to: value)
    }

    public func marginBottom(_ value: String) -> Style {
        set("margin-bottom", to: value)
    }

    public func webkitMarginBottomCollapse(_ value: String) -> Style {
        set("-webkit-margin-bottom-collapse", to: value)
    }

    public func marginBreak(_ value: String) -> Style {
        set("margin-break", to: value)
    }

    public func webkitMarginCollapse(_ value: String) -> Style {
        set("-webkit-margin-collapse", to: value)
    }

    public func mozMarginEnd(_ value: String) -> Style {
        set("-moz-margin-end", to: value)
    }

    public func webkitMarginEnd(_ value: String) -> Style {
        set("-webkit-margin-end", to: value)
    }

    public func marginInline(_ value: String) -> Style {
        set("margin-inline", to: value)
    }

    public func marginInlineEnd(_ value: String) -> Style {
        set("margin-inline-end", to: value)
    }

    public func marginInlineStart(_ value: String) -> Style {
        set("margin-inline-start", to: value)
    }

    public func marginLeft(_ value: String) -> Style {
        set("margin-left", to: value)
    }

    public func marginRight(_ value: String) -> Style {
        set("margin-right", to: value)
    }

    public func mozMarginStart(_ value: String) -> Style {
        set("-moz-margin-start", to: value)
    }

    public func webkitMarginStart(_ value: String) -> Style {
        set("-webkit-margin-start", to: value)
    }

    public func marginTop(_ value: String) -> Style {
        set("margin-top", to: value)
    }

    public func webkitMarginTopCollapse(_ value: String) -> Style {
        set("-webkit-margin-top-collapse", to: value)
    }

    public func marginTrim(_ value: String) -> Style {
        set("margin-trim", to: value)
    }

    public func marker(_ value: String) -> Style {
        set("marker", to: value)
    }

    public func markerEnd(_ value: String) -> Style {
        set("marker-end", to: value)
    }

    public func markerKnockoutLeft(_ value: String) -> Style {
        set("marker-knockout-left", to: value)
    }

    public func markerKnockoutRight(_ value: String) -> Style {
        set("marker-knockout-right", to: value)
    }

    public func markerMid(_ value: String) -> Style {
        set("marker-mid", to: value)
    }

    public func markerOffset(_ value: String) -> Style {
        set("marker-offset", to: value)
    }

    public func markerPattern(_ value: String) -> Style {
        set("marker-pattern", to: value)
    }

    public func markerSegment(_ value: String) -> Style {
        set("marker-segment", to: value)
    }

    public func markerSide(_ value: String) -> Style {
        set("marker-side", to: value)
    }

    public func markerStart(_ value: String) -> Style {
        set("marker-start", to: value)
    }

    public func marks(_ value: String) -> Style {
        set("marks", to: value)
    }

    public func wapMarqueeDir(_ value: String) -> Style {
        set("-wap-marquee-dir", to: value)
    }

    public func webkitMarqueeDirection(_ value: String) -> Style {
        set("-webkit-marquee-direction", to: value)
    }

    public func webkitMarqueeIncrement(_ value: String) -> Style {
        set("-webkit-marquee-increment", to: value)
    }

    public func wapMarqueeLoop(_ value: String) -> Style {
        set("-wap-marquee-loop", to: value)
    }

    public func webkitMarqueeRepetition(_ value: String) -> Style {
        set("-webkit-marquee-repetition", to: value)
    }

    public func wapMarqueeSpeed(_ value: String) -> Style {
        set("-wap-marquee-speed", to: value)
    }

    public func webkitMarqueeSpeed(_ value: String) -> Style {
        set("-webkit-marquee-speed", to: value)
    }

    public func wapMarqueeStyle(_ value: String) -> Style {
        set("-wap-marquee-style", to: value)
    }

    public func webkitMarqueeStyle(_ value: String) -> Style {
        set("-webkit-marquee-style", to: value)
    }

    public func webkitMarquee(_ value: String) -> Style {
        set("-webkit-marquee", to: value)
    }

    public func mask(_ value: String) -> Style {
        set("mask", to: value)
    }

    public func webkitMaskAttachment(_ value: String) -> Style {
        set("-webkit-mask-attachment", to: value)
    }

    public func maskBorder(_ value: String) -> Style {
        set("mask-border", to: value)
    }

    public func maskBorderMode(_ value: String) -> Style {
        set("mask-border-mode", to: value)
    }

    public func maskBorderOutset(_ value: String) -> Style {
        set("mask-border-outset", to: value)
    }

    public func maskBorderRepeat(_ value: String) -> Style {
        set("mask-border-repeat", to: value)
    }

    public func maskBorderSlice(_ value: String) -> Style {
        set("mask-border-slice", to: value)
    }

    public func maskBorderSource(_ value: String) -> Style {
        set("mask-border-source", to: value)
    }

    public func maskBorderWidth(_ value: String) -> Style {
        set("mask-border-width", to: value)
    }

    public func webkitMaskBoxImageOutset(_ value: String) -> Style {
        set("-webkit-mask-box-image-outset", to: value)
    }

    public func webkitMaskBoxImageRepeat(_ value: String) -> Style {
        set("-webkit-mask-box-image-repeat", to: value)
    }

    public func webkitMaskBoxImageSlice(_ value: String) -> Style {
        set("-webkit-mask-box-image-slice", to: value)
    }

    public func webkitMaskBoxImageSource(_ value: String) -> Style {
        set("-webkit-mask-box-image-source", to: value)
    }

    public func webkitMaskBoxImage(_ value: String) -> Style {
        set("-webkit-mask-box-image", to: value)
    }

    public func webkitMaskBoxImageWidth(_ value: String) -> Style {
        set("-webkit-mask-box-image-width", to: value)
    }

    public func maskClip(_ value: String) -> Style {
        set("mask-clip", to: value)
    }

    public func webkitMaskClip(_ value: String) -> Style {
        set("-webkit-mask-clip", to: value)
    }

    public func maskComposite(_ value: String) -> Style {
        set("mask-composite", to: value)
    }

    public func webkitMaskComposite(_ value: String) -> Style {
        set("-webkit-mask-composite", to: value)
    }

    public func maskImage(_ value: String) -> Style {
        set("mask-image", to: value)
    }

    public func webkitMaskImage(_ value: String) -> Style {
        set("-webkit-mask-image", to: value)
    }

    public func maskMode(_ value: String) -> Style {
        set("mask-mode", to: value)
    }

    public func maskOrigin(_ value: String) -> Style {
        set("mask-origin", to: value)
    }

    public func webkitMaskOrigin(_ value: String) -> Style {
        set("-webkit-mask-origin", to: value)
    }

    public func maskPosition(_ value: String) -> Style {
        set("mask-position", to: value)
    }

    public func webkitMaskPosition(_ value: String) -> Style {
        set("-webkit-mask-position", to: value)
    }

    public func maskPositionX(_ value: String) -> Style {
        set("mask-position-x", to: value)
    }

    public func webkitMaskPositionX(_ value: String) -> Style {
        set("-webkit-mask-position-x", to: value)
    }

    public func maskPositionY(_ value: String) -> Style {
        set("mask-position-y", to: value)
    }

    public func webkitMaskPositionY(_ value: String) -> Style {
        set("-webkit-mask-position-y", to: value)
    }

    public func maskRepeat(_ value: String) -> Style {
        set("mask-repeat", to: value)
    }

    public func webkitMaskRepeat(_ value: String) -> Style {
        set("-webkit-mask-repeat", to: value)
    }

    public func webkitMaskRepeatX(_ value: String) -> Style {
        set("-webkit-mask-repeat-x", to: value)
    }

    public func webkitMaskRepeatY(_ value: String) -> Style {
        set("-webkit-mask-repeat-y", to: value)
    }

    public func maskSize(_ value: String) -> Style {
        set("mask-size", to: value)
    }

    public func webkitMaskSize(_ value: String) -> Style {
        set("-webkit-mask-size", to: value)
    }

    public func maskSourceType(_ value: String) -> Style {
        set("mask-source-type", to: value)
    }

    public func webkitMaskSourceType(_ value: String) -> Style {
        set("-webkit-mask-source-type", to: value)
    }

    public func maskType(_ value: String) -> Style {
        set("mask-type", to: value)
    }

    public func webkitMask(_ value: String) -> Style {
        set("-webkit-mask", to: value)
    }

    public func webkitMatchNearestMailBlockquoteColor(_ value: String) -> Style {
        set("-webkit-match-nearest-mail-blockquote-color", to: value)
    }

    public func mathDepth(_ value: String) -> Style {
        set("math-depth", to: value)
    }

    public func mathShift(_ value: String) -> Style {
        set("math-shift", to: value)
    }

    public func mathStyle(_ value: String) -> Style {
        set("math-style", to: value)
    }

    public func maxBlockSize(_ value: String) -> Style {
        set("max-block-size", to: value)
    }

    public func maxHeight(_ value: String) -> Style {
        set("max-height", to: value)
    }

    public func maxInlineSize(_ value: String) -> Style {
        set("max-inline-size", to: value)
    }

    public func maxLines(_ value: String) -> Style {
        set("max-lines", to: value)
    }

    public func webkitMaxLogicalHeight(_ value: String) -> Style {
        set("-webkit-max-logical-height", to: value)
    }

    public func webkitMaxLogicalWidth(_ value: String) -> Style {
        set("-webkit-max-logical-width", to: value)
    }

    public func maxWidth(_ value: String) -> Style {
        set("max-width", to: value)
    }

    public func maxZoom(_ value: String) -> Style {
        set("max-zoom", to: value)
    }

    public func minBlockSize(_ value: String) -> Style {
        set("min-block-size", to: value)
    }

    public func minHeight(_ value: String) -> Style {
        set("min-height", to: value)
    }

    public func minInlineSize(_ value: String) -> Style {
        set("min-inline-size", to: value)
    }

    public func minIntrinsicSizing(_ value: String) -> Style {
        set("min-intrinsic-sizing", to: value)
    }

    public func webkitMinLogicalHeight(_ value: String) -> Style {
        set("-webkit-min-logical-height", to: value)
    }

    public func webkitMinLogicalWidth(_ value: String) -> Style {
        set("-webkit-min-logical-width", to: value)
    }

    public func minWidth(_ value: String) -> Style {
        set("min-width", to: value)
    }

    public func minZoom(_ value: String) -> Style {
        set("min-zoom", to: value)
    }

    public func mixBlendMode(_ value: String) -> Style {
        set("mix-blend-mode", to: value)
    }

    public func motion(_ value: String) -> Style {
        set("motion", to: value)
    }

    public func motionOffset(_ value: String) -> Style {
        set("motion-offset", to: value)
    }

    public func motionPath(_ value: String) -> Style {
        set("motion-path", to: value)
    }

    public func motionRotation(_ value: String) -> Style {
        set("motion-rotation", to: value)
    }

    public func navDown(_ value: String) -> Style {
        set("nav-down", to: value)
    }

    public func navIndex(_ value: String) -> Style {
        set("nav-index", to: value)
    }

    public func navLeft(_ value: String) -> Style {
        set("nav-left", to: value)
    }

    public func navRight(_ value: String) -> Style {
        set("nav-right", to: value)
    }

    public func navUp(_ value: String) -> Style {
        set("nav-up", to: value)
    }

    public func webkitNbspMode(_ value: String) -> Style {
        set("-webkit-nbsp-mode", to: value)
    }

    public func negative(_ value: String) -> Style {
        set("negative", to: value)
    }

    public func objectFit(_ value: String) -> Style {
        set("object-fit", to: value)
    }

    public func oObjectFit(_ value: String) -> Style {
        set("-o-object-fit", to: value)
    }

    public func objectPosition(_ value: String) -> Style {
        set("object-position", to: value)
    }

    public func oObjectPosition(_ value: String) -> Style {
        set("-o-object-position", to: value)
    }

    public func objectViewBox(_ value: String) -> Style {
        set("object-view-box", to: value)
    }

    public func offset(_ value: String) -> Style {
        set("offset", to: value)
    }

    public func offsetAnchor(_ value: String) -> Style {
        set("offset-anchor", to: value)
    }

    public func offsetBlockEnd(_ value: String) -> Style {
        set("offset-block-end", to: value)
    }

    public func offsetBlockStart(_ value: String) -> Style {
        set("offset-block-start", to: value)
    }

    public func offsetDistance(_ value: String) -> Style {
        set("offset-distance", to: value)
    }

    public func offsetInlineEnd(_ value: String) -> Style {
        set("offset-inline-end", to: value)
    }

    public func offsetInlineStart(_ value: String) -> Style {
        set("offset-inline-start", to: value)
    }

    public func offsetPath(_ value: String) -> Style {
        set("offset-path", to: value)
    }

    public func offsetPosition(_ value: String) -> Style {
        set("offset-position", to: value)
    }

    public func offsetRotate(_ value: String) -> Style {
        set("offset-rotate", to: value)
    }

    public func offsetRotation(_ value: String) -> Style {
        set("offset-rotation", to: value)
    }

    public func opacity(_ value: String) -> Style {
        set("opacity", to: value)
    }

    public func mozOpacity(_ value: String) -> Style {
        set("-moz-opacity", to: value)
    }

    public func webkitOpacity(_ value: String) -> Style {
        set("-webkit-opacity", to: value)
    }

    public func order(_ value: String) -> Style {
        set("order", to: value)
    }

    public func webkitOrder(_ value: String) -> Style {
        set("-webkit-order", to: value)
    }

    public func mozOrient(_ value: String) -> Style {
        set("-moz-orient", to: value)
    }

    public func orientation(_ value: String) -> Style {
        set("orientation", to: value)
    }

    public func orphans(_ value: String) -> Style {
        set("orphans", to: value)
    }

    public func mozOsxFontSmoothing(_ value: String) -> Style {
        set("-moz-osx-font-smoothing", to: value)
    }

    public func outline(_ value: String) -> Style {
        set("outline", to: value)
    }

    public func outlineColor(_ value: String) -> Style {
        set("outline-color", to: value)
    }

    public func mozOutlineColor(_ value: String) -> Style {
        set("-moz-outline-color", to: value)
    }

    public func mozOutline(_ value: String) -> Style {
        set("-moz-outline", to: value)
    }

    public func outlineOffset(_ value: String) -> Style {
        set("outline-offset", to: value)
    }

    public func mozOutlineOffset(_ value: String) -> Style {
        set("-moz-outline-offset", to: value)
    }

    public func mozOutlineRadiusBottomleft(_ value: String) -> Style {
        set("-moz-outline-radius-bottomleft", to: value)
    }

    public func mozOutlineRadiusBottomright(_ value: String) -> Style {
        set("-moz-outline-radius-bottomright", to: value)
    }

    public func mozOutlineRadius(_ value: String) -> Style {
        set("-moz-outline-radius", to: value)
    }

    public func mozOutlineRadiusTopleft(_ value: String) -> Style {
        set("-moz-outline-radius-topleft", to: value)
    }

    public func mozOutlineRadiusTopright(_ value: String) -> Style {
        set("-moz-outline-radius-topright", to: value)
    }

    public func outlineStyle(_ value: String) -> Style {
        set("outline-style", to: value)
    }

    public func mozOutlineStyle(_ value: String) -> Style {
        set("-moz-outline-style", to: value)
    }

    public func outlineWidth(_ value: String) -> Style {
        set("outline-width", to: value)
    }

    public func mozOutlineWidth(_ value: String) -> Style {
        set("-moz-outline-width", to: value)
    }

    public func overflow(_ value: String) -> Style {
        set("overflow", to: value)
    }

    public func overflowAnchor(_ value: String) -> Style {
        set("overflow-anchor", to: value)
    }

    public func overflowBlock(_ value: String) -> Style {
        set("overflow-block", to: value)
    }

    public func overflowClipMargin(_ value: String) -> Style {
        set("overflow-clip-margin", to: value)
    }

    public func overflowClipMarginBlock(_ value: String) -> Style {
        set("overflow-clip-margin-block", to: value)
    }

    public func overflowClipMarginBlockEnd(_ value: String) -> Style {
        set("overflow-clip-margin-block-end", to: value)
    }

    public func overflowClipMarginBlockStart(_ value: String) -> Style {
        set("overflow-clip-margin-block-start", to: value)
    }

    public func overflowClipMarginBottom(_ value: String) -> Style {
        set("overflow-clip-margin-bottom", to: value)
    }

    public func overflowClipMarginInline(_ value: String) -> Style {
        set("overflow-clip-margin-inline", to: value)
    }

    public func overflowClipMarginInlineEnd(_ value: String) -> Style {
        set("overflow-clip-margin-inline-end", to: value)
    }

    public func overflowClipMarginInlineStart(_ value: String) -> Style {
        set("overflow-clip-margin-inline-start", to: value)
    }

    public func overflowClipMarginLeft(_ value: String) -> Style {
        set("overflow-clip-margin-left", to: value)
    }

    public func overflowClipMarginRight(_ value: String) -> Style {
        set("overflow-clip-margin-right", to: value)
    }

    public func overflowClipMarginTop(_ value: String) -> Style {
        set("overflow-clip-margin-top", to: value)
    }

    public func overflowInline(_ value: String) -> Style {
        set("overflow-inline", to: value)
    }

    public func webkitOverflowScrolling(_ value: String) -> Style {
        set("-webkit-overflow-scrolling", to: value)
    }

    public func msOverflowStyle(_ value: String) -> Style {
        set("-ms-overflow-style", to: value)
    }

    public func overflowWrap(_ value: String) -> Style {
        set("overflow-wrap", to: value)
    }

    public func overflowX(_ value: String) -> Style {
        set("overflow-x", to: value)
    }

    public func overflowY(_ value: String) -> Style {
        set("overflow-y", to: value)
    }

    public func overlay(_ value: String) -> Style {
        set("overlay", to: value)
    }

    public func overrideColors(_ value: String) -> Style {
        set("override-colors", to: value)
    }

    public func overscrollBehavior(_ value: String) -> Style {
        set("overscroll-behavior", to: value)
    }

    public func overscrollBehaviorBlock(_ value: String) -> Style {
        set("overscroll-behavior-block", to: value)
    }

    public func overscrollBehaviorInline(_ value: String) -> Style {
        set("overscroll-behavior-inline", to: value)
    }

    public func overscrollBehaviorX(_ value: String) -> Style {
        set("overscroll-behavior-x", to: value)
    }

    public func overscrollBehaviorY(_ value: String) -> Style {
        set("overscroll-behavior-y", to: value)
    }

    public func pad(_ value: String) -> Style {
        set("pad", to: value)
    }

    public func padding(_ value: String) -> Style {
        set("padding", to: value)
    }

    public func webkitPaddingAfter(_ value: String) -> Style {
        set("-webkit-padding-after", to: value)
    }

    public func webkitPaddingBefore(_ value: String) -> Style {
        set("-webkit-padding-before", to: value)
    }

    public func paddingBlock(_ value: String) -> Style {
        set("padding-block", to: value)
    }

    public func paddingBlockEnd(_ value: String) -> Style {
        set("padding-block-end", to: value)
    }

    public func paddingBlockStart(_ value: String) -> Style {
        set("padding-block-start", to: value)
    }

    public func paddingBottom(_ value: String) -> Style {
        set("padding-bottom", to: value)
    }

    public func mozPaddingEnd(_ value: String) -> Style {
        set("-moz-padding-end", to: value)
    }

    public func webkitPaddingEnd(_ value: String) -> Style {
        set("-webkit-padding-end", to: value)
    }

    public func paddingInline(_ value: String) -> Style {
        set("padding-inline", to: value)
    }

    public func paddingInlineEnd(_ value: String) -> Style {
        set("padding-inline-end", to: value)
    }

    public func paddingInlineStart(_ value: String) -> Style {
        set("padding-inline-start", to: value)
    }

    public func paddingLeft(_ value: String) -> Style {
        set("padding-left", to: value)
    }

    public func paddingRight(_ value: String) -> Style {
        set("padding-right", to: value)
    }

    public func mozPaddingStart(_ value: String) -> Style {
        set("-moz-padding-start", to: value)
    }

    public func webkitPaddingStart(_ value: String) -> Style {
        set("-webkit-padding-start", to: value)
    }

    public func paddingTop(_ value: String) -> Style {
        set("padding-top", to: value)
    }

    public func page(_ value: String) -> Style {
        set("page", to: value)
    }

    public func pageBreakAfter(_ value: String) -> Style {
        set("page-break-after", to: value)
    }

    public func pageBreakBefore(_ value: String) -> Style {
        set("page-break-before", to: value)
    }

    public func pageBreakInside(_ value: String) -> Style {
        set("page-break-inside", to: value)
    }

    public func pageOrientation(_ value: String) -> Style {
        set("page-orientation", to: value)
    }

    public func paintOrder(_ value: String) -> Style {
        set("paint-order", to: value)
    }

    public func pause(_ value: String) -> Style {
        set("pause", to: value)
    }

    public func pauseAfter(_ value: String) -> Style {
        set("pause-after", to: value)
    }

    public func pauseBefore(_ value: String) -> Style {
        set("pause-before", to: value)
    }

    public func applePayButtonStyle(_ value: String) -> Style {
        set("-apple-pay-button-style", to: value)
    }

    public func applePayButtonType(_ value: String) -> Style {
        set("-apple-pay-button-type", to: value)
    }

    public func penAction(_ value: String) -> Style {
        set("pen-action", to: value)
    }

    public func perspective(_ value: String) -> Style {
        set("perspective", to: value)
    }

    public func mozPerspective(_ value: String) -> Style {
        set("-moz-perspective", to: value)
    }

    public func msPerspective(_ value: String) -> Style {
        set("-ms-perspective", to: value)
    }

    public func perspectiveOrigin(_ value: String) -> Style {
        set("perspective-origin", to: value)
    }

    public func mozPerspectiveOrigin(_ value: String) -> Style {
        set("-moz-perspective-origin", to: value)
    }

    public func msPerspectiveOrigin(_ value: String) -> Style {
        set("-ms-perspective-origin", to: value)
    }

    public func webkitPerspectiveOrigin(_ value: String) -> Style {
        set("-webkit-perspective-origin", to: value)
    }

    public func perspectiveOriginX(_ value: String) -> Style {
        set("perspective-origin-x", to: value)
    }

    public func webkitPerspectiveOriginX(_ value: String) -> Style {
        set("-webkit-perspective-origin-x", to: value)
    }

    public func perspectiveOriginY(_ value: String) -> Style {
        set("perspective-origin-y", to: value)
    }

    public func webkitPerspectiveOriginY(_ value: String) -> Style {
        set("-webkit-perspective-origin-y", to: value)
    }

    public func webkitPerspective(_ value: String) -> Style {
        set("-webkit-perspective", to: value)
    }

    public func pitch(_ value: String) -> Style {
        set("pitch", to: value)
    }

    public func pitchRange(_ value: String) -> Style {
        set("pitch-range", to: value)
    }

    public func placeContent(_ value: String) -> Style {
        set("place-content", to: value)
    }

    public func placeItems(_ value: String) -> Style {
        set("place-items", to: value)
    }

    public func placeSelf(_ value: String) -> Style {
        set("place-self", to: value)
    }

    public func playDuring(_ value: String) -> Style {
        set("play-during", to: value)
    }

    public func pointerEvents(_ value: String) -> Style {
        set("pointer-events", to: value)
    }

    public func position(_ value: String) -> Style {
        set("position", to: value)
    }

    public func positionAnimation(_ value: String) -> Style {
        set("position-animation", to: value)
    }

    public func positionFallback(_ value: String) -> Style {
        set("position-fallback", to: value)
    }

    public func positionFallbackBounds(_ value: String) -> Style {
        set("position-fallback-bounds", to: value)
    }

    public func positionTry(_ value: String) -> Style {
        set("position-try", to: value)
    }

    public func positionTryOptions(_ value: String) -> Style {
        set("position-try-options", to: value)
    }

    public func positionTryOrder(_ value: String) -> Style {
        set("position-try-order", to: value)
    }

    public func prefix(_ value: String) -> Style {
        set("prefix", to: value)
    }

    public func printColorAdjust(_ value: String) -> Style {
        set("print-color-adjust", to: value)
    }

    public func webkitPrintColorAdjust(_ value: String) -> Style {
        set("-webkit-print-color-adjust", to: value)
    }

    public func propertyName(_ value: String) -> Style {
        set("property-name", to: value)
    }

    public func quotes(_ value: String) -> Style {
        set("quotes", to: value)
    }

    public func r(_ value: String) -> Style {
        set("r", to: value)
    }

    public func range(_ value: String) -> Style {
        set("range", to: value)
    }

    public func webkitRegionBreakAfter(_ value: String) -> Style {
        set("-webkit-region-break-after", to: value)
    }

    public func webkitRegionBreakBefore(_ value: String) -> Style {
        set("-webkit-region-break-before", to: value)
    }

    public func webkitRegionBreakInside(_ value: String) -> Style {
        set("-webkit-region-break-inside", to: value)
    }

    public func regionFragment(_ value: String) -> Style {
        set("region-fragment", to: value)
    }

    public func webkitRegionFragment(_ value: String) -> Style {
        set("-webkit-region-fragment", to: value)
    }

    public func webkitRegionOverflow(_ value: String) -> Style {
        set("-webkit-region-overflow", to: value)
    }

    public func resize(_ value: String) -> Style {
        set("resize", to: value)
    }

    public func rest(_ value: String) -> Style {
        set("rest", to: value)
    }

    public func restAfter(_ value: String) -> Style {
        set("rest-after", to: value)
    }

    public func restBefore(_ value: String) -> Style {
        set("rest-before", to: value)
    }

    public func richness(_ value: String) -> Style {
        set("richness", to: value)
    }

    public func right(_ value: String) -> Style {
        set("right", to: value)
    }

    public func rotate(_ value: String) -> Style {
        set("rotate", to: value)
    }

    public func rowGap(_ value: String) -> Style {
        set("row-gap", to: value)
    }

    public func webkitRtlOrdering(_ value: String) -> Style {
        set("-webkit-rtl-ordering", to: value)
    }

    public func rubyAlign(_ value: String) -> Style {
        set("ruby-align", to: value)
    }

    public func rubyMerge(_ value: String) -> Style {
        set("ruby-merge", to: value)
    }

    public func rubyOverhang(_ value: String) -> Style {
        set("ruby-overhang", to: value)
    }

    public func rubyPosition(_ value: String) -> Style {
        set("ruby-position", to: value)
    }

    public func webkitRubyPosition(_ value: String) -> Style {
        set("-webkit-ruby-position", to: value)
    }

    public func running(_ value: String) -> Style {
        set("running", to: value)
    }

    public func rx(_ value: String) -> Style {
        set("rx", to: value)
    }

    public func ry(_ value: String) -> Style {
        set("ry", to: value)
    }

    public func scale(_ value: String) -> Style {
        set("scale", to: value)
    }

    public func scrollBehavior(_ value: String) -> Style {
        set("scroll-behavior", to: value)
    }

    public func msScrollChaining(_ value: String) -> Style {
        set("-ms-scroll-chaining", to: value)
    }

    public func msScrollLimit(_ value: String) -> Style {
        set("-ms-scroll-limit", to: value)
    }

    public func msScrollLimitXMax(_ value: String) -> Style {
        set("-ms-scroll-limit-x-max", to: value)
    }

    public func msScrollLimitXMin(_ value: String) -> Style {
        set("-ms-scroll-limit-x-min", to: value)
    }

    public func msScrollLimitYMax(_ value: String) -> Style {
        set("-ms-scroll-limit-y-max", to: value)
    }

    public func msScrollLimitYMin(_ value: String) -> Style {
        set("-ms-scroll-limit-y-min", to: value)
    }

    public func scrollMargin(_ value: String) -> Style {
        set("scroll-margin", to: value)
    }

    public func scrollMarginBlock(_ value: String) -> Style {
        set("scroll-margin-block", to: value)
    }

    public func scrollMarginBlockEnd(_ value: String) -> Style {
        set("scroll-margin-block-end", to: value)
    }

    public func scrollMarginBlockStart(_ value: String) -> Style {
        set("scroll-margin-block-start", to: value)
    }

    public func scrollMarginBottom(_ value: String) -> Style {
        set("scroll-margin-bottom", to: value)
    }

    public func scrollMarginInline(_ value: String) -> Style {
        set("scroll-margin-inline", to: value)
    }

    public func scrollMarginInlineEnd(_ value: String) -> Style {
        set("scroll-margin-inline-end", to: value)
    }

    public func scrollMarginInlineStart(_ value: String) -> Style {
        set("scroll-margin-inline-start", to: value)
    }

    public func scrollMarginLeft(_ value: String) -> Style {
        set("scroll-margin-left", to: value)
    }

    public func scrollMarginRight(_ value: String) -> Style {
        set("scroll-margin-right", to: value)
    }

    public func scrollMarginTop(_ value: String) -> Style {
        set("scroll-margin-top", to: value)
    }

    public func scrollPadding(_ value: String) -> Style {
        set("scroll-padding", to: value)
    }

    public func scrollPaddingBlock(_ value: String) -> Style {
        set("scroll-padding-block", to: value)
    }

    public func scrollPaddingBlockEnd(_ value: String) -> Style {
        set("scroll-padding-block-end", to: value)
    }

    public func scrollPaddingBlockStart(_ value: String) -> Style {
        set("scroll-padding-block-start", to: value)
    }

    public func scrollPaddingBottom(_ value: String) -> Style {
        set("scroll-padding-bottom", to: value)
    }

    public func scrollPaddingInline(_ value: String) -> Style {
        set("scroll-padding-inline", to: value)
    }

    public func scrollPaddingInlineEnd(_ value: String) -> Style {
        set("scroll-padding-inline-end", to: value)
    }

    public func scrollPaddingInlineStart(_ value: String) -> Style {
        set("scroll-padding-inline-start", to: value)
    }

    public func scrollPaddingLeft(_ value: String) -> Style {
        set("scroll-padding-left", to: value)
    }

    public func scrollPaddingRight(_ value: String) -> Style {
        set("scroll-padding-right", to: value)
    }

    public func scrollPaddingTop(_ value: String) -> Style {
        set("scroll-padding-top", to: value)
    }

    public func msScrollRails(_ value: String) -> Style {
        set("-ms-scroll-rails", to: value)
    }

    public func scrollSnapAlign(_ value: String) -> Style {
        set("scroll-snap-align", to: value)
    }

    public func scrollSnapCoordinate(_ value: String) -> Style {
        set("scroll-snap-coordinate", to: value)
    }

    public func webkitScrollSnapCoordinate(_ value: String) -> Style {
        set("-webkit-scroll-snap-coordinate", to: value)
    }

    public func scrollSnapDestination(_ value: String) -> Style {
        set("scroll-snap-destination", to: value)
    }

    public func webkitScrollSnapDestination(_ value: String) -> Style {
        set("-webkit-scroll-snap-destination", to: value)
    }

    public func scrollSnapMargin(_ value: String) -> Style {
        set("scroll-snap-margin", to: value)
    }

    public func scrollSnapMarginBottom(_ value: String) -> Style {
        set("scroll-snap-margin-bottom", to: value)
    }

    public func scrollSnapMarginLeft(_ value: String) -> Style {
        set("scroll-snap-margin-left", to: value)
    }

    public func scrollSnapMarginRight(_ value: String) -> Style {
        set("scroll-snap-margin-right", to: value)
    }

    public func scrollSnapMarginTop(_ value: String) -> Style {
        set("scroll-snap-margin-top", to: value)
    }

    public func scrollSnapPointsX(_ value: String) -> Style {
        set("scroll-snap-points-x", to: value)
    }

    public func msScrollSnapPointsX(_ value: String) -> Style {
        set("-ms-scroll-snap-points-x", to: value)
    }

    public func webkitScrollSnapPointsX(_ value: String) -> Style {
        set("-webkit-scroll-snap-points-x", to: value)
    }

    public func scrollSnapPointsY(_ value: String) -> Style {
        set("scroll-snap-points-y", to: value)
    }

    public func msScrollSnapPointsY(_ value: String) -> Style {
        set("-ms-scroll-snap-points-y", to: value)
    }

    public func webkitScrollSnapPointsY(_ value: String) -> Style {
        set("-webkit-scroll-snap-points-y", to: value)
    }

    public func scrollSnapStop(_ value: String) -> Style {
        set("scroll-snap-stop", to: value)
    }

    public func scrollSnapType(_ value: String) -> Style {
        set("scroll-snap-type", to: value)
    }

    public func msScrollSnapType(_ value: String) -> Style {
        set("-ms-scroll-snap-type", to: value)
    }

    public func webkitScrollSnapType(_ value: String) -> Style {
        set("-webkit-scroll-snap-type", to: value)
    }

    public func scrollSnapTypeX(_ value: String) -> Style {
        set("scroll-snap-type-x", to: value)
    }

    public func scrollSnapTypeY(_ value: String) -> Style {
        set("scroll-snap-type-y", to: value)
    }

    public func msScrollSnapX(_ value: String) -> Style {
        set("-ms-scroll-snap-x", to: value)
    }

    public func msScrollSnapY(_ value: String) -> Style {
        set("-ms-scroll-snap-y", to: value)
    }

    public func scrollTimeline(_ value: String) -> Style {
        set("scroll-timeline", to: value)
    }

    public func scrollTimelineAxis(_ value: String) -> Style {
        set("scroll-timeline-axis", to: value)
    }

    public func scrollTimelineName(_ value: String) -> Style {
        set("scroll-timeline-name", to: value)
    }

    public func msScrollTranslation(_ value: String) -> Style {
        set("-ms-scroll-translation", to: value)
    }

    public func scrollbarArrowColor(_ value: String) -> Style {
        set("scrollbar-arrow-color", to: value)
    }

    public func scrollbarBaseColor(_ value: String) -> Style {
        set("scrollbar-base-color", to: value)
    }

    public func scrollbarColor(_ value: String) -> Style {
        set("scrollbar-color", to: value)
    }

    public func scrollbarDarkShadowColor(_ value: String) -> Style {
        set("scrollbar-dark-shadow-color", to: value)
    }

    public func scrollbarDarkshadowColor(_ value: String) -> Style {
        set("scrollbar-darkshadow-color", to: value)
    }

    public func scrollbarFaceColor(_ value: String) -> Style {
        set("scrollbar-face-color", to: value)
    }

    public func scrollbarGutter(_ value: String) -> Style {
        set("scrollbar-gutter", to: value)
    }

    public func scrollbarHighlightColor(_ value: String) -> Style {
        set("scrollbar-highlight-color", to: value)
    }

    public func scrollbarShadowColor(_ value: String) -> Style {
        set("scrollbar-shadow-color", to: value)
    }

    public func scrollbarTrackColor(_ value: String) -> Style {
        set("scrollbar-track-color", to: value)
    }

    public func scrollbarWidth(_ value: String) -> Style {
        set("scrollbar-width", to: value)
    }

    public func scrollbar3dLightColor(_ value: String) -> Style {
        set("scrollbar3d-light-color", to: value)
    }

    public func scrollbar3dlightColor(_ value: String) -> Style {
        set("scrollbar3dlight-color", to: value)
    }

    public func shapeImageThreshold(_ value: String) -> Style {
        set("shape-image-threshold", to: value)
    }

    public func webkitShapeImageThreshold(_ value: String) -> Style {
        set("-webkit-shape-image-threshold", to: value)
    }

    public func shapeInside(_ value: String) -> Style {
        set("shape-inside", to: value)
    }

    public func webkitShapeInside(_ value: String) -> Style {
        set("-webkit-shape-inside", to: value)
    }

    public func shapeMargin(_ value: String) -> Style {
        set("shape-margin", to: value)
    }

    public func webkitShapeMargin(_ value: String) -> Style {
        set("-webkit-shape-margin", to: value)
    }

    public func shapeOutside(_ value: String) -> Style {
        set("shape-outside", to: value)
    }

    public func webkitShapeOutside(_ value: String) -> Style {
        set("-webkit-shape-outside", to: value)
    }

    public func webkitShapePadding(_ value: String) -> Style {
        set("-webkit-shape-padding", to: value)
    }

    public func shapeRendering(_ value: String) -> Style {
        set("shape-rendering", to: value)
    }

    public func size(_ value: String) -> Style {
        set("size", to: value)
    }

    public func sizeAdjust(_ value: String) -> Style {
        set("size-adjust", to: value)
    }

    public func snapHeight(_ value: String) -> Style {
        set("snap-height", to: value)
    }

    public func solidColor(_ value: String) -> Style {
        set("solid-color", to: value)
    }

    public func solidOpacity(_ value: String) -> Style {
        set("solid-opacity", to: value)
    }

    public func spatialNavigationAction(_ value: String) -> Style {
        set("spatial-navigation-action", to: value)
    }

    public func spatialNavigationContain(_ value: String) -> Style {
        set("spatial-navigation-contain", to: value)
    }

    public func spatialNavigationFunction(_ value: String) -> Style {
        set("spatial-navigation-function", to: value)
    }

    public func speak(_ value: String) -> Style {
        set("speak", to: value)
    }

    public func speakAs(_ value: String) -> Style {
        set("speak-as", to: value)
    }

    public func speakHeader(_ value: String) -> Style {
        set("speak-header", to: value)
    }

    public func speakNumeral(_ value: String) -> Style {
        set("speak-numeral", to: value)
    }

    public func speakPunctuation(_ value: String) -> Style {
        set("speak-punctuation", to: value)
    }

    public func speechRate(_ value: String) -> Style {
        set("speech-rate", to: value)
    }

    public func src(_ value: String) -> Style {
        set("src", to: value)
    }

    public func mozStackSizing(_ value: String) -> Style {
        set("-moz-stack-sizing", to: value)
    }

    public func stopColor(_ value: String) -> Style {
        set("stop-color", to: value)
    }

    public func stopOpacity(_ value: String) -> Style {
        set("stop-opacity", to: value)
    }

    public func stress(_ value: String) -> Style {
        set("stress", to: value)
    }

    public func stringSet(_ value: String) -> Style {
        set("string-set", to: value)
    }

    public func stroke(_ value: String) -> Style {
        set("stroke", to: value)
    }

    public func strokeAlign(_ value: String) -> Style {
        set("stroke-align", to: value)
    }

    public func strokeAlignment(_ value: String) -> Style {
        set("stroke-alignment", to: value)
    }

    public func strokeBreak(_ value: String) -> Style {
        set("stroke-break", to: value)
    }

    public func strokeColor(_ value: String) -> Style {
        set("stroke-color", to: value)
    }

    public func strokeDashCorner(_ value: String) -> Style {
        set("stroke-dash-corner", to: value)
    }

    public func strokeDashJustify(_ value: String) -> Style {
        set("stroke-dash-justify", to: value)
    }

    public func strokeDashadjust(_ value: String) -> Style {
        set("stroke-dashadjust", to: value)
    }

    public func strokeDasharray(_ value: String) -> Style {
        set("stroke-dasharray", to: value)
    }

    public func strokeDashcorner(_ value: String) -> Style {
        set("stroke-dashcorner", to: value)
    }

    public func strokeDashoffset(_ value: String) -> Style {
        set("stroke-dashoffset", to: value)
    }

    public func strokeImage(_ value: String) -> Style {
        set("stroke-image", to: value)
    }

    public func strokeLinecap(_ value: String) -> Style {
        set("stroke-linecap", to: value)
    }

    public func strokeLinejoin(_ value: String) -> Style {
        set("stroke-linejoin", to: value)
    }

    public func strokeMiterlimit(_ value: String) -> Style {
        set("stroke-miterlimit", to: value)
    }

    public func strokeOpacity(_ value: String) -> Style {
        set("stroke-opacity", to: value)
    }

    public func strokeOrigin(_ value: String) -> Style {
        set("stroke-origin", to: value)
    }

    public func strokePosition(_ value: String) -> Style {
        set("stroke-position", to: value)
    }

    public func strokeRepeat(_ value: String) -> Style {
        set("stroke-repeat", to: value)
    }

    public func strokeSize(_ value: String) -> Style {
        set("stroke-size", to: value)
    }

    public func strokeWidth(_ value: String) -> Style {
        set("stroke-width", to: value)
    }

    public func suffix(_ value: String) -> Style {
        set("suffix", to: value)
    }

    public func supportedColorSchemes(_ value: String) -> Style {
        set("supported-color-schemes", to: value)
    }

    public func webkitSvgShadow(_ value: String) -> Style {
        set("-webkit-svg-shadow", to: value)
    }

    public func symbols(_ value: String) -> Style {
        set("symbols", to: value)
    }

    public func syntax(_ value: String) -> Style {
        set("syntax", to: value)
    }

    public func system(_ value: String) -> Style {
        set("system", to: value)
    }

    public func tabSize(_ value: String) -> Style {
        set("tab-size", to: value)
    }

    public func mozTabSize(_ value: String) -> Style {
        set("-moz-tab-size", to: value)
    }

    public func oTabSize(_ value: String) -> Style {
        set("-o-tab-size", to: value)
    }

    public func oTableBaseline(_ value: String) -> Style {
        set("-o-table-baseline", to: value)
    }

    public func tableLayout(_ value: String) -> Style {
        set("table-layout", to: value)
    }

    public func webkitTapHighlightColor(_ value: String) -> Style {
        set("-webkit-tap-highlight-color", to: value)
    }

    public func textAlign(_ value: String) -> Style {
        set("text-align", to: value)
    }

    public func textAlignAll(_ value: String) -> Style {
        set("text-align-all", to: value)
    }

    public func textAlignLast(_ value: String) -> Style {
        set("text-align-last", to: value)
    }

    public func mozTextAlignLast(_ value: String) -> Style {
        set("-moz-text-align-last", to: value)
    }

    public func textAnchor(_ value: String) -> Style {
        set("text-anchor", to: value)
    }

    public func textAutospace(_ value: String) -> Style {
        set("text-autospace", to: value)
    }

    public func mozTextBlink(_ value: String) -> Style {
        set("-moz-text-blink", to: value)
    }

    public func textBoxEdge(_ value: String) -> Style {
        set("text-box-edge", to: value)
    }

    public func textBoxTrim(_ value: String) -> Style {
        set("text-box-trim", to: value)
    }

    public func msTextCombineHorizontal(_ value: String) -> Style {
        set("-ms-text-combine-horizontal", to: value)
    }

    public func textCombineUpright(_ value: String) -> Style {
        set("text-combine-upright", to: value)
    }

    public func webkitTextCombine(_ value: String) -> Style {
        set("-webkit-text-combine", to: value)
    }

    public func textDecoration(_ value: String) -> Style {
        set("text-decoration", to: value)
    }

    public func textDecorationBlink(_ value: String) -> Style {
        set("text-decoration-blink", to: value)
    }

    public func textDecorationColor(_ value: String) -> Style {
        set("text-decoration-color", to: value)
    }

    public func mozTextDecorationColor(_ value: String) -> Style {
        set("-moz-text-decoration-color", to: value)
    }

    public func webkitTextDecorationColor(_ value: String) -> Style {
        set("-webkit-text-decoration-color", to: value)
    }

    public func textDecorationLine(_ value: String) -> Style {
        set("text-decoration-line", to: value)
    }

    public func mozTextDecorationLine(_ value: String) -> Style {
        set("-moz-text-decoration-line", to: value)
    }

    public func textDecorationLineThrough(_ value: String) -> Style {
        set("text-decoration-line-through", to: value)
    }

    public func webkitTextDecorationLine(_ value: String) -> Style {
        set("-webkit-text-decoration-line", to: value)
    }

    public func textDecorationNone(_ value: String) -> Style {
        set("text-decoration-none", to: value)
    }

    public func textDecorationOverline(_ value: String) -> Style {
        set("text-decoration-overline", to: value)
    }

    public func textDecorationSkip(_ value: String) -> Style {
        set("text-decoration-skip", to: value)
    }

    public func textDecorationSkipBox(_ value: String) -> Style {
        set("text-decoration-skip-box", to: value)
    }

    public func textDecorationSkipInk(_ value: String) -> Style {
        set("text-decoration-skip-ink", to: value)
    }

    public func textDecorationSkipInset(_ value: String) -> Style {
        set("text-decoration-skip-inset", to: value)
    }

    public func textDecorationSkipSelf(_ value: String) -> Style {
        set("text-decoration-skip-self", to: value)
    }

    public func textDecorationSkipSpaces(_ value: String) -> Style {
        set("text-decoration-skip-spaces", to: value)
    }

    public func webkitTextDecorationSkip(_ value: String) -> Style {
        set("-webkit-text-decoration-skip", to: value)
    }

    public func textDecorationStyle(_ value: String) -> Style {
        set("text-decoration-style", to: value)
    }

    public func mozTextDecorationStyle(_ value: String) -> Style {
        set("-moz-text-decoration-style", to: value)
    }

    public func webkitTextDecorationStyle(_ value: String) -> Style {
        set("-webkit-text-decoration-style", to: value)
    }

    public func textDecorationThickness(_ value: String) -> Style {
        set("text-decoration-thickness", to: value)
    }

    public func textDecorationTrim(_ value: String) -> Style {
        set("text-decoration-trim", to: value)
    }

    public func textDecorationUnderline(_ value: String) -> Style {
        set("text-decoration-underline", to: value)
    }

    public func webkitTextDecoration(_ value: String) -> Style {
        set("-webkit-text-decoration", to: value)
    }

    public func webkitTextDecorationsInEffect(_ value: String) -> Style {
        set("-webkit-text-decorations-in-effect", to: value)
    }

    public func textEmphasis(_ value: String) -> Style {
        set("text-emphasis", to: value)
    }

    public func textEmphasisColor(_ value: String) -> Style {
        set("text-emphasis-color", to: value)
    }

    public func webkitTextEmphasisColor(_ value: String) -> Style {
        set("-webkit-text-emphasis-color", to: value)
    }

    public func textEmphasisPosition(_ value: String) -> Style {
        set("text-emphasis-position", to: value)
    }

    public func webkitTextEmphasisPosition(_ value: String) -> Style {
        set("-webkit-text-emphasis-position", to: value)
    }

    public func textEmphasisSkip(_ value: String) -> Style {
        set("text-emphasis-skip", to: value)
    }

    public func textEmphasisStyle(_ value: String) -> Style {
        set("text-emphasis-style", to: value)
    }

    public func webkitTextEmphasisStyle(_ value: String) -> Style {
        set("-webkit-text-emphasis-style", to: value)
    }

    public func webkitTextEmphasis(_ value: String) -> Style {
        set("-webkit-text-emphasis", to: value)
    }

    public func webkitTextFillColor(_ value: String) -> Style {
        set("-webkit-text-fill-color", to: value)
    }

    public func textGroupAlign(_ value: String) -> Style {
        set("text-group-align", to: value)
    }

    public func textIndent(_ value: String) -> Style {
        set("text-indent", to: value)
    }

    public func textJustify(_ value: String) -> Style {
        set("text-justify", to: value)
    }

    public func textJustifyTrim(_ value: String) -> Style {
        set("text-justify-trim", to: value)
    }

    public func textKashida(_ value: String) -> Style {
        set("text-kashida", to: value)
    }

    public func textKashidaSpace(_ value: String) -> Style {
        set("text-kashida-space", to: value)
    }

    public func textLineThrough(_ value: String) -> Style {
        set("text-line-through", to: value)
    }

    public func textLineThroughColor(_ value: String) -> Style {
        set("text-line-through-color", to: value)
    }

    public func textLineThroughMode(_ value: String) -> Style {
        set("text-line-through-mode", to: value)
    }

    public func textLineThroughStyle(_ value: String) -> Style {
        set("text-line-through-style", to: value)
    }

    public func textLineThroughWidth(_ value: String) -> Style {
        set("text-line-through-width", to: value)
    }

    public func textOrientation(_ value: String) -> Style {
        set("text-orientation", to: value)
    }

    public func webkitTextOrientation(_ value: String) -> Style {
        set("-webkit-text-orientation", to: value)
    }

    public func textOverflow(_ value: String) -> Style {
        set("text-overflow", to: value)
    }

    public func textOverline(_ value: String) -> Style {
        set("text-overline", to: value)
    }

    public func textOverlineColor(_ value: String) -> Style {
        set("text-overline-color", to: value)
    }

    public func textOverlineMode(_ value: String) -> Style {
        set("text-overline-mode", to: value)
    }

    public func textOverlineStyle(_ value: String) -> Style {
        set("text-overline-style", to: value)
    }

    public func textOverlineWidth(_ value: String) -> Style {
        set("text-overline-width", to: value)
    }

    public func textRendering(_ value: String) -> Style {
        set("text-rendering", to: value)
    }

    public func webkitTextSecurity(_ value: String) -> Style {
        set("-webkit-text-security", to: value)
    }

    public func textShadow(_ value: String) -> Style {
        set("text-shadow", to: value)
    }

    public func textSizeAdjust(_ value: String) -> Style {
        set("text-size-adjust", to: value)
    }

    public func mozTextSizeAdjust(_ value: String) -> Style {
        set("-moz-text-size-adjust", to: value)
    }

    public func msTextSizeAdjust(_ value: String) -> Style {
        set("-ms-text-size-adjust", to: value)
    }

    public func webkitTextSizeAdjust(_ value: String) -> Style {
        set("-webkit-text-size-adjust", to: value)
    }

    public func textSpacing(_ value: String) -> Style {
        set("text-spacing", to: value)
    }

    public func textSpacingTrim(_ value: String) -> Style {
        set("text-spacing-trim", to: value)
    }

    public func webkitTextStrokeColor(_ value: String) -> Style {
        set("-webkit-text-stroke-color", to: value)
    }

    public func webkitTextStroke(_ value: String) -> Style {
        set("-webkit-text-stroke", to: value)
    }

    public func webkitTextStrokeWidth(_ value: String) -> Style {
        set("-webkit-text-stroke-width", to: value)
    }

    public func textTransform(_ value: String) -> Style {
        set("text-transform", to: value)
    }

    public func textUnderline(_ value: String) -> Style {
        set("text-underline", to: value)
    }

    public func textUnderlineColor(_ value: String) -> Style {
        set("text-underline-color", to: value)
    }

    public func textUnderlineMode(_ value: String) -> Style {
        set("text-underline-mode", to: value)
    }

    public func textUnderlineOffset(_ value: String) -> Style {
        set("text-underline-offset", to: value)
    }

    public func textUnderlinePosition(_ value: String) -> Style {
        set("text-underline-position", to: value)
    }

    public func webkitTextUnderlinePosition(_ value: String) -> Style {
        set("-webkit-text-underline-position", to: value)
    }

    public func textUnderlineStyle(_ value: String) -> Style {
        set("text-underline-style", to: value)
    }

    public func textUnderlineWidth(_ value: String) -> Style {
        set("text-underline-width", to: value)
    }

    public func textWrap(_ value: String) -> Style {
        set("text-wrap", to: value)
    }

    public func textWrapMode(_ value: String) -> Style {
        set("text-wrap-mode", to: value)
    }

    public func textWrapStyle(_ value: String) -> Style {
        set("text-wrap-style", to: value)
    }

    public func webkitTextZoom(_ value: String) -> Style {
        set("-webkit-text-zoom", to: value)
    }

    public func timelineScope(_ value: String) -> Style {
        set("timeline-scope", to: value)
    }

    public func top(_ value: String) -> Style {
        set("top", to: value)
    }

    public func touchAction(_ value: String) -> Style {
        set("touch-action", to: value)
    }

    public func touchActionDelay(_ value: String) -> Style {
        set("touch-action-delay", to: value)
    }

    public func msTouchAction(_ value: String) -> Style {
        set("-ms-touch-action", to: value)
    }

    public func webkitTouchCallout(_ value: String) -> Style {
        set("-webkit-touch-callout", to: value)
    }

    public func msTouchSelect(_ value: String) -> Style {
        set("-ms-touch-select", to: value)
    }

    public func appleTrailingWord(_ value: String) -> Style {
        set("-apple-trailing-word", to: value)
    }

    public func transform(_ value: String) -> Style {
        set("transform", to: value)
    }

    public func transformBox(_ value: String) -> Style {
        set("transform-box", to: value)
    }

    public func mozTransform(_ value: String) -> Style {
        set("-moz-transform", to: value)
    }

    public func msTransform(_ value: String) -> Style {
        set("-ms-transform", to: value)
    }

    public func oTransform(_ value: String) -> Style {
        set("-o-transform", to: value)
    }

    public func transformOrigin(_ value: String) -> Style {
        set("transform-origin", to: value)
    }

    public func mozTransformOrigin(_ value: String) -> Style {
        set("-moz-transform-origin", to: value)
    }

    public func msTransformOrigin(_ value: String) -> Style {
        set("-ms-transform-origin", to: value)
    }

    public func oTransformOrigin(_ value: String) -> Style {
        set("-o-transform-origin", to: value)
    }

    public func webkitTransformOrigin(_ value: String) -> Style {
        set("-webkit-transform-origin", to: value)
    }

    public func transformOriginX(_ value: String) -> Style {
        set("transform-origin-x", to: value)
    }

    public func webkitTransformOriginX(_ value: String) -> Style {
        set("-webkit-transform-origin-x", to: value)
    }

    public func transformOriginY(_ value: String) -> Style {
        set("transform-origin-y", to: value)
    }

    public func webkitTransformOriginY(_ value: String) -> Style {
        set("-webkit-transform-origin-y", to: value)
    }

    public func transformOriginZ(_ value: String) -> Style {
        set("transform-origin-z", to: value)
    }

    public func webkitTransformOriginZ(_ value: String) -> Style {
        set("-webkit-transform-origin-z", to: value)
    }

    public func transformStyle(_ value: String) -> Style {
        set("transform-style", to: value)
    }

    public func mozTransformStyle(_ value: String) -> Style {
        set("-moz-transform-style", to: value)
    }

    public func msTransformStyle(_ value: String) -> Style {
        set("-ms-transform-style", to: value)
    }

    public func webkitTransformStyle(_ value: String) -> Style {
        set("-webkit-transform-style", to: value)
    }

    public func webkitTransform(_ value: String) -> Style {
        set("-webkit-transform", to: value)
    }

    public func transition(_ value: String) -> Style {
        set("transition", to: value)
    }

    public func transitionBehavior(_ value: String) -> Style {
        set("transition-behavior", to: value)
    }

    public func transitionDelay(_ value: String) -> Style {
        set("transition-delay", to: value)
    }

    public func mozTransitionDelay(_ value: String) -> Style {
        set("-moz-transition-delay", to: value)
    }

    public func msTransitionDelay(_ value: String) -> Style {
        set("-ms-transition-delay", to: value)
    }

    public func oTransitionDelay(_ value: String) -> Style {
        set("-o-transition-delay", to: value)
    }

    public func webkitTransitionDelay(_ value: String) -> Style {
        set("-webkit-transition-delay", to: value)
    }

    public func transitionDuration(_ value: String) -> Style {
        set("transition-duration", to: value)
    }

    public func mozTransitionDuration(_ value: String) -> Style {
        set("-moz-transition-duration", to: value)
    }

    public func msTransitionDuration(_ value: String) -> Style {
        set("-ms-transition-duration", to: value)
    }

    public func oTransitionDuration(_ value: String) -> Style {
        set("-o-transition-duration", to: value)
    }

    public func webkitTransitionDuration(_ value: String) -> Style {
        set("-webkit-transition-duration", to: value)
    }

    public func mozTransition(_ value: String) -> Style {
        set("-moz-transition", to: value)
    }

    public func msTransition(_ value: String) -> Style {
        set("-ms-transition", to: value)
    }

    public func oTransition(_ value: String) -> Style {
        set("-o-transition", to: value)
    }

    public func transitionProperty(_ value: String) -> Style {
        set("transition-property", to: value)
    }

    public func mozTransitionProperty(_ value: String) -> Style {
        set("-moz-transition-property", to: value)
    }

    public func msTransitionProperty(_ value: String) -> Style {
        set("-ms-transition-property", to: value)
    }

    public func oTransitionProperty(_ value: String) -> Style {
        set("-o-transition-property", to: value)
    }

    public func webkitTransitionProperty(_ value: String) -> Style {
        set("-webkit-transition-property", to: value)
    }

    public func transitionTimingFunction(_ value: String) -> Style {
        set("transition-timing-function", to: value)
    }

    public func mozTransitionTimingFunction(_ value: String) -> Style {
        set("-moz-transition-timing-function", to: value)
    }

    public func msTransitionTimingFunction(_ value: String) -> Style {
        set("-ms-transition-timing-function", to: value)
    }

    public func oTransitionTimingFunction(_ value: String) -> Style {
        set("-o-transition-timing-function", to: value)
    }

    public func webkitTransitionTimingFunction(_ value: String) -> Style {
        set("-webkit-transition-timing-function", to: value)
    }

    public func webkitTransition(_ value: String) -> Style {
        set("-webkit-transition", to: value)
    }

    public func translate(_ value: String) -> Style {
        set("translate", to: value)
    }

    public func ucAltSkin(_ value: String) -> Style {
        set("uc-alt-skin", to: value)
    }

    public func ucSkin(_ value: String) -> Style {
        set("uc-skin", to: value)
    }

    public func unicodeBidi(_ value: String) -> Style {
        set("unicode-bidi", to: value)
    }

    public func unicodeRange(_ value: String) -> Style {
        set("unicode-range", to: value)
    }

    public func webkitUserDrag(_ value: String) -> Style {
        set("-webkit-user-drag", to: value)
    }

    public func mozUserFocus(_ value: String) -> Style {
        set("-moz-user-focus", to: value)
    }

    public func mozUserInput(_ value: String) -> Style {
        set("-moz-user-input", to: value)
    }

    public func mozUserModify(_ value: String) -> Style {
        set("-moz-user-modify", to: value)
    }

    public func webkitUserModify(_ value: String) -> Style {
        set("-webkit-user-modify", to: value)
    }

    public func userSelect(_ value: String) -> Style {
        set("user-select", to: value)
    }

    public func mozUserSelect(_ value: String) -> Style {
        set("-moz-user-select", to: value)
    }

    public func msUserSelect(_ value: String) -> Style {
        set("-ms-user-select", to: value)
    }

    public func webkitUserSelect(_ value: String) -> Style {
        set("-webkit-user-select", to: value)
    }

    public func userZoom(_ value: String) -> Style {
        set("user-zoom", to: value)
    }

    public func vectorEffect(_ value: String) -> Style {
        set("vector-effect", to: value)
    }

    public func verticalAlign(_ value: String) -> Style {
        set("vertical-align", to: value)
    }

    public func viewTimeline(_ value: String) -> Style {
        set("view-timeline", to: value)
    }

    public func viewTimelineAxis(_ value: String) -> Style {
        set("view-timeline-axis", to: value)
    }

    public func viewTimelineInset(_ value: String) -> Style {
        set("view-timeline-inset", to: value)
    }

    public func viewTimelineName(_ value: String) -> Style {
        set("view-timeline-name", to: value)
    }

    public func viewTransitionName(_ value: String) -> Style {
        set("view-transition-name", to: value)
    }

    public func viewportFill(_ value: String) -> Style {
        set("viewport-fill", to: value)
    }

    public func viewportFillOpacity(_ value: String) -> Style {
        set("viewport-fill-opacity", to: value)
    }

    public func viewportFit(_ value: String) -> Style {
        set("viewport-fit", to: value)
    }

    public func visibility(_ value: String) -> Style {
        set("visibility", to: value)
    }

    public func voiceBalance(_ value: String) -> Style {
        set("voice-balance", to: value)
    }

    public func voiceDuration(_ value: String) -> Style {
        set("voice-duration", to: value)
    }

    public func voiceFamily(_ value: String) -> Style {
        set("voice-family", to: value)
    }

    public func voicePitch(_ value: String) -> Style {
        set("voice-pitch", to: value)
    }

    public func voiceRange(_ value: String) -> Style {
        set("voice-range", to: value)
    }

    public func voiceRate(_ value: String) -> Style {
        set("voice-rate", to: value)
    }

    public func voiceStress(_ value: String) -> Style {
        set("voice-stress", to: value)
    }

    public func voiceVolume(_ value: String) -> Style {
        set("voice-volume", to: value)
    }

    public func volume(_ value: String) -> Style {
        set("volume", to: value)
    }

    public func whiteSpace(_ value: String) -> Style {
        set("white-space", to: value)
    }

    public func whiteSpaceCollapse(_ value: String) -> Style {
        set("white-space-collapse", to: value)
    }

    public func whiteSpaceTrim(_ value: String) -> Style {
        set("white-space-trim", to: value)
    }

    public func webkitWidgetRegion(_ value: String) -> Style {
        set("-webkit-widget-region", to: value)
    }

    public func widows(_ value: String) -> Style {
        set("widows", to: value)
    }

    public func width(_ value: String) -> Style {
        set("width", to: value)
    }

    public func willChange(_ value: String) -> Style {
        set("will-change", to: value)
    }

    public func mozWindowDragging(_ value: String) -> Style {
        set("-moz-window-dragging", to: value)
    }

    public func mozWindowShadow(_ value: String) -> Style {
        set("-moz-window-shadow", to: value)
    }

    public func wordBreak(_ value: String) -> Style {
        set("word-break", to: value)
    }

    public func wordSpaceTransform(_ value: String) -> Style {
        set("word-space-transform", to: value)
    }

    public func wordSpacing(_ value: String) -> Style {
        set("word-spacing", to: value)
    }

    public func wordWrap(_ value: String) -> Style {
        set("word-wrap", to: value)
    }

    public func wrapAfter(_ value: String) -> Style {
        set("wrap-after", to: value)
    }

    public func wrapBefore(_ value: String) -> Style {
        set("wrap-before", to: value)
    }

    public func wrapFlow(_ value: String) -> Style {
        set("wrap-flow", to: value)
    }

    public func msWrapFlow(_ value: String) -> Style {
        set("-ms-wrap-flow", to: value)
    }

    public func webkitWrapFlow(_ value: String) -> Style {
        set("-webkit-wrap-flow", to: value)
    }

    public func wrapInside(_ value: String) -> Style {
        set("wrap-inside", to: value)
    }

    public func msWrapMargin(_ value: String) -> Style {
        set("-ms-wrap-margin", to: value)
    }

    public func webkitWrapMargin(_ value: String) -> Style {
        set("-webkit-wrap-margin", to: value)
    }

    public func webkitWrapPadding(_ value: String) -> Style {
        set("-webkit-wrap-padding", to: value)
    }

    public func webkitWrapShapeInside(_ value: String) -> Style {
        set("-webkit-wrap-shape-inside", to: value)
    }

    public func webkitWrapShapeOutside(_ value: String) -> Style {
        set("-webkit-wrap-shape-outside", to: value)
    }

    public func wrapThrough(_ value: String) -> Style {
        set("wrap-through", to: value)
    }

    public func msWrapThrough(_ value: String) -> Style {
        set("-ms-wrap-through", to: value)
    }

    public func webkitWrapThrough(_ value: String) -> Style {
        set("-webkit-wrap-through", to: value)
    }

    public func webkitWrap(_ value: String) -> Style {
        set("-webkit-wrap", to: value)
    }

    public func writingMode(_ value: String) -> Style {
        set("writing-mode", to: value)
    }

    public func webkitWritingMode(_ value: String) -> Style {
        set("-webkit-writing-mode", to: value)
    }

    public func x(_ value: String) -> Style {
        set("x", to: value)
    }

    public func y(_ value: String) -> Style {
        set("y", to: value)
    }

    public func zIndex(_ value: String) -> Style {
        set("z-index", to: value)
    }

    public func zoom(_ value: String) -> Style {
        set("zoom", to: value)
    }
    // @end
}

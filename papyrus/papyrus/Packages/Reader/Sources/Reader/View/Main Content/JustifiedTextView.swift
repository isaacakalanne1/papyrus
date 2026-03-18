//
//  JustifiedTextView.swift
//  Reader
//

import SwiftUI
import UIKit
import CoreText

struct JustifiedTextView: View {
    let text: String
    let fontSize: CGFloat

    @State private var height: CGFloat = .zero

    var body: some View {
        GeometryReader { geometry in
            JustifiedTextViewRepresentable(
                text: text,
                fontSize: fontSize,
                width: geometry.size.width,
                height: $height
            )
        }
        .frame(maxWidth: .infinity, minHeight: height)
    }
}

// MARK: - Word-spacing justification

/// Builds an attributed string where inter-word kern values are set so that
/// each line (except the last line of a paragraph) fills `containerWidth`
/// exactly — without ever touching letter spacing on non-space characters.
///
/// Strategy:
///   1. Create a CTFramesetter from the base attributed string with .left
///      alignment so CoreText gives us natural line widths.
///   2. For every line except the last in a paragraph, compute the surplus
///      width and divide it equally across the space characters in that line.
///   3. Inject NSKern on each space character. The result is a new attributed
///      string that, when rendered with .left alignment, looks like word-spaced
///      justified text with no letter-spacing changes.
private func wordSpaceJustified(
    _ attributedString: NSAttributedString,
    containerWidth: CGFloat
) -> NSAttributedString {
    guard containerWidth > 0 else { return attributedString }

    let framePath = CGPath(
        rect: CGRect(x: 0, y: 0, width: containerWidth, height: CGFloat.greatestFiniteMagnitude),
        transform: nil
    )
    let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
    let frame = CTFramesetterCreateFrame(
        framesetter,
        CFRangeMake(0, attributedString.length),
        framePath,
        nil
    )

    let lines = CTFrameGetLines(frame) as! [CTLine]
    guard !lines.isEmpty else { return attributedString }

    let mutable = NSMutableAttributedString(attributedString: attributedString)

    // CoreText lays out from bottom-left; the last line of the *entire* frame
    // is visually at the top in flipped coordinates, but we identify paragraph
    // last lines by checking whether the character range ends at a newline or
    // at the end of the string.
    let fullString = attributedString.string as NSString

    for (lineIndex, line) in lines.enumerated() {
        let lineRange = CTLineGetStringRange(line)
        let lineStart = lineRange.location
        let lineLength = lineRange.length

        guard lineLength > 0,
              lineStart != NSNotFound,
              lineStart + lineLength <= attributedString.length
        else { continue }

        // Determine whether this is the last line of its paragraph.
        // The last line of a paragraph ends at a '\n' or at the end of the string.
        let isLastLineInFrame = (lineIndex == lines.count - 1)
        let lineEndIndex = lineStart + lineLength
        let charAfterLine: Character? = lineEndIndex < fullString.length
            ? Character(String(fullString.character(at: lineEndIndex) == 0x0A ? "\n" : "X"))
            : nil
        let endsWithNewline = lineEndIndex <= fullString.length &&
            lineEndIndex > 0 &&
            fullString.character(at: lineEndIndex - 1) == 0x0A
        let isLastLineOfParagraph = isLastLineInFrame || endsWithNewline || charAfterLine == "\n"

        if isLastLineOfParagraph { continue }

        // Find space character positions within this line's range.
        let nsLineRange = NSRange(location: lineStart, length: lineLength)
        var spaceRanges: [NSRange] = []
        fullString.enumerateSubstrings(
            in: nsLineRange,
            options: [.byComposedCharacterSequences]
        ) { substring, substringRange, _, _ in
            if substring == " " {
                spaceRanges.append(substringRange)
            }
        }

        guard !spaceRanges.isEmpty else { continue }

        // Measure the line's natural typographic width (without trailing whitespace).
        let naturalWidth = CGFloat(CTLineGetTypographicBounds(line, nil, nil, nil))
        let trailingWhitespace = CGFloat(CTLineGetTrailingWhitespaceWidth(line))
        let usedWidth = naturalWidth - trailingWhitespace

        let surplus = containerWidth - usedWidth
        guard surplus > 0 else { continue }

        let additionalKernPerSpace = surplus / CGFloat(spaceRanges.count)

        for spaceRange in spaceRanges {
            // Preserve any existing kern on this character (typically zero).
            let existingKern = (mutable.attribute(.kern, at: spaceRange.location, effectiveRange: nil) as? CGFloat) ?? 0
            mutable.addAttribute(
                .kern,
                value: existingKern + additionalKernPerSpace,
                range: spaceRange
            )
        }
    }

    return mutable
}

// MARK: - UIViewRepresentable

private struct JustifiedTextViewRepresentable: UIViewRepresentable {
    let text: String
    let fontSize: CGFloat
    let width: CGFloat
    @Binding var height: CGFloat

    // MARK: Base attributes (alignment is .left — justification is done manually)

    private func baseAttributes() -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 8

        return [
            .font: UIFont(name: "Georgia", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor(red: 0.2, green: 0.15, blue: 0.1, alpha: 1)
        ]
    }

    // MARK: UIViewRepresentable

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.widthTracksTextView = false
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        textView.textContainer.size = CGSize(width: width, height: .greatestFiniteMagnitude)

        let base = NSAttributedString(string: text, attributes: baseAttributes())
        let justified = wordSpaceJustified(base, containerWidth: width)
        textView.attributedText = justified

        DispatchQueue.main.async {
            let newHeight = textView.sizeThatFits(
                CGSize(width: width, height: .greatestFiniteMagnitude)
            ).height
            if newHeight != self.height {
                self.height = newHeight
            }
        }
    }
}

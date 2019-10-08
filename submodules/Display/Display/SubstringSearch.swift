import UIKit

public func findSubstringRanges(in string: String, query: String) -> ([Range<String.Index>], String) {
    var ranges: [Range<String.Index>] = []
    let queryWords = query.split { !$0.isLetter && !$0.isNumber && $0 != "#" && $0 != "@" }.filter { !$0.isEmpty && !["#", "@"].contains($0) }.map { $0.lowercased() }
    
    let text = string.lowercased()
    let searchRange = text.startIndex ..< text.endIndex
    text.enumerateSubstrings(in: searchRange, options: .byWords) { (substring, range, _, _) in
        guard let substring = substring else {
            return
        }
        for var word in queryWords {
            var count = 0
            var hasLeadingSymbol = false
            if word.hasPrefix("#") || word.hasPrefix("@") {
                hasLeadingSymbol = true
                word.removeFirst()
            }
            inner: for (c1, c2) in zip(word, substring) {
                if c1 != c2 {
                    break inner
                }
                count += 1
            }
            if count > 0 {
                let length = Double(max(word.count, substring.count))
                if length > 0 {
                    let difference = abs(length - Double(count))
                    let rating = difference / length
                    if rating < 0.33 {
                        var range = range
                        if hasLeadingSymbol && range.lowerBound > searchRange.lowerBound {
                            range = text.index(before: range.lowerBound)..<range.upperBound
                        }
                        ranges.append(range)
                    }
                }
            }
        }
    }
    return (ranges, text)
}
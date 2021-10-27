import Foundation

/// Conforms Matrix to `CustomStringConvertible` so it can be printed directly
extension Matrix: CustomStringConvertible {
    /// Custom textual representation of a `Matrix`
    public func description(separatedBy separator: String = ", ", balanceWidths: Bool = true, indentCount: Int = 0) -> String {
        // The stringified elements of the array
        var elements = _matrixArray.map({"\($0)"})

        // The width of the largest element string
        let maxElementWidth = elements.map({ $0.count }).max() ?? 0

        // Collect each processed line
        var results: [String] = []

        // User-specified indent string prepended to each line
        let indent = String(repeating: " ", count: indentCount)

        // For each row
        for _ in 0 ..< height {
            // Collect the elements of the row
            let line = elements.prefix(width); elements.removeFirst(width)

            // Produce a string representation of the row
            let lineString = line
                .map({
                    let prefix = balanceWidths
                        ? String(repeating: " ", count: maxElementWidth - $0.count)
                        : ""
                    return prefix + $0 })
                .joined(separator: separator)
            results.append(indent + lineString)
        }
        
        return results.joined(separator: "\n")
    }

    /// Custom textual representation of a `Matrix`
    public var description: String {
        description()
    }
}

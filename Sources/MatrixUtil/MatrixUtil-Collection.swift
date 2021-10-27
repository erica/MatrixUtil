import Foundation

extension Matrix: Collection {
    /// The collection's starting index.
    public var startIndex: Int { backingArray.startIndex }
    /// The collection's end index.
    public var endIndex: Int { backingArray.endIndex }
    /// Returns an index following the one supplied.
    public func index(after i: Int) -> Int { backingArray.index(after: i) }
    /// The indices valid for accessing this `Matrix` in ascending order
    public var indices: Range<Int> { backingArray.indices }
}

extension Matrix: Sequence {
    public typealias Iterator = Array<Element>.Iterator

    /// Return an iterator suitable for traversing the elements of this `Matrix` collection
    public func makeIterator() -> Iterator {
        return backingArray.makeIterator()
    }
}

// Point iteration
extension Matrix {
    /// Iterate in a matrix from (startX, startY) to (width - 1, height - 1) wrapping
    /// back to startX at the end of each row. The iteration continues until the
    /// max position is reached.
    ///
    /// For example:
    ///
    ///    let width = 4
    ///    let matrix = Matrix(width: width, array: Array(1 ... 12))
    ///    matrix.forEach(fromX: 1, y: 0) { x, _, value in
    ///        if value < 10 { print(" ", terminator: "")}
    ///        if value < 100 { print(" ", terminator: "")}
    ///        print(value, terminator: "")
    ///        if x == matrix.width - 1 { print() }
    ///    }
    ///
    ///    - Parameter startX: the zero-indexed starting position along the x axis (columns) of the matrix
    ///    - Parameter startY: the zero-indexed starting position along the y axis (rows) of the matrix
    ///    - Parameter action: a closure to apply at each point
    ///             - x: the current zero-indexed x position
    ///             - y: the current zero-indexed y position
    ///             - value: the current value at `self[x, y]`
    ///
    ///    - Warning: No bounds checks are made for index correctness.
    public func forEach(fromX startX: Int = 0, y startY: Int = 0, _ action: (_ x: Int, _ y: Int, _ value: Element) -> Void) {
        for (y, x) in CartesianSequence(startY ..< height, startX ..< width) {
            action(x, y, self[x, y])
        }
    }
}

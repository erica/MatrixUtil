import Foundation

/// An array-backed 2-D storage instance that can be acessed by (x, y) indexing.
public struct Matrix <Element> {

    /// Private backing array for the matrix
    internal var _matrixArray: [Element]

    /// The width and height of the matrix
    public let (width, height): (Int, Int)

    /// The matrix's backing array, a simple array of elements
    public var backingArray: [Element] { _matrixArray }

    /// Directly index the backing array with a subscript.
    ///
    /// Rows wrap from one to the next, following the flat array layout
    public subscript(_ idx: Int) -> Element {
        get { _matrixArray[idx] }
        set { _matrixArray[idx] = newValue }
    }

    /// Index the backing array using zero-based x and y coordinates.
    ///
    /// -- Note: Deliberately designed to use geometrix (x, y) indexing rather than
    ///     computer-based (y, x) indexing. One-based coordinates were considered
    ///     for the design but rejected.
    public subscript(_ x: Int, _ y: Int) -> Element {
        get { _matrixArray[y * width + x] }
        set { _matrixArray[y * width + x] = newValue }
    }

    /// The backing array index for a matrix point
    public func index(of x: Int, _ y: Int) -> Int {
        y * width + x
    }

    /// Create a new `Matrix` instance using the supplied initial value
    public init(width: Int, height: Int, initialValue: Element) {
        (self.width, self.height) = (width, height)
        self._matrixArray = Array<Element>.init(repeating: initialValue, count: width * height)
    }

    /// Create a new `Matrix` instance using the supplied backing array as its initial storage
    public init(width: Int, array: [Element]) {
        (self.width, height) = (width, array.count / width)
        self._matrixArray = array
    }
}

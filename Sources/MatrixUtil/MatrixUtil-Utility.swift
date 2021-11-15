import Foundation

extension Matrix {
    /// Returns the indices of the available grid cells surrounding a given point along its edges.
    ///
    /// Indices of elements falling outside the `Matrix` grid are omitted.
    ///
    /// - Note: Edge neighbors do not include diagonals
    public func edgeNeighbors(ofX x: Int, y: Int) -> [PointIndex] {
        [PointIndex(x: x - 1, y: y), PointIndex(x: x + 1, y: y), PointIndex(x: x, y: y - 1), PointIndex(x: x, y: y + 1)]
            .filter({ point in
                point.x >= 0 && point.y >= 0 && point.x < width && point.y < height })
    }

    /// Returns the indices of the diagonal grid cells surrounding a given point along its edges.
    ///
    /// Indices of elements falling outside the `Matrix` grid are omitted.
    public func cornerNeighbors(ofX x: Int, y: Int) -> [PointIndex] {
        [PointIndex(x: x - 1, y: y - 1), PointIndex(x: x + 1, y: y + 1), PointIndex(x: x + 1, y: y - 1), PointIndex(x: x - 1, y: y + 1)]
            .filter({ point in
                point.x >= 0 && point.y >= 0 && point.x < width && point.y < height })
    }

    /// Returns all the indices of the available grid cells surrounding a given point.
    ///
    /// Indices of elements falling outside the `Matrix` grid are omitted.
    public func neighbors(ofX x: Int, y: Int) -> [PointIndex] {
        var results: [PointIndex] = []
        for xOffset in -1 ... 1 {
            for yOffset in -1 ... 1 {
                if (xOffset == 0) && (yOffset == 0) { continue }
                if (x + xOffset) < 0 || (x + xOffset) >= width { continue }
                if (y + yOffset) < 0 || (y + yOffset) >= height { continue }
                results.append(PointIndex(x: x + xOffset, y: y + yOffset))
            }
        }
        return results
    }

    /// Copy the values from the source `matrix` to `self`'s storage
    ///
    /// - Parameter matrix: the source `Matrix`
    /// - Parameter x: the target x coordinate in `self`
    /// - Parameter y: the target y coordinate in `self`
    ///
    public mutating func copy(_ matrix: Matrix, toX x: Int, y: Int) {
        guard x >= 0, y >= 0, x < width, y < height else { return }
        for xIndex in x ..< x + matrix.width {
            guard xIndex < width else { continue }
            for yIndex in y ..< y + matrix.height {
                guard yIndex < height else { continue }
                self[xIndex, yIndex] = matrix[xIndex - x, yIndex - y]
            }
        }
    }

    /// Copy the values in the source `matrix` from (x, y) to a new `Matrix` instance
    public func subMatrixFrom(_ start: PointIndex, to end: PointIndex = PointIndex(x: .max, y: .max)) -> Matrix {
        let end = PointIndex(x: Swift.min(end.x, width - 1), y: Swift.min(end.y, height - 1))
        var values: [Element] = []
        forEach(from: start, to: end) {_, _, value in values.append(value) }
        return Matrix(width: 1 + end.x - start.x, array: values)
    }
}

extension Matrix {
    /// Returns a Matrix  of strings describing each element
    public func stringified() -> Matrix<String> {
        Matrix<String>(width: width, array: backingArray.map({ (element: Element) -> String in  "\(element)" }))
    }
}

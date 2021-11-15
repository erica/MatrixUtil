import Foundation

extension Matrix {
    /// Returns a matrix where each row is reversed in order
    public func mirroredAcrossX() -> Matrix<Element> {
        var matrix = self
        for (y, x) in CartesianSequence(0 ..< height, 0 ..< width) {
            matrix[x, y] = self[width - (x + 1), y]
        }
        return matrix
    }

    /// Returns a matrix whose rows are in reversed order
    public func mirroredAcrossY() -> Matrix<Element> {
        var matrix = self
        for (y, x) in CartesianSequence(0 ..< height, 0 ..< width) {
            matrix[x, y] = self[x, height - (y + 1)]
        }
        return matrix
    }

    /// Returns a matrix whose rows and columns are rotated -90 degrees
    public func rotateRight() -> Matrix<Element> {
        var matrix = Matrix(width: height, height: width, initialValue: self[0, 0])
        for (y, x) in CartesianSequence(0 ..< height, 0 ..< width) {
            matrix[height - (y + 1), x] = self[x, y]
        }
        return matrix
    }

    /// Returns a matrix whose rows and columns are rotated +90 degrees
    /// - Note: This could be self.rotateRight().rotateRight().RotateRight()
    public func rotateLeft() -> Matrix<Element> {
        var matrix = Matrix(width: height, height: width, initialValue: self[0, 0])
        for (y, x) in CartesianSequence(0 ..< height, 0 ..< width) {
            matrix[y, width - (x + 1)] = self[x, y]
        }
        return matrix
    }
}

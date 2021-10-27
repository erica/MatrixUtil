import Foundation

extension Matrix {
    /// Returns `count` random point-based indices
    public func randomPointIndices(count: Int) -> [PointIndex] {
        Array(pointIndices.shuffled().prefix(count))
    }

    /// Returns `count` random indices from the backing array.
    public func randomBackingIndices(count: Int) -> [Int] {
        Array(backingArray.indices.shuffled().prefix(count))
    }
}

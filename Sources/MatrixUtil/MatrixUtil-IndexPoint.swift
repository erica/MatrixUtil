import Foundation

/// An [x,y]-indexed point using `Index` coordinates
public struct PointIndex: Hashable {
    var x: Int
    var y: Int
}

extension Matrix {
    /// Return the value stored at this `PointIndex`'s zero-based x and y coordinates.
    public subscript(pointIndex: PointIndex) -> Element {
        return self[pointIndex.x, pointIndex.y]
    }

    /// The zero-based `PointIndex` indices valid for accessing this `Matrix` in ascending order
    public var pointIndices: [PointIndex] {
        backingArray.indices.map({ PointIndex(x: $0 % width, y: $0 / width) })
    }

    /// The matrix point for a backing array index
    public func pointIndex(of index: Int) -> PointIndex {
        PointIndex(x: index % width, y: index / width)
    }


}


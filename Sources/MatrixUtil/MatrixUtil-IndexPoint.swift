import Foundation

/// An [x,y]-indexed point using `Index` coordinates
public struct PointIndex: Hashable {
    var x: Int
    var y: Int

    public init(x : Int, y: Int) {
        (self.x, self.y) = (x, y)
    }
}

extension Matrix {
    /// Return the value stored at this `PointIndex`'s zero-based x and y coordinates.
    public subscript(pointIndex: PointIndex) -> Element {
        get { self[pointIndex.x, pointIndex.y] }
        set { self[pointIndex.x, pointIndex.y] = newValue }
    }

    /// The zero-based `PointIndex` indices valid for accessing this `Matrix` in ascending order
    public var pointIndices: [PointIndex] {
        backingArray.indices.map({ PointIndex(x: $0 % width, y: $0 / width) })
    }

    /// The matrix point for a backing array index
    public func pointIndex(of index: Int) -> PointIndex {
        PointIndex(x: index % width, y: index / width)
    }

    /// The backing array index for a matrix point
    public func index(of pointIndex: PointIndex) -> Index {
        pointIndex.y * width + pointIndex.x
    }


}


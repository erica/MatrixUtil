import Foundation

extension Matrix {
    /// Returns the `Element` at the 1-based index `index`
    public subscript(oneIndexed index: Int) -> Element {
        return self[index - 1]
    }

    /// Returns the `Element` at the 1-based indices x and y
    public subscript(oneIndexed x: Int, _ y: Int) -> Element {
        return self[x - 1, y - 1]
    }

    /// Returns the `Element` at the 1-based index point `index`
    public subscript(oneIndexed index: PointIndex) -> Element {
        return self[index.x - 1, index.y - 1]
    }
}

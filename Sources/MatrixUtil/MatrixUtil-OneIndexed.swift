import Foundation

extension Matrix {
    /// Returns the `Element` at the 1-based index `index`
    public subscript(oneIndexed index: Int) -> Element {
        get { self[index - 1] }
        set { self[index - 1] = newValue }
    }

    /// Returns the `Element` at the 1-based indices x and y
    public subscript(oneIndexed x: Int, _ y: Int) -> Element {
        get { self[x - 1, y - 1] }
        set { self[x - 1, y - 1] = newValue }
    }

    /// Returns the `Element` at the 1-based index point `index`
    public subscript(oneIndexed index: PointIndex) -> Element {
        get { self[index.x - 1, index.y - 1] }
        set { self[index.x - 1, index.y - 1] = newValue }
    }
}

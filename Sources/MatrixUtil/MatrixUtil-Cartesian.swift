/// Creates a sequence of pairs built of the Cartesian product of two
/// underlying sequences.
///
/// A Cartesian product `Seq1` x `Seq2` consists of the
/// sequence of all ordered pairs `(element1, element2)` where
/// `Seq1` ∋ `element1` and `Seq2` ∋ `element2`.
///
/// ```
/// `Seq1` x `Seq2` = Sequence({ (element1, element2) |
///   `Seq1` ∋ `Element1` and `Seq2` ∋ `Element2` })
/// ```
///
/// The pairs sequence is lazy. It terminates iff both `Seq1` and `Seq2`
/// are finite.
///
/// `Seq1` can be single-pass. A finite `Seq2` will be iterated any number
/// of times and must provide multipass traversal.
///
/// The elements of `Seq2` are enumerated before each element of `Seq1` is
/// consumed. For example, `product(1...2, "abc")` returns the sequence
/// `(1, "a")`, `(1, "b")`, `(1, "c")`, `(2, "a")`, `(2, "b")`, and so forth.
///
/// - Parameter seq1: The first sequence or collection.
/// - Parameter seq2: The second sequence or collection.
/// - Returns: A sequence of tuple pairs, where the elements of each pair
///   correspond to the cartesian ordering of `Seq1` and `Seq2` elements.
/// - Warning: `seq2` must be a multipass (not single-pass) sequence
public func product<Seq1: Sequence, Seq2: Sequence>(_ seq1: Seq1, _ seq2: Seq2)
-> CartesianSequence<Seq1, Seq2>
{
    return CartesianSequence(seq1, seq2)
}

/// A sequence of pairs built from the Cartesian product of two underlying
/// sequences
public struct CartesianSequence <Seq1: Sequence, Seq2: Sequence>: Sequence
{
    /// A type whose instances produce the ordered elements of the Cartesian
    /// sequence.
    public typealias Iterator = CartesianIterator<Seq1, Seq2>

    /// Returns an iterator over the elements of the Cartesian sequence.
    public func makeIterator() -> CartesianIterator<Seq1, Seq2> {
        return Iterator(_seq1, _seq2)
    }

    /// Creates an instance that makes pairs of elements from the
    /// Cartesian product of `seq1` and `seq2`.
    ///
    /// - Parameters:
    ///   - seq1: a `Sequence`
    ///   - seq2: a multipass `Sequence`
    public init(_ seq1: Seq1, _ seq2: Seq2) {
        (_seq1, _seq2) = (seq1, seq2)
    }

    internal let (_seq1, _seq2): (Seq1, Seq2)
}

/// An iterator for `CartesianSequence`.
public struct CartesianIterator<Seq1: Sequence, Seq2: Sequence>: IteratorProtocol
{
    /// The type of element returned by `next()`, in this care a pair of items
    /// consisting of one element from each sequence.
    public typealias Element = (Seq1.Iterator.Element, Seq2.Iterator.Element)

    /// Creates a lazy Cartesian sequence built by traversing the underlying
    /// sequences.
    ///
    /// - Parameters:
    ///   - seq1: The first sequence.
    ///   - seq2: The second sequence.
    internal init(_ seq1: Seq1, _ seq2: Seq2) {
        let _sequence = seq1.lazy.flatMap ({
            item1 in seq2.lazy.map ({
                item2 in (item1, item2)
            })
        })
        _iterator = _sequence.makeIterator()
    }

    /// Advances to the next element and returns it, or `nil` if no next element
    /// exists.
    ///
    /// Repeatedly calling this method returns, in order, all the elements of the
    /// underlying sequence. As soon as the sequence has run out of elements, all
    /// subsequent calls return `nil`.
    ///
    /// You must not call this method if any other copy of this iterator has been
    /// advanced with a call to its `next()` method.
    ///
    /// - Returns: The next pair in the underlying Cartesian sequence, if a next
    ///   pair exists; otherwise, `nil`.
    public mutating func next() ->
    (Seq1.Iterator.Element, Seq2.Iterator.Element)? {
        return _iterator.next()
    }

    internal var _iterator: FlattenSequence<LazyMapSequence<Seq1,LazyMapSequence<Seq2, (Seq1.Element, Seq2.Element)>>>.Iterator
}

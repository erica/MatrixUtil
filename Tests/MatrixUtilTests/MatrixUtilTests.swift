import XCTest
@testable import MatrixUtil

final class MatrixUtilTests: XCTestCase {
    func testConstruction() throws {
        // Construction produces correct size and initial values
        let matrix = Matrix(width: 6, height: 8, initialValue: 0)
        XCTAssert(matrix.backingArray.count == 48, "expected 48 in backing array")
        XCTAssert(matrix.width == 6, "expected width 6")
        XCTAssert(matrix.height == 8, "expected height 8")
        for value in matrix {
            XCTAssert(value == 0, "Unexpected value in initialized array. Expected 0, got \(value)")
        }

        // Construction produces correct size and initial values
        var matrix2 = Matrix(width: 2, array: [1, 2, 3, 4])
        XCTAssert(matrix2[1, 1] == 4)
        XCTAssert(matrix2.backingArray.count == 4)

        // Mutating value in-place produces correct content
        matrix2[1, 0] = 5
        XCTAssert(matrix2.backingArray == [1, 5, 3, 4])
    }

    func testIndexing() throws {
        //  1  2  3  4
        //  5  6  7  8
        //  9 10 11 12
        let sourceArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        let matrix = Matrix(width: 4, array: sourceArray)
        XCTAssertEqual(matrix.index(of: 2, 1), 6)
        let point = matrix.pointIndex(of: 6)
        XCTAssertEqual(point.x, 2)
        XCTAssertEqual(point.y, 1)

        var count = 0
        for _ in matrix { count += 1 }
        XCTAssert(count == sourceArray.count, "Expected \(sourceArray.count) iterated items")

        let matrix2 = Matrix(width: 3, array: sourceArray)
        XCTAssert(matrix2.height == 4, "Expected height 4 for width 3")

        var pointIndex = PointIndex(x: 0, y: 0)
        XCTAssert(matrix[pointIndex] == 1, "Expected 1, got \(matrix[pointIndex])")

        pointIndex = PointIndex(x: 1, y: 2)
        XCTAssert(matrix[pointIndex] == 10, "Expected 10, got \(matrix[pointIndex])")

        //  1  2  3  4
        //  5  6  7  8
        //  9 10 11 12

        // value is 6
        XCTAssert(matrix[5] == 6, "Expected 6, got \(matrix[5])")

        // value is 7
        XCTAssert(matrix.pointIndex(of: 6) == PointIndex(x: 2, y: 1))

        let matrix3 = Matrix(width: 1, array: [1, 2])
        XCTAssert(matrix3.pointIndices == [PointIndex(x: 0, y: 0), PointIndex(x: 0, y: 1)])
    }

    func testNeighbors() throws {
        // Neighbors (full) correct
        //  1  2  3  4
        //  5  6  7  8
        //  9 10 11 12
        let sourceArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        let matrix = Matrix(width: 4, array: sourceArray)
        let neighbors1 = matrix.neighbors(ofX: 2, y: 0)
        XCTAssert(Set(neighbors1.map { point in matrix[point.x, point.y] }) == Set([2, 4, 6, 7, 8]))
        let neighbors2 = matrix.neighbors(ofX: 1, y: 1)
        XCTAssert(Set(neighbors2.map { point in matrix[point.x, point.y] }) == Set([1, 2, 3, 5, 7, 9, 10, 11]))
        let neighbors3 = matrix.neighbors(ofX: 3, y: 2)
        XCTAssert(Set(neighbors3.map { point in matrix[point.x, point.y] }) == Set([11, 7, 8]))

        // Neighbors (full) correct
        let neighbors4 = matrix.edgeNeighbors(ofX: 2, y: 0)
        XCTAssert(Set(neighbors4.map { point in matrix[point.x, point.y] }) == Set([2, 4, 7]))
        let neighbors5 = matrix.edgeNeighbors(ofX: 1, y: 1)
        XCTAssert(Set(neighbors5.map { point in matrix[point.x, point.y] }) == Set([2, 5, 7, 10]))
        let neighbors6 = matrix.edgeNeighbors(ofX: 3, y: 2)
        XCTAssert(Set(neighbors6.map { point in matrix[point.x, point.y] }) == Set([11, 8]))
    }

    func testCartesianIteration() throws {
        //  1  2  3  4
        //  5  6  7  8
        //  9 10 11 12
        var count = 0
        let sourceArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        let matrix = Matrix(width: 4, array: sourceArray)
        matrix.forEach { _, _, _ in
            count += 1
        }
        XCTAssert(count == 12, "Expected 12 iterations starting from (0, 0)")
        count = 0
        var output = ""
        matrix.forEach(fromX: 1, y: 0) { _, _, value in
            count += 1
            output += "\(value)"
        }
        XCTAssert(count == 9, "Expected 9 iterations starting from (1, 0)")
        XCTAssert(output == "234678101112", "Unexpected values in matrix coverage expected 234678101112, got \(output)")
    }

    func testOneIndexing() throws {
        //  1  2  3  4
        //  5  6  7  8
        //  9 10 11 12
        let sourceArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        let matrix = Matrix(width: 4, array: sourceArray)

        XCTAssert(matrix[oneIndexed: 2] == 2, "Expected 2, got \(matrix[oneIndexed: 2])")
        XCTAssert(matrix[oneIndexed: 2, 1] == 2, "Expected 2, got \(matrix[oneIndexed: 2, 1])")
        XCTAssert(matrix[oneIndexed: PointIndex(x: 2, y: 1)] == 2, "Expected 2, got \(PointIndex(x: 2, y: 1))")
        var matrix2 = matrix
        matrix2[oneIndexed: 1, 1] = 0
        XCTAssert(matrix2[oneIndexed: 1, 1] == 0)
        XCTAssert(matrix2[0, 0] == 0)

        matrix2[oneIndexed: 2] = 15
        XCTAssert(matrix2[1] == 15)
        XCTAssert(matrix2[oneIndexed: 2] == 15)

        matrix2[oneIndexed: PointIndex(x: 2, y: 2)] = 25
        XCTAssert(matrix2[oneIndexed: PointIndex(x: 2, y: 2)] == 25)
        XCTAssert(matrix2[1, 1] == 25)
    }

    func testRandom() throws {
        //  1  2  3  4
        //  5  6  7  8
        //  9 10 11 12
        let sourceArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        let matrix = Matrix(width: 4, array: sourceArray)
        let randomIndices = matrix.randomPointIndices(count: 4)
        XCTAssert(randomIndices.count == 4)
        let randomBackingIndices = matrix.randomBackingIndices(count: 8)
        XCTAssert(randomBackingIndices.count == 8)
        let randomValues = randomIndices.map({ matrix[$0] })
        XCTAssert(randomValues.count == 4)

        // Can't really test for random as coming back in order is a valid outcome
    }

    func testSubMatrix() throws {
        //  1  2  3  4
        //  5  6  7  8
        //  9 10 11 12
        let sourceArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        let matrix = Matrix(width: 4, array: sourceArray)
        var submatrix = matrix.subMatrixFrom(x: 1, y: 2)
        XCTAssert(submatrix.backingArray == [10, 11, 12])
        submatrix = matrix.subMatrixFrom(x: 0, y: 1)
        XCTAssert(submatrix.backingArray == [5, 6, 7, 8, 9, 10, 11, 12])
        submatrix = matrix.subMatrixFrom(x: 1, y: 1)
        XCTAssert(submatrix.backingArray == [6, 7, 8, 10, 11, 12])

        var newMatrix = Matrix(width: 4, height: 4, initialValue: 0)
        newMatrix.copy(submatrix, toX: 2, y: 2)
        // 0 0 0   0
        // 0 0 0   0
        // 0 0 6   7
        // 0 0 10 11
        XCTAssert(newMatrix.backingArray == [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 7, 0, 0, 10, 11])

        // 6   7  8   0
        // 10 11 12   0
        // 0   0  6   7
        // 0   0 10  11
        newMatrix.copy(submatrix, toX: 0, y: 0)
        XCTAssert(newMatrix.backingArray == [6, 7, 8, 0, 10, 11, 12, 0, 0, 0, 6, 7, 0, 0, 10, 11])
    }

    func testStringConvertible() throws {
        //  1  2  3  4
        //  5  6  7  8
        //  9 10 11 12
        let sourceArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        let matrix = Matrix(width: 4, array: sourceArray)
        let submatrix = matrix.subMatrixFrom(x: 1, y: 1)
        XCTAssert("\(submatrix)" == """
         6,  7,  8
        10, 11, 12
        """)

        XCTAssert("\(submatrix.description(separatedBy: "-", balanceWidths: false, indentCount: 2))" == """
          6-7-8
          10-11-12
        """)
    }
}

//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Artem Yaroshenko on 08.12.2025.
//

import XCTest

struct ArithmeticOperation {
    func addition(num1: Int, num2: Int) -> Int {
        num1 + num2
    }
    
    func subtraction(num1: Int, num2: Int)  -> Int {
        num1 - num2
    }
    
    func multiplication(num1: Int, num2: Int) -> Int {
        num1 * num2
    }
}

final class MovieQuizTests: XCTestCase {
    func testAddition() throws {
        //Given
        let arithmeticOperations = ArithmeticOperation()
        let num1 = 1
        let num2 = 2
        
        //When
        let result = arithmeticOperations.addition(num1: num1, num2: num2)
        
        //Then
        XCTAssertEqual(result, 3)
    }
}

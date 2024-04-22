//
//  MoviesLoaderTest.swift
//  MovieQuizTests
//
//  Created by Maksim on 18.04.2024.
//

import Foundation

import XCTest // не забывайте импортировать фреймворк для тестирования
@testable import MovieQuiz // импортируем приложение для тестирования

class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        // When
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            // Then
            switch result {
            case.success(let movies):
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case.failure(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        // When
        let expectation = expectation(description: "Loading expect")
        
        loader.loadMovies {
            result in
            
            // Then
            switch result {
            case.failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            case.success(_):
                XCTFail("Unexpected failure")
            }
        }
        
        waitForExpectations(timeout: 1)
    }
}

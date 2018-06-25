//
//  Domain_CodeChallengeTests.swift
//  Domain_CodeChallengeTests
//
//  Created by Dmitrii Zverev on 2/6/18.
//  Copyright © 2018 Dmitrii Zverev. All rights reserved.
//

import XCTest
@testable import Domain_CodeChallenge

class Domain_CodeChallengeTests: XCTestCase {
    
    func testSavingLoadingData() {
        let testSet =  Set(0...1_000)
        UserDefaults.standard.set(Array(testSet), forKey: "TestSavedData")
        let loadedSet =  Set(UserDefaults.standard.object(forKey: "TestSavedData") as? Array<Int> ?? [])
        XCTAssertEqual(testSet, loadedSet)
    }
    
    func testPerformanceSet() {
        var set = Set(0...1_000_000)
        self.measure {
            if  set.contains(135_000) {
                set.remove(135_000)
            }
        }
    }
    func testPerformanceArray() {
        var array = (0...1_000_000).map({$0})
        self.measure {
            if let index = array.index(of: 135_000) {
                array.remove(at: index)
            }
        }
    }
    func testAsynchronousURLConnection() {
       
        let url = URL(string:  ConnectionManager.domainBaseUrl)!
        let urlExpectation = expectation(description: "POST \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = TypeOfRequest.buy.jsonData()
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            
            if let response = response as? HTTPURLResponse,
                let responseURL = response.url,
                let mimeType = response.mimeType
            {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let data = data {
                    XCTAssertNotNil(try? decoder.decode(SearchResults.self, from: data), "SearchResults JOSN Decoding error")
                }
                XCTAssertEqual(responseURL.absoluteString, url.absoluteString, "HTTP response URL should be equal to original URL")
                XCTAssertEqual(response.statusCode, 200, "HTTP response status code should be 200")
                XCTAssertEqual(mimeType, "application/json", "HTTP response content type should be application/json")
            } else {
                XCTFail("Response was not HTTPURLResponse")
            }
            
            urlExpectation.fulfill()
        }
        
        task.resume()
        
        waitForExpectations(timeout: task.originalRequest!.timeoutInterval) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            task.cancel()
        }
    }
    
}

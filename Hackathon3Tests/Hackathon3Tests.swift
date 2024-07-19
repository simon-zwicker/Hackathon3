//
//  Hackathon3Tests.swift
//  Hackathon3Tests
//
//  Created by Mia Koring on 18.07.24.
//

import XCTest
@testable import Hackathon3
import CoreLocation

final class Hackathon3Tests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testUserCreation() async throws {
        let res = try await Network.request(Profile.self, environment: .pock, endpoint: Pockethost.createProfile("Mia", "female", "49.006889,8.403653"))
        print(res)
    }
    
    func testGetUser() async throws {
        let res = try await Network.request(Profile.self, environment: .pock, endpoint: Pockethost.getProfile("h2k556igj37sr2a"))
        XCTAssertTrue(res.name == "Mia")
    }
    
    func testGetProfiles() async throws {
        let res = try await Network.request(PocketBase<Profile>.self, environment: .pock, endpoint: Pockethost.getProfiles)
        print(res.items)
    }
    
    func testCreateFavourites() async throws {
        let res = try await Network.request(Favourite.self, environment: .pock, endpoint: Pockethost.createFavourite("562,36647", "h2k556igj37sr2a"))
    }
    
    func testGetFavourites() async throws {
        let res = try await Network.request(PocketBase<Favourite>.self, environment: .pock, endpoint: Pockethost.favourites)
        print(res.items)
    }
    
    func testPatchFavourites() async throws {
        let res = try await Network.request(Favourite.self, environment: .pock, endpoint: Pockethost.patchFavourite("vsdoctzkc1zljn0", "562", "h2k556igj37sr2a"))
    }
    
    func testSingleMovieFetch() async throws {
        let res = try await Network.request(FavouriteTMDBMovie.self, environment: .tmdb, endpoint: TmDB.specificMovie(519182))
        print(res)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

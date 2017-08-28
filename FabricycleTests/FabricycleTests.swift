//
//  FabricycleTests.swift
//  FabricycleTests
//
//  Created by zip520123 on 2017/8/25.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import XCTest
@testable import Fabricycle
class FabricycleTests: XCTestCase {
    let userId = "testClothUploadImageUserIdQQQQ"
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testClothAddImage() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        //give
        let imageList = [UIImage() , UIImage()]
        //when
        let cloth = Cloth(imageList  , userId : userId)
        //then
        XCTAssertEqual(cloth.imageList.count , 2)
        
    }
    
    func testClothUploadImage(){
        //give
        let imageList = [UIImage(named: "cut-2")! , UIImage(named: "cut-2")!]
        //when
        let cloth = Cloth(imageList , userId : userId)
        //then
        cloth.uploadAllImage {
            XCTAssertEqual(cloth.imageListOnString.count , 2)
            for (i ,item) in cloth.imageListOnString.enumerated() {
                print("cloth :\(i),\(item)")
            }
            
        }
        
        
        
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

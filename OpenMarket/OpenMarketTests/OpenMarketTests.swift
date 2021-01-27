//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Yeon on 2021/01/26.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    private var itemList: ItemList?
    private var item: Item?
    
    func testGetItemListAsync() {
        let expectation = XCTestExpectation(description: "APIPrivoderTaskExpectation")

        ItemManager.loadData(path: .items, param: 1) { [self] result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    itemList = try JSONDecoder().decode(ItemList.self, from: data)
                    expectation.fulfill()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }

        wait(for: [expectation], timeout: 5.0)
        let page = itemList?.page
        let itemId = itemList?.items[0].id
        let itemTitle = itemList?.items[0].title
        let itemPrice = itemList?.items[0].price
        let itemCurrency = itemList?.items[0].currency
        let itemStock = itemList?.items[0].stock

        XCTAssertEqual(page, 1)
        XCTAssertEqual(itemId, 26)
        XCTAssertEqual(itemTitle, "MacBook Air")
        XCTAssertEqual(itemPrice, 1290000)
        XCTAssertEqual(itemCurrency, "KRW")
        XCTAssertEqual(itemStock, 1_000_000_000_000)
    }
    
    func testGetItemDetail() {
        let expectation = XCTestExpectation(description: "APIPrivoderTaskExpectation")
        ItemManager.loadData(path: .item, param: 68) { [self] result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    item = try JSONDecoder().decode(Item.self, from: data)
                    expectation.fulfill()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
        let id = item?.id
        let title = item?.title
        let price = item?.price
        let currency = item?.currency
        let stock = item?.stock
        
        XCTAssertEqual(id, 68)
        XCTAssertEqual(title, "Mac mini")
        XCTAssertEqual(price, 890000)
        XCTAssertEqual(currency, "KRW")
        XCTAssertEqual(stock, 90)
    }
    
    func testPostItem() {
        let expectation = XCTestExpectation(description: "APIPrivoderTaskExpectation")
        guard let image1 = UIImage(named: "testImage1"), let image2 = UIImage(named: "testImage2") else {
            return
        }
        var imageDataStringArray: [String] = []
        guard let imageData1 = UIImageToData(image: image1), let imageData2 = UIImageToData(image: image2) else {
            return
        }
        imageDataStringArray.append(imageData1)
        imageDataStringArray.append(imageData2)
        
        let newItem = ItemUploadRequest(title: "AirPod Max",
                                        descriptions: "귀를 호강시켜주는 에어팟 맥스! 사주실 분 구해요ㅠ",
                                        price: 700000,
                                        currency: "KRW",
                                        stock: 10000,
                                        discountedPrice: nil,
                                        images: imageDataStringArray,
                                        password: "asdfqwerzxcv")
        
        ItemManager.uploadData(method: .post, path: .item, item: newItem, param: nil) { [self] result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    item = try JSONDecoder().decode(Item.self, from: data)
                    expectation.fulfill()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
        let title = item?.title
        let description = item?.descriptions
        let price = item?.price
        let currency = item?.currency
        let stock = item?.stock
        
        XCTAssertEqual(title, "AirPod Max")
        XCTAssertEqual(description, "귀를 호강시켜주는 에어팟 맥스! 사주실 분 구해요ㅠ")
        XCTAssertEqual(price, 700000)
        XCTAssertEqual(currency, "KRW")
        XCTAssertEqual(stock, 10000)
    }
    
    func testPatchItem() {
        let expectation = XCTestExpectation(description: "APIPrivoderTaskExpectation")
        let pathcItem = ItemUploadRequest(title: nil,
                                          descriptions: nil,
                                          price: 750000,
                                          currency: nil,
                                          stock: 500000,
                                          discountedPrice: nil,
                                          images: nil,
                                          password: "asdfqwerzxcv")
        
        ItemManager.uploadData(method: .patch, path: .item, item: pathcItem, param: 187) { [self] result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    item = try JSONDecoder().decode(Item.self, from: data)
                    expectation.fulfill()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
        let id = item?.id
        let title = item?.title
        let description = item?.descriptions
        let price = item?.price
        let currency = item?.currency
        let stock = item?.stock
        
        XCTAssertEqual(id, 187)
        XCTAssertEqual(title, "AirPod Max")
        XCTAssertEqual(description, "귀를 호강시켜주는 에어팟 맥스! 사주실 분 구해요ㅠ")
        XCTAssertEqual(price, 750000)
        XCTAssertEqual(currency, "KRW")
        XCTAssertEqual(stock, 500000)
    }
    
    private func UIImageToData(image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8)?.base64EncodedData() else {
            return nil
        }
        let dataString = String(decoding: data, as: UTF8.self)
        return dataString
    }
}
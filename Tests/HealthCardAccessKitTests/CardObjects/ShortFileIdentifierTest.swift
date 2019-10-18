//
//  Copyright (c) 2019 gematik - Gesellschaft für Telematikanwendungen der Gesundheitskarte mbH
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//     http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

@testable import HealthCardAccessKit
import Nimble
import XCTest

final class ShortFileIdentifierTest: XCTestCase {
    func testValidSFID() {
        let sfid = "0E" as ShortFileIdentifier
        let expected = Data(bytes: [0x0E])
        expect(sfid.rawValue) == expected
    }

    func testValidSFID_initFromString() {
        expect {
            try ShortFileIdentifier(hex: "1E").rawValue
        }.to(equal(Data(bytes: [0x1e])))
    }

    func testValidSFID_initFromData() {
        let data = Data(bytes: [0x10])
        expect {
            try ShortFileIdentifier(data).rawValue
        }.to(equal(data))
    }

    func testWhenSFIDhasNonHexValue() {
        expect {
            try ShortFileIdentifier(hex: "ZE")
        }.to(throwError(ShortFileIdentifier.Error.illegalArgument(
                "Short File Identifier is invalid (non-hex characters found). [ZE]"
        )))
    }

    func testValidatorWhenOutOfRange() {
        // gemSpec_COS#N007.000
        var invalidSFIDs = [UInt8]()
        for idx: UInt8 in 0x1f..<0xff {
            invalidSFIDs.append(idx)
        }
        invalidSFIDs.append(0x0)
        invalidSFIDs.map { Data(bytes: [$0]) }.forEach { sfid in
            expect {
                try ShortFileIdentifier.isValid(sfid).get()
            }.to(throwError(
                    ShortFileIdentifier.Error.illegalArgument(
                            "Short File Identifier is invalid: [0x\(sfid.hexString())]"
                    )
            ))
        }
    }

    func testValidatorWhenSFIDisValid() {
        // gemSpec_COS#N007.000
        var invalidSFIDs = [UInt8]()
        for idx: UInt8 in 0x1...0x1e {
            invalidSFIDs.append(idx)
        }
        invalidSFIDs.map { Data(bytes: [$0]) }.forEach { sfid in
            expect {
                try ShortFileIdentifier.isValid(sfid).get()
            } == sfid
        }
    }

    static let allTests = [
        ("testValidSFID", testValidSFID),
        ("testValidSFID_initFromString", testValidSFID_initFromString),
        ("testValidSFID_initFromData", testValidSFID_initFromData),
        ("testWhenFIDhasNonHexValue", testWhenSFIDhasNonHexValue),
        ("testValidatorWhenOutOfRange", testValidatorWhenOutOfRange),
        ("testValidatorWhenSFIDisValid", testValidatorWhenSFIDisValid)
    ]
}
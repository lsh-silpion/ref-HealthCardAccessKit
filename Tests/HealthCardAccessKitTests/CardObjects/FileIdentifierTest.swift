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

final class FileIdentifierTest: XCTestCase {
    func testValidFID() {
        let fid = "D276" as FileIdentifier
        let expected = Data(bytes: [0xd2, 0x76])
        expect(fid.rawValue) == expected
    }

    func testValidFID_initFromString() {
        expect {
            try FileIdentifier(hex: "D276").rawValue
        }.to(equal(Data(bytes: [0xd2, 0x76])))
    }

    func testValidFID_initFromData() {
        let data = Data(bytes: [0x10, 0x2])
        expect {
            try FileIdentifier(data).rawValue
        }.to(equal(data))
    }

    func testWhenFIDhasNonHexValue() {
        expect {
            try FileIdentifier(hex: "Z10E")
        }.to(throwError(FileIdentifier.Error.illegalArgument(
                "File Identifier is invalid (non-hex characters found). [Z10E]"
        )))
    }

    func testValidatorWhenFIDisInvalidLength() {
        /// Length != 2 is invalid
        expect {
            try FileIdentifier.isValid(Data(bytes: [0x1])).get()
        }.to(throwError())

        expect {
            try FileIdentifier.isValid(Data(bytes: [0x1, 0x2, 0x3])).get()
        }.to(throwError())
    }

    func testValidatorWhenOutOfRange() {
        // gemSpec_COS#N006.700, N006.900
        var invalidFIDs = [UInt16]()
        for idx: UInt16 in 0x0..<0x1000 {
            invalidFIDs.append(idx)
        }
        for idx: UInt16 in 0xff00...0xffff {
            invalidFIDs.append(idx)
        }
        invalidFIDs.append(0x3fff)
        invalidFIDs.filter {
            $0 != 0x011c
        }
        .map {
            Data(bytes: [UInt8($0 >> 8), UInt8($0 & 0xff)])
        }
        .forEach { fid in
            expect {
                try FileIdentifier.isValid(fid).get()
            }.to(throwError(FileIdentifier.Error.illegalArgument("File Identifier invalid: [0x\(fid.hexString())]")))
        }
    }

    func testValidatorWhenFIDisValid() {
        // gemSpec_COS#N006.700, N006.900
        let validFID: UInt16 = 0x011c
        var validFIDs = [UInt16]()
        for idx: UInt16 in 0x1000...0xfeff {
            validFIDs.append(idx)
        }
        validFIDs.append(validFID)
        validFIDs.filter {
            $0 != 0x3fff
        }
        .map {
            Data(bytes: [UInt8($0 >> 8), UInt8($0 & 0xff)])
        }
        .forEach { validFID in
            expect {
                try FileIdentifier.isValid(validFID).get()
            } == validFID
        }
    }

    static let allTests = [
        ("testValidFID", testValidFID),
        ("testValidFID_initFromString", testValidFID_initFromString),
        ("testValidFID_initFromData", testValidFID_initFromData),
        ("testWhenFIDhasNonHexValue", testWhenFIDhasNonHexValue),
        ("testValidatorWhenFIDisInvalidLength", testValidatorWhenFIDisInvalidLength),
        ("testValidatorWhenOutOfRange", testValidatorWhenOutOfRange),
        ("testValidatorWhenFIDisValid", testValidatorWhenFIDisValid)
    ]
}
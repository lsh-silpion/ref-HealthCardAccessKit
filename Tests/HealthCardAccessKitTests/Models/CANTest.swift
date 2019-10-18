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

import ASN1Kit
import Foundation
@testable import HealthCardAccessKit
import Nimble
import XCTest

class CANTest: XCTestCase {
    func testCAN_valid() {
        for length in 1...16 {
            expect {
                try CAN.from(Data(repeating: 0x1, count: length))
            }.toNot(throwError())
        }
    }

    func testCAN_invalid() {
        expect {
            try CAN.from(Data())
        }.to(throwError(CAN.InvalidCAN.illegalValue(0, for: "CAN", expected: 1..<17)))

        expect {
            try CAN.from(Data(repeating: 0xf, count: 17))
        }.to(throwError(CAN.InvalidCAN.illegalValue(17, for: "CAN", expected: 1..<17)))
    }

    static let allTests = [
        ("testCAN_valid", testCAN_valid),
        ("testCAN_invalid", testCAN_invalid)
    ]
}

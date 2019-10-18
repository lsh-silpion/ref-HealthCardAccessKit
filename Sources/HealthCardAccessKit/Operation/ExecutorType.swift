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

import Foundation

/// Generic Executor protocol
public protocol ExecutorType {
    /// Schedule a closure that returns an A and return the FutureType that holds reference to the FutureEvent
    /// - Parameter block: closure to schedule (and run) on Self
    /// - Returns: Future that holds reference to the resulting event
    func run<A>(_ block: @escaping Callable<A>) -> Future<A>
}
//
//  Utilities.swift
//  Moody
//
//  Created by Philip Smith on 5/27/19.
//  Copyright © 2019 Philip Smith. All rights reserved.
//

import Foundation


extension Sequence where Iterator.Element: AnyObject {
    func containsObjectIdentical(to object: AnyObject) -> Bool {
        return contains { $0 === object }
    }
}


extension Array {
    var decomposed: (Iterator.Element, [Iterator.Element])? {
        guard let x = first else { return nil }
        return (x, Array(self[1..<count]))
    }
}

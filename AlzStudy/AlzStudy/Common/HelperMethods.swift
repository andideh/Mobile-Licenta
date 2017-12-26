//
//  HelperMethods.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 12/11/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit


func Build<T>(_ value: T, block: (T) -> Void) -> T {
    block(value)
    return value
}

func after(_ sec: Double, block: @escaping  VoidBlock) {
    DispatchQueue.main.asyncAfter(deadline: .now() + sec, execute: block)
}

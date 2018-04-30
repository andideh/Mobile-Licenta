//
//  ColorTestFactory.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 4/14/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import Foundation

struct ColorTestFactory {

    private static let allTest: [ColorTest] = [
        ColorTest(color: .blue, options: [.red, .blue, .brown]),
        ColorTest(color: .red, options: [.red, .yellow, .orange]),
        ColorTest(color: .brown, options: [.blue, .orange, .brown]),
        ColorTest(color: .yellow, options: [.green, .yellow, .blue]),
        ColorTest(color: .green, options: [.green, .yellow, .red]),
        ColorTest(color: .orange, options: [.yellow, .blue, .orange]),
    ]

    static func makeTest() -> ColorTest {
        let randomIndex = Int(arc4random_uniform(UInt32(allTest.count)))
        return allTest[randomIndex]
    }
}

//
//  Strings.swift
//  AlzStudy
//
//  Created by Andi Dehelean on 3/31/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import Foundation

enum Strings {

    static let next = "Next"
    static let done = "Done"

    enum Measurements {
        static let disclaimer = "You have to provide some body measurements in order to improve survey results."
        static let title = "Measurements"
    }

    enum Activities {
        static let disclaimer = "Here are your today’s tasks. You may select one from the To-do list."
        static func hello(_ name: String) -> String {
            return "Hello, \(name)"
        }
        static let noItems = "No items"
    }

    enum Activity {
        static let nameThePersonTitle = "Name the person"
        static let nameThePersonDescription = "You will have to recognize the person in the image."

        static let tellTheColorTitle = "Tell the color"
        static let tellTheColorDescription = "You will have to say what color do you see in the picture."

        static let holdNumbersTitle = "Hold the numbers"
        static let holdNumbersDescription = "You will have to remember some numbers and write them again."

        static let guessTheObjectTitle = "Guess the object"
        static let guessTheObjectDescription = "You will have to recognize what object is in the image."

        static let glucoseLevelTitle = "Glucose level"
        static let glucoseLevelDescription = "You will have to provide you glucose level."

    }
}

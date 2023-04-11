//
//  Theme.swift
//  Set
//
//  Created by yuzhongbao on 2023/4/5.
//

import Foundation

struct Theme {
    var number: NumberOfPattern
    var shape: ShapeOfPattern
    var shading: ShadingOfPattern
    var color: ColorOfPattern
    
    init(number: NumberOfPattern, shape: ShapeOfPattern, shading: ShadingOfPattern, color: ColorOfPattern) {
        self.number = number
        self.shape = shape
        self.shading = shading
        self.color = color
    }
}

enum NumberOfPattern: Int, CaseIterable {
    case one = 1
    case two = 2
    case three = 3
}

enum ShapeOfPattern: String, CaseIterable {
    //菱形
    case diamond = "diamond"
    //波浪形
    case squiggle = "squiggle"
    //椭圆
    case oval = "oval"
}

enum ShadingOfPattern: String, CaseIterable {
    //实心
    case solid = "solid"
    //条纹
    case striped = "striped"
    //空心
    case open = "open"
}

enum ColorOfPattern: String, CaseIterable {
    case first = "first"
    case secend = "secend"
    case third = "third"
}

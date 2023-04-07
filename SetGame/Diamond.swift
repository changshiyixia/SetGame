//
//  Diamond.swift
//  SetGame
//
//  Created by yuzhongbao on 2023/4/7.
//

import SwiftUI

struct Diamond: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let pt1 = CGPoint(x: rect.midX, y: rect.minY)
        let pt2 = CGPoint(x: rect.maxX, y: rect.midY)
        let pt3 = CGPoint(x: rect.midX, y: rect.maxY)
        let pt4 = CGPoint(x: rect.minX, y: rect.midY)

        path.move(to: pt1)
        path.addLine(to: pt2)
        path.addLine(to: pt3)
        path.addLine(to: pt4)
        path.closeSubpath()

        return path
    }
}

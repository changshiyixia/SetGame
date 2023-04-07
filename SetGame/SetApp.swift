//
//  SetApp.swift
//  Set
//
//  Created by yuzhongbao on 2023/4/5.
//

import SwiftUI

@main
struct SetApp: App {
    var game = GameViewModel()
    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
}

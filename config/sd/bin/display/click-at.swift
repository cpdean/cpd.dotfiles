#!/usr/bin/env swift

// swift equivalent of click-at (jxa version). same behavior, same api (CGEvent).
// build with: swiftc click-at.swift -o click-at-swift
// or run directly: swift click-at.swift <x> <y>

import CoreGraphics
import Foundation

let args = CommandLine.arguments
guard args.count >= 3,
      let x = Double(args[1]),
      let y = Double(args[2]) else {
    FileHandle.standardError.write("usage: click-at <x> <y>\n".data(using: .utf8)!)
    exit(2)
}

let point = CGPoint(x: x, y: y)
let src: CGEventSource? = nil

if let down = CGEvent(mouseEventSource: src, mouseType: .leftMouseDown, mouseCursorPosition: point, mouseButton: .left) {
    down.post(tap: .cghidEventTap)
}
if let up = CGEvent(mouseEventSource: src, mouseType: .leftMouseUp, mouseCursorPosition: point, mouseButton: .left) {
    up.post(tap: .cghidEventTap)
}

#!/usr/bin/env swift

import Foundation

print(CommandLine.arguments)
print("Number of arguments: \(CommandLine.argc)")

print("Enter your name: ")
var name = readLine(strippingNewline: true)
print("Hello \(name ?? "anonymouse")")
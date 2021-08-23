#!/usr/bin/env swift

import Foundation

let ls = Process()
ls.executableURL = URL(fileURLWithPath: "/bin/ls")
ls.arguments = ["-al"]

var pipe = Pipe()

ls.standardOutput = pipe

let sort = Process()
let completePipe = Pipe()

sort.executableURL = URL(fileURLWithPath: "/usr/bin/env")
sort.arguments = ["sort"]
sort.standardInput = pipe
sort.standardOutput = completePipe

do {
  try ls.run()
  try sort.run()
  let data = completePipe.fileHandleForReading.readDataToEndOfFile()
  if let output = String(data: data, encoding: .utf8) {
    print(output)
  }
} catch {
  print(error.localizedDescription)
}
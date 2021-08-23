#!/usr/bin/env swift

import Foundation

let ls = Process()
ls.executableURL = URL(fileURLWithPath: "/bin/ls")
ls.arguments = ["-al"]

var pipe = Pipe()

ls.standardOutput = pipe

do {
  try ls.run()
  let data = pipe.fileHandleForReading.readDataToEndOfFile()
  if let output = String(data: data, encoding: String.Encoding.utf8) {
    print("=> This is captured output.")
    print(output)
  }
} catch {
  print(error.localizedDescription)
}
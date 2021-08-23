#!/usr/bin/env swift

import Foundation

var users = ["zoe", "joe", "albert", "james", ""]

if users.contains("") {
  FileHandle.standardError.write("Error: there is an empty name".data(using: .utf8)!)
  exit(1)
} else {
  for user in users {
    print(user)
  }
}
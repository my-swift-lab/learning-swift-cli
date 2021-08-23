#!/usr/bin/env swift

import Foundation

var users = ["zoe", "joe", "albert", "james", ""]

if users.contains("") {
  print("Error: there is an empty name")
  exit(1)
} else {
  for user in users {
    print(user)
  }
}
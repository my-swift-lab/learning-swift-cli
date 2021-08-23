import ArgumentParser

struct Random: ParsableCommand {
  static let configuration = CommandConfiguration(abstract: "1부터 입력한 숫자 범위에서 임의 수를 출력합니다.", subcommands: [
    Number.self,
    Pick.self
  ])
}

extension Random {
  // > random pick --count 3 A B C D E F G H I
  struct Pick: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: "pick", abstract: "입력한 리스트에서 임의 원소를 count개 뽑아 출력합니다.")
    
    @Option(help: "선택할 원소의 갯수")
    var count: Int = 1

    @Argument
    var elements: [String]

    func validate() throws {
      guard !elements.isEmpty else {
        throw ValidationError("최소 1개의 원소를 입력해야 합니다.")
      }
    }

    func run() throws {
      let picks = elements.shuffled().prefix(count)
      print(picks.joined(separator: "\n"))
    }
  }

  struct Number: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: "number", abstract: "1부터 입력한 숫자 범위에서 임의 수를 출력합니다.")

    @Argument()
    var n: Int

    func validate() throws {
      guard n >= 1 else {
        throw ValidationError("1 이상 숫자를 입력하셔야 합니다.")
      }
    }

    func run() throws {
      print(Int.random(in: 1...n))
    }
  }
}

Random.main()
import Foundation
import ArgumentParser
import Combine
import Alamofire

@available(macOS 10.15, *)
class AppInfoModel {
  var cancellables = Set<AnyCancellable>()

  static let baseUrl = "https://itunes.apple.com/lookup"

  func fetchAppInfoBy(bundleId: String) -> Future<String, Never> {
    return Future<String, Never> { promise in
      AF.request("\(AppInfoModel.baseUrl)?bundleId=\(bundleId)").responseJSON { response in 
        if let value = response.value {
          promise(.success("\(value)"))
        } else {
          promise(.success("\(bundleId) 앱을 찾을 수 없습니다."))
        }
      }
    }
  }

  func fetchAppInfoBy(appId: String) -> Future<String, Never> {
    return Future<String, Never> { promise in
      AF.request("\(AppInfoModel.baseUrl)?id=\(appId)").responseJSON { response in 
        if let value = response.value {
          promise(.success("\(value)"))
        } else {
          promise(.success("\(appId) 앱을 찾을 수 없습니다."))
        }
      }
    }
  }
}

@available(macOS 10.15, *)
struct AppInfo: ParsableCommand {
  static let configuration = CommandConfiguration(commandName: "appinfo", abstract: "앱스토어에 출시한 앱 정보를 조회합니다.", subcommands: [
    BundleId.self,
    AppId.self
  ])
}

extension AppInfo {
  struct BundleId: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: "bundleId", abstract: "번들ID로 앱 정보를 조회합니다.")

    @Argument(help: "앱의 번들ID")
    var bundleId: String

    func validate() throws {
      guard !bundleId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { 
        throw ValidationError("번들ID를 입력해 주세요")
      }
    }

    func run() throws {
      let model = AppInfoModel()
      let group = DispatchGroup()
      group.enter()
      model.fetchAppInfoBy(bundleId: bundleId)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { _ in 
          group.leave()
        }, receiveValue: { value in 
          print(value)
        })
        .store(in: &model.cancellables)
      group.notify(queue: .main, execute: {
        AppInfo.exit()
      })
      dispatchMain()
    }
  }
}

extension AppInfo {
  struct AppId: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: "appId", abstract: "앱ID로 앱 정보를 조회합니다.")

    @Argument(help: "앱ID")
    var appId: String

    func validate() throws {
      guard !appId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { 
        throw ValidationError("앱ID를 입력해 주세요")
      }
    }

    func run() throws {
      let model = AppInfoModel()
      let group = DispatchGroup()
      group.enter()
      model.fetchAppInfoBy(appId: appId)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { _ in 
          group.leave()
        }, receiveValue: { value in 
          print(value)
        })
        .store(in: &model.cancellables)
      group.notify(queue: .main, execute: {
        AppInfo.exit()
      })
      dispatchMain()
    }
  }
}

AppInfo.main()
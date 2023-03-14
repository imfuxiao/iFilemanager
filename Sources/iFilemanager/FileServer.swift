import Leaf
import Vapor

public class FileServer {
  private var app: Application
  private let port: Int
  private let publicDirectory: URL

  public init(port: Int, publicDirectory: URL) {
    self.port = port
    self.publicDirectory = publicDirectory

    #if DEBUG
      app = Application(.development)
    #else
      app = Application(.production)
    #endif

    configure(app)
  }

  func configure(_ app: Application) {
    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = port

    app.views.use(.leaf)
    app.leaf.cache.isEnabled = app.environment.isRelease
    app.leaf.configuration.rootDirectory = Bundle.module.bundlePath

    app.routes.defaultMaxBodySize = "60MB"

    let file = FileMiddleware(publicDirectory: Bundle.module.bundlePath)
    app.middleware.use(file)

    let encoder = JSONEncoder()
    encoder.outputFormatting = .withoutEscapingSlashes
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    encoder.dateEncodingStrategy = .formatted(formatter)
    ContentConfiguration.global.use(encoder: encoder, for: .json)
  }

  public func start() {
    // Task(priority: .background) {
    do {
      try app.register(collection: FileWebRouteCollection(publicDirectory: self.publicDirectory))
      try app.server.start()
    } catch {
      fatalError(error.localizedDescription)
    }
    // }
  }

  public func shutdown() {
    do {
      try app.server.shutdown()
    } catch {
      fatalError(error.localizedDescription)
    }
  }
}

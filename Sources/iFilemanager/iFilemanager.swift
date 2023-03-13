import Foundation
import Leaf
import Vapor

public class iFilemanager: ObservableObject {
    private var app: Application
    private let port: Int

    public init(port: Int) {
        self.port = port
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
        app.leaf.configuration.rootDirectory = Bundle.main.bundlePath
        
        print(Bundle.main.bundleURL)
        
        app.routes.defaultMaxBodySize = "60MB"
        
        let file = FileMiddleware(publicDirectory: Bundle.main.bundlePath)
        app.middleware.use(file)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        encoder.dateEncodingStrategy = .formatted(formatter)
        ContentConfiguration.global.use(encoder: encoder, for: .json)
    }
    
    public func start() {
        Task(priority: .background) {
            do {
                try app.register(collection: FileWebRouteCollection())
                try app.start()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    public func shutdown() {
        if !app.didShutdown {
            app.shutdown()
        }
    }
}

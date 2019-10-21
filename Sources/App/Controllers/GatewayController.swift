import Vapor

final class GatewayController {
    //MARK: Boot
    func boot(router: Router) throws {
        router.get(PathComponent.catchall, use: handler)
        router.post(PathComponent.catchall, use: handler)
        router.delete(PathComponent.catchall, use: handler)
        router.put(PathComponent.catchall, use: handler)
        router.patch(PathComponent.catchall, use: handler)
    }
    
    //MARK: Route Handler
    func handler(_ req: Request) throws -> Future<Response> {
        guard
            let service = req.http.urlString.split(separator: "/", maxSplits: 1, omittingEmptySubsequences: true).first,
            let hostData = Environment.get("HOST:\(service)")
            else { throw Abort(.badRequest) }
        let configuration = try JSONDecoder().decode(ServiceConfiguration.self, from: hostData.convertToData())
        return try handler(req, configuration: configuration)
    }
    
    func handler(_ req: Request, configuration: ServiceConfiguration) throws -> Future<Response> {
        let client = try req.make(Client.self)
        guard let host = configuration.host else {
            throw Abort(.internalServerError)
        }
        req.http.url = host.appendingPathComponent(req.http.urlString)
        req.http.headers.replaceOrAdd(name: "host", value: host.absoluteString)
        return client.send(req)
    }
}

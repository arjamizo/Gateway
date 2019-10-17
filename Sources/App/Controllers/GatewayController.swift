import Vapor

final class GatewayController {
    //MARK: Boot
    func boot(router: Router) throws {
        router.get(PathComponent.anything, use: handle)
        router.post(PathComponent.anything, use: handle)
        router.delete(PathComponent.anything, use: handle)
        router.put(PathComponent.anything, use: handle)
        router.patch(PathComponent.anything, use: handle)
    }
    
    //MARK: Route Handler
    func handle(_ req: Request) throws -> Future<Response> {
        if req.http.urlString.contains("users") {
            guard let usersHost = Environment.get("USERS_HOST") else { throw Abort(.badRequest) }
            return try handle(req, host: usersHost)
        }
        throw Abort(.badRequest)
    }
    
    func handle(_ req: Request, host: String) throws -> Future<Response> {
        let client = try req.make(Client.self)
        guard let url = URL(string: host + req.http.urlString) else {
            throw Abort(.internalServerError)
        }
        req.http.url = url
        req.http.headers.replaceOrAdd(name: "host", value: host)
        return client.send(req)
    }
}

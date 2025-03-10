//
//  NetworkService.swift
//  FluxAIViewModel
//
//  Created by Er Baghdasaryan on 05.03.25.
//

import Foundation
import FluxAIModele
import Combine

public protocol INetworkService {
    func createByPromptRequest(userId: String?, prompt: String?) async throws -> RequestResponseModel
    func fetchGenerationStatus(userId: String?, jobId: String) -> AnyPublisher<GenerationStatusResponseModel, Error>
    func createAvatarRequest(userId: String, gender: String, photo: [URL]?, preview: URL?) async throws -> CreateAvatarResponseModel
    func fetchAvatarGenerationStatus(userId: String, generationId: Int) -> AnyPublisher<CreatedAvatarResponseModel, Error>
    func getAvatars(userId: String) -> AnyPublisher<AvatarsResponseModel, Error>
}

public final class NetworkService: INetworkService {    

    public init() { }

    public func createByPromptRequest(userId: String? = nil, prompt: String? = nil) async throws -> RequestResponseModel {
        guard let url = URL(string: "https://webwisesolutions.shop/api/v1/photo/generate/txt2img") else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer f113066f-2ad6-43eb-b860-8683fde1042a", forHTTPHeaderField: "Authorization")

        var body: [String: Any] = [:]
        if let userId = userId {
            body["userId"] = userId
        }
        if let prompt = prompt {
            body["prompt"] = prompt
        }

        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(RequestResponseModel.self, from: data)
        return result
    }

    public func fetchGenerationStatus(userId: String?, jobId: String) -> AnyPublisher<GenerationStatusResponseModel, Error> {
        var components = URLComponents(string: "https://webwisesolutions.shop/api/v1/services/status")
        var queryItems = [URLQueryItem(name: "jobId", value: jobId)]

        if let userId = userId {
            queryItems.append(URLQueryItem(name: "userId", value: userId))
        }
        components?.queryItems = queryItems

        guard let url = components?.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer f113066f-2ad6-43eb-b860-8683fde1042a", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 60

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: GenerationStatusResponseModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func createAvatarRequest(userId: String, gender: String, photo: [URL]? = nil, preview: URL? = nil) async throws -> CreateAvatarResponseModel {
        guard let url = URL(string: "https://webwisesolutions.shop/api/v1/avatar/add") else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer f113066f-2ad6-43eb-b860-8683fde1042a", forHTTPHeaderField: "Authorization")

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"userId\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(userId)\r\n".data(using: .utf8)!)

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"gender\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(gender)\r\n".data(using: .utf8)!)

        if let photos = photo {
            for photoURL in photos {
                let filename = photoURL.lastPathComponent
                let mimetype = "image/png"
                
                let fileData = try Data(contentsOf: photoURL)
                
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"photo[]\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
                body.append(fileData)
                body.append("\r\n".data(using: .utf8)!)
            }
        }

        if let preview = preview {
            let filename = preview.lastPathComponent
            let mimetype = "image/png"
            
            let fileData = try Data(contentsOf: preview)
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"preview\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }

        let result = try JSONDecoder().decode(CreateAvatarResponseModel.self, from: data)
        return result
    }

    public func fetchAvatarGenerationStatus(userId: String, generationId: Int) -> AnyPublisher<CreatedAvatarResponseModel, Error> {
        var components = URLComponents(string: "https://webwisesolutions.shop/api/v1/avatar/status")
        var queryItems = [URLQueryItem(name: "generationId", value: String(generationId))]

        queryItems.append(URLQueryItem(name: "userId", value: userId))
        components?.queryItems = queryItems

        guard let url = components?.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer f113066f-2ad6-43eb-b860-8683fde1042a", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 60

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: CreatedAvatarResponseModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func getAvatars(userId: String) -> AnyPublisher<AvatarsResponseModel, Error> {
        var components = URLComponents(string: "https://webwisesolutions.shop/api/v1/avatar/list")
        let queryItems = [URLQueryItem(name: "userId", value: userId)]

        components?.queryItems = queryItems

        guard let url = components?.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer f113066f-2ad6-43eb-b860-8683fde1042a", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 60

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: AvatarsResponseModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

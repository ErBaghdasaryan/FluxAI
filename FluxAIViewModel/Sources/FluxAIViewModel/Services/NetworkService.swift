//
//  NetworkService.swift
//  FluxAIViewModel
//
//  Created by Er Baghdasaryan on 05.03.25.
//

import Foundation
import FluxAIModele

public protocol INetworkService {
    func createByPromptRequest(userId: String?, prompt: String?) async throws -> RequestResponseModel
    func fetchGenerationStatus(userId: String?, jobId: String) async throws -> GenerationStatusResponseModel
}

public final class NetworkService: INetworkService {

    public init() { }

    public func createByPromptRequest(userId: String? = nil, prompt: String? = nil) async throws -> RequestResponseModel {
        guard let url = URL(string: "https://bot.fotobudka.online/api/v1/photo/generate/txt2img") else { throw URLError(.badURL) }

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

    public func fetchGenerationStatus(userId: String? = nil, jobId: String) async throws -> GenerationStatusResponseModel {
        var components = URLComponents(string: "https://bot.fotobudka.online/api/v1/services/status")
        var queryItems = [URLQueryItem(name: "jobId", value: jobId)]

        if let userId = userId {
            queryItems.append(URLQueryItem(name: "userId", value: userId))
        }
        components?.queryItems = queryItems

        let url = components?.url
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer f113066f-2ad6-43eb-b860-8683fde1042a", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(GenerationStatusResponseModel.self, from: data)
        return result
    }
}

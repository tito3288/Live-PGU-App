//
//  PodbeanAuthService.swift
//  PGU
//
//  Created by Bryan Arambula on 1/29/24.
//

import Foundation

class PodbeanAuthService {
    static func requestAccessToken(clientId: String, clientSecret: String, authorizationCode: String, redirectUri: String, completion: @escaping (String?) -> Void) {
        let tokenUrl = URL(string: "https://api.podbean.com/v1/oauth/token")!
        var request = URLRequest(url: tokenUrl)
        request.httpMethod = "POST"

        let credentials = "\(clientId):\(clientSecret)".data(using: .utf8)!.base64EncodedString()
        request.setValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")

        let requestBody = "grant_type=authorization_code&code=\(authorizationCode)&redirect_uri=\(redirectUri)"
        request.httpBody = requestBody.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }

            if let accessTokenResponse = try? JSONDecoder().decode(AccessTokenResponse.self, from: data) {
                completion(accessTokenResponse.access_token)
            } else {
                print("Invalid response or data")
                completion(nil)
            }
        }.resume()
    }
}

struct AccessTokenResponse: Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
    let scope: String
    let refresh_token: String
}




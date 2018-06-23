//
//  OAuthResource.swift
//  SwiftlySalesforce
//
//  For license & details see: https://www.github.com/mike4aday/SwiftlySalesforce
//  Copyright (c) 2018. All rights reserved.
//

import Foundation

internal enum OAuthResource {
	case refreshAccessToken(authorizationURL: URL, consumerKey: String)
	case revokeAccessToken(authorizationURL: URL)
	case revokeRefreshToken(authorizationURL: URL)
}

extension OAuthResource: Resource {
	
	internal func request(with authorization: Authorization) throws -> URLRequest {
		
		switch self {
			
		case let .refreshAccessToken(authorizationURL, consumerKey):
			guard let refreshToken = authorization.refreshToken else {
				throw Salesforce.Error.refreshTokenUnavailable
			}
			return try URLRequest(
				method: .post,
				baseURL: baseOAuthURL(from: authorizationURL).appendingPathComponent("token"),
				accessToken: authorization.accessToken,
				contentType: URLRequest.MIMEType.urlEncoded.rawValue,
				queryParameters: [
					"format" : "json",
					"grant_type": "refresh_token",
					"client_id": consumerKey,
					"refresh_token": refreshToken
				]
			)
						
		case let .revokeAccessToken(authorizationURL):
			return try URLRequest(
				method: .post,
				baseURL: baseOAuthURL(from: authorizationURL).appendingPathComponent("revoke"),
				accessToken: authorization.accessToken,
				contentType: URLRequest.MIMEType.urlEncoded.rawValue,
				queryParameters: ["token" : authorization.accessToken]
			)
			
		case let .revokeRefreshToken(authorizationURL):
			guard let refreshToken = authorization.refreshToken else {
				throw Salesforce.Error.refreshTokenUnavailable
			}
			return try URLRequest(
				method: .post,
				baseURL: baseOAuthURL(from: authorizationURL).appendingPathComponent("revoke"),
				accessToken: authorization.accessToken,
				contentType: URLRequest.MIMEType.urlEncoded.rawValue,
				queryParameters: ["token": refreshToken]
			)
		}
	}
}

private extension OAuthResource {
	
	// Helper function
	private func baseOAuthURL(from authorizationURL: URL) -> URL {
		var comps = URLComponents(url: authorizationURL.deletingLastPathComponent(), resolvingAgainstBaseURL: false)
		comps?.queryItems = nil
		return comps?.url ?? authorizationURL.deletingLastPathComponent()
	}
}

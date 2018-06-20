//
//  Salesforce+Query.swift
//  SwiftlySalesforce
//
//  Created by Michael Epstein on 5/14/18.
//

import Foundation
import PromiseKit

public extension Salesforce {
	
	public func query<T: Decodable>(soql: String, batchSize: Int? = nil, options: Options = []) -> Promise<QueryResult<T>> {
		let resource = QueryResource.query(soql: soql, batchSize: batchSize, version: configuration.version)
		return dataTask(resource: resource, options: options)
	}
	
	public func query(soql: String, batchSize: Int? = nil, options: Options = []) -> Promise<QueryResult<Record>> {
		let resource = QueryResource.query(soql: soql, batchSize: batchSize, version: configuration.version)
		return dataTask(resource: resource, options: options)
	}
	
	public func query<T: Decodable>(soql: [String], batchSize: Int? = nil, options: Options = []) -> Promise<[QueryResult<T>]> {
		let promises: [Promise<QueryResult<T>>] = soql.map { query(soql: $0, batchSize: batchSize, options: options) }
		return when(fulfilled: promises)
	}
	
	public func query(soql: [String], batchSize: Int? = nil, options: Options = []) -> Promise<[QueryResult<Record>]> {
		let promises: [Promise<QueryResult<Record>>] = soql.map { query(soql: $0, batchSize: batchSize, options: options) }
		return when(fulfilled: promises)
	}
	
	public func queryNext<T: Decodable>(path: String, options: Options = []) -> Promise<QueryResult<T>> {
		let resource = QueryResource.queryNext(path: path)
		return dataTask(resource: resource, options: options)
	}
	
	public func queryNext(path: String, options: Options = []) -> Promise<QueryResult<Record>> {
		return dataTask(resource: QueryResource.queryNext(path: path), options: options)
	}
}

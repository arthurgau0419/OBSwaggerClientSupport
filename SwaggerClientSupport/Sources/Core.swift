//
//  Core.swift
//  SwaggerClientSupport
//
//  Created by Kao Ming-Hsiu on 2018/5/5.
//

import Foundation

// ErrorResponse Protocol
public protocol ErrorResponseSupport {
  var statusCode: Int {get}
  var data: Data? {get}
  var error: Error {get}
}

// Response Trait
public protocol ResponseHasBody {
  associatedtype B
  var body: B? {get}
}

// RequestBuilder Trait
public protocol RequestBuilderCanExecute {
  associatedtype R: ResponseHasBody
  func execute(_ completion: @escaping (_ response: R?, _ error: Error?) -> Void)
}

extension RequestBuilderCanExecute {
//  func execute(_ completion: (_ response: R?, _ error: Error?) -> Void) {
//    self.execute(completion)
//  }
}

public protocol RequestBuilderHasProgress {
  var onProgressReady: ((Progress) -> ())? {get set}
}

// SwaggerClientAPI Trait
public protocol SwaggerClientAPITokenCredential {
  static var customHeaders: [String:String] {get set}
  static func tokenCredential(key: String, value: String?, valueFormat: String)
}

extension SwaggerClientAPITokenCredential {
  /**
   加入 Bearer Token 於 HTTP Headers 內
   - parameter key: Key in Headers
   - parameter value: value for key
   - parameter valueFormat: value format using String.format method
   */
  public static func tokenCredential(key: String, value: String?, valueFormat: String = "%s") {
    guard let value = value else {
      customHeaders.removeValue(forKey: key)
      return
    }
    customHeaders.updateValue(String(format: valueFormat , value), forKey: key)
  }
}

// Sync Request Trait
extension RequestBuilderCanExecute {    
  /**
   使用同步方法呼叫
   - Throws: ResponseError
   - Warning: 不要在主線程中使用，會卡死
   */
  public func executeSync() throws -> Self.R? {
    let semaphore = DispatchSemaphore(value: 0)
    var r: Self.R?
    var e: Error?
    execute { (response, error) in
      r = response
      e = error
      semaphore.signal()
    }
    semaphore.wait()
    guard e == nil else { throw e! }
    return r
  }
}

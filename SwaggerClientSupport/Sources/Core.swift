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
  func execute(_ completion: (_ response: R?, _ error: Error?) -> Void) {
    self.execute(completion)
  }
}

public protocol RequestBuilderHasProgress {
  var onProgressReady: ((Progress) -> ())? {get set}
}

// SwaggerClientAPI Trait
public protocol SwaggerClientAPITokenCredential {
  static var customHeaders: [String:String] {get set}
  /**
   於 HTTP Header 中加入 Bearer Token，valueFormat 預設為 "%@"
   */
  static func tokenCredential(key: String, value: String?, valueFormat: String)
}

extension SwaggerClientAPITokenCredential {
  public static func tokenCredential(key: String, value: String?, valueFormat: String = "%@") {
    guard let value = value else {
      customHeaders.removeValue(forKey: key)
      return
    }
    customHeaders.updateValue(String(format: valueFormat , value), forKey: key)
  }
}

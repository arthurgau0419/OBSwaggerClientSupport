//
//  Core.swift
//  SwaggerClientSupport
//
//  Created by Kao Ming-Hsiu on 2018/5/5.
//

import Foundation

// ErrorResponse Trait
public protocol ErrorResponseSupport: RawRepresentable {
  var statusCode: Int {get}
  var data: Data? {get}
  var error: Error {get}
}

extension ErrorResponseSupport where Self.RawValue == (Int, Data?, Error) {
  public var statusCode: Int {
    return rawValue.0
  }
  
  public var data: Data? {
    return rawValue.1
  }
  
  public var error: Error {
    return rawValue.2
  }
  
  
  public init?(rawValue: (Int, Data?, Error)) {
    return nil
  }
  
  public var rawValue: (Int, Data?, Error) {
    return self.rawValue
  }
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
  static func tokenCredential(key: String, value: String?, valueFormat: String)
}

extension SwaggerClientAPITokenCredential {
  public static func tokenCredential(key: String, value: String?, valueFormat: String = "%s") {
    guard let value = value else {
      customHeaders.removeValue(forKey: key)
      return
    }
    customHeaders.updateValue(String(format: valueFormat , value), forKey: key)
  }
}

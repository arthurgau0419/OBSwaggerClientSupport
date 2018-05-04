//
//  Setup.swift
//  SwaggerClientSupport_Tests
//
//  Created by Kao Ming-Hsiu on 2018/5/5.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import SwaggerClient
import OBSwaggerClientSupport
import RxSwift
import PromiseKit

// Basic Setting
extension RequestBuilder: RequestBuilderCanExecute {
  public typealias R = Response<T>
}

extension RequestBuilder: RequestBuilderHasProgress {}

extension Response: ResponseHasBody {
  public typealias B = T
}

extension ErrorResponse: ErrorResponseSupport {
  public var statusCode: Int {
    switch self {
    case .Error(let code, _, _):
      return code
    }
  }
  public var data: Data? {
    switch self {
    case .Error(_, let data, _):
      return data
    }
  }
  public var error: Error {
    switch self {
    case .Error(_, _, let error):
      return error
    }
  }
}

// TokenCredential Support
extension SwaggerClientAPI: SwaggerClientAPITokenCredential {}

// i18n Support
extension SwaggerClientAPI: SwaggerClientAcceptLanguage {}

// PromiseKit Support
extension RequestBuilder: RequestBuilderCanPromise {}

// RxSwift Support
extension RequestBuilder: ReactiveCompatible {}

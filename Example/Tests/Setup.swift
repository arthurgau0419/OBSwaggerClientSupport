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
  public typealias RawValue = (Int, Data?, Error)
}

// TokenCredential Support
extension SwaggerClientAPI: SwaggerClientAPITokenCredential {}

// PromiseKit Support
extension RequestBuilder: RequestBuilderCanPromise {}

// RxSwift Support
extension RequestBuilder: ReactiveCompatible {}

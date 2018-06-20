//
//  ClientSupport+Promise.swift
//  SwaggerClientSupport
//
//  Created by Kao Ming-Hsiu on 2018/5/5.
//

import Foundation
import PromiseKit

public protocol RequestBuilderCanPromise: RequestBuilderCanExecute {
  func promise() -> Promise<Self.R>
}

public extension RequestBuilderCanPromise {
  /**
   把 RequestBuilder 變成 Promise
   */
  public func promise() -> Promise<Self.R> {
    return Promise<Self.R>.init(resolver: { (seal) in
      self.execute({ (r, e) in
        seal.resolve(r, e)
      })
    })
  }
}

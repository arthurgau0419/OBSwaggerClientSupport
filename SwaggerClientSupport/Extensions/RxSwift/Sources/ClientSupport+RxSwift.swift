//
//  ClientSupport+RxSwift.swift
//  SwaggerClientSupport
//
//  Created by Kao Ming-Hsiu on 2018/5/5.
//

import Foundation
import RxSwift

public enum ClientSupportRxError: Error {
  case BothNilAfterExecute
  case NilBody
}

extension Reactive where Base: RequestBuilderCanExecute {
  public func response() -> Single<Base.R> {
    return base.rxResponse()
  }
  public func body() -> Single<Base.R.B> {
    return base.rxResponseBody()
  }
}

extension Reactive where Base: RequestBuilderHasProgress {
  public var progress: Observable<Progress> {
    return Observable<Progress>.create { (observer) -> Disposable in
      var builder = self.base
      builder.onProgressReady = { progress in
        observer.onNext(progress)
        if progress.isCancelled || progress.isFinished {
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
}

extension RequestBuilderCanExecute {
  /**
   Rx Observable From RequestBuilder (沒有complete事件)
   */
  func rxResponse() -> Observable<Self.R> {
    return Observable<Self.R>.deferred({ () -> Observable<Self.R> in
      return Observable<Self.R>.create({ (observer) -> Disposable in
        self.execute({ (response, error) in
          switch (response, error) {
          case (.some, _):
            observer.onNext(response!)
          case (_, .some):
            observer.onError(error!)
          case (.none, .none):
            // impossible
            observer.onError(ClientSupportRxError.BothNilAfterExecute)
            break
          }
        })
        return Disposables.create()
      })
    })
  }
  /**
   Rx Single From RequestBuilder
   */
  func rxResponse() -> Single<Self.R> {
    return Single<Self.R>.deferred({ () -> PrimitiveSequence<SingleTrait, Self.R> in
      return Single<Self.R>.create { (singleEvent) -> Disposable in
        self.execute({ (response, error) in
          switch (response, error) {
          case (.some, _):
            singleEvent(.success(response!))
          case (_, .some):
            singleEvent(.error(error!))
          case (.none, .none):
            // impossible
            singleEvent(.error(ClientSupportRxError.BothNilAfterExecute))
            break
          }
        })
        return Disposables.create()
      }
    })
  }
  /**
   Rx Observable From RequestBuilder (沒有complete事件)
   */
  func rxResponseBody() -> Observable<Self.R.B> {    
    return rxResponse().map({ (response) -> Self.R.B in
      guard let body = response.body else {
        throw ClientSupportRxError.NilBody
      }
      return body
    })
  }
  /**
   Rx Single From RequestBuilder
   */
  func rxResponseBody() -> Single<Self.R.B> {
    return rxResponse().map({ (response) -> Self.R.B in
      guard let body = response.body else {
        throw ClientSupportRxError.NilBody
      }
      return body
    })
  }
}

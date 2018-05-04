//
//  Accept-Language.swift
//  OBSwaggerClientSupport
//
//  Created by Kao Ming-Hsiu on 2018/6/20.
//

import Foundation


// SwaggerClientAPI Trait
public protocol SwaggerClientAcceptLanguage {
  static var customHeaders: [String:String] {get set}
  /**
   於 HTTP Header 中加入 Accept-Language Header
   */
  static func internationalization(languageCode: String?)
}

extension SwaggerClientAcceptLanguage {
  public static func internationalization(languageCode: String?) {    
    guard let languageCode = languageCode else {
      customHeaders.removeValue(forKey: "Accept-Language")
      return
    }
    customHeaders.updateValue(languageCode, forKey: "Accept-Language")
  }
}

// https://github.com/Quick/Quick

import Quick
import Nimble
import OBSwaggerClientSupport
import SwaggerClient
import RxSwift

class Demo: QuickSpec {
  
  let disposeBag = DisposeBag()
  
  override func spec() {
    
    describe("i18n") {
      it("Can Add Accept-Language Header") {
        SwaggerClientAPI.internationalization(languageCode: "zh-TW")
        expect(SwaggerClientAPI.customHeaders["Accept-Language"]).to(equal("zh-TW"))
      }
    }
    
    describe("Add Bearer Token in HttpHeader") {
      it("Can Add Bearer Token") {
        SwaggerClientAPI.tokenCredential(key: "Authorization", value: "your_api_token", valueFormat: "Token %s")
        expect(SwaggerClientAPI.customHeaders["Authorization"]).to(equal(String.init(format: "Token %s", "your_api_token")))
      }
    }
    
    describe("Promise") {
      it("Can Promise Response") {
        waitUntil(timeout: 10, action: { (done) in
          PetAPI.findPetsByStatusWithRequestBuilder(status: ["sold"]).promise().done({ (r) in
            print(r)
            expect(r).notTo(beNil())
          }).catch({ (e) in
            fail(e.localizedDescription)
          }).finally {
            done()
          }
        })
      }
    }
    
    describe("Rxswift") {
      it("Can Rx Response") {
        let builder = PetAPI.findPetsByStatusWithRequestBuilder(status: ["sold"])
                
        builder.rx.progress.map {$0.fractionCompleted}.subscribe({ (event) in
          print(event)
        }).disposed(by: self.disposeBag)
        
        waitUntil(timeout: 10, action: { (done) in
          builder.rx.body()
            .debug()
            .subscribe(onSuccess: { (pets) in
              expect(pets).notTo(beNil())
              done()
            }, onError: { (err) in
              fail(err.localizedDescription)
              done()
            })
            .disposed(by: self.disposeBag)
        })
      }
    }
  }
}

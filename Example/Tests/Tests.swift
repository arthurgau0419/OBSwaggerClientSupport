// https://github.com/Quick/Quick

import Quick
import Nimble
import OBSwaggerClientSupport
import SwaggerClient
import RxSwift

class Demo: QuickSpec {
  
  let disposeBag = DisposeBag()
  
  override func spec() {    
    
    describe("Add Bearer Token in HttpHeader") {
      // Add Bearer Token
      SwaggerClientAPI.tokenCredential(key: "Authorization", value: "your_api_token", valueFormat: "Token %s")
      let builder = DevicesAPI.getV2DevicesPhoneNumberRoomsWithRequestBuilder(phoneNumber: "123456")
      builder.execute({ (response, error) in
        if let errorResponse = error as? ErrorResponse {
          // Helpful ErrorResponseSupport.
          print(errorResponse.data ?? nil)
          print(errorResponse.statusCode)
          print(errorResponse.error)
        } else {
          print(error)
        }
        // Remove Bearer token
        SwaggerClientAPI.tokenCredential(key: "Auth", value: nil)
      })
    }
    
    describe("Promise") {
      it("Can Promise Response") {
        waitUntil(timeout: 10, action: { (done) in
          DevicesAPI.getV2DevicesPhoneNumberRoomsWithRequestBuilder(phoneNumber: "123456").promise().done({ (r) in
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
        let builder = DevicesAPI.getV2DevicesPhoneNumberRoomsWithRequestBuilder(phoneNumber: "123456")
                
        builder.rx.progress.map {$0.fractionCompleted}.subscribe({ (event) in
          print(event)
        }).disposed(by: self.disposeBag)
        
        waitUntil(timeout: 10, action: { (done) in
          builder.rx.body()
            .debug()
            .subscribe(onSuccess: { (room) in
              expect(room).notTo(beEmpty())
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

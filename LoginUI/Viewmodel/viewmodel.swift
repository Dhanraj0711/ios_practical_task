//
//  Modelview.swift
//  PhotoLibrary
//
//  Created by APPLE on 15/07/23.
//

import Foundation


final class imageviewmode {
       var Event : ((_ event : event) -> Void)?
    func fatchimage (page: Int = 1) {
       var Api = Api()
        let Url = Api.api
        print(Url)
        Apimanager.shared.CallingImageApi(url: Url) { (response) in
            self.Event?(.loading)
            switch response {
            case.success(let images):
                Constant.shared.results = images
                Constant.shared.Finalresult.append(contentsOf: Constant.shared.results)
                self.Event?(.Getdata)
                
            case.failure(let error):
                self.Event?(.error(_error: error))
            }
        }
    }
    enum event {
        case loading
        case stoploading
        case Getdata
        case error(_error : Error)
    }
}

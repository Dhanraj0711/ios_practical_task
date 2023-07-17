//
//  Apimanager.swift
//  PhotoLibrary
//
//  Created by APPLE on 15/07/23.
//

import Foundation

enum errorfound  : Error {
    case datanotfond
    case statuscodnotfound
    case urlnotfound
}
typealias Hendler = (Result<[Results], errorfound>) -> Void

final class Apimanager {
    static var shared = Apimanager()
    
    private init() {}
    
    func CallingImageApi(url : String, complesion : @escaping Hendler ) {
        var Api = Api()
        let url = URL(string: Api.api)
        guard url != nil else {
            complesion(.failure(errorfound.urlnotfound))
            return
        }
        URLSession.shared.dataTask(with: url!) { (data, response , error) in
            guard data != nil , error == nil else {
                complesion(.failure(errorfound.datanotfond))
                return
            }
            
            guard let response  = response as? HTTPURLResponse,
                  200...299  ~= response.statusCode else {
                complesion(.failure(errorfound.statuscodnotfound))
                return
            }
            do {
                let Images = try JSONDecoder().decode(Imagemodel.self, from: data!)
                var Result = Images.results
                complesion(.success(Result!))
            }catch{
                print(error.localizedDescription)
            }
        }.resume()
        
    }
    
}


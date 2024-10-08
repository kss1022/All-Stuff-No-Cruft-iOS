//
//  AuthRequestAdapter.swift
//  Authenticator
//
//  Created by 한현규 on 2023/08/01.
//

import Foundation
import AppUtil
import Alamofire



public class AuthRequestAdapter : RequestInterceptor {
            
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
                
        if let accessToken = OAuthToken.shared()?.accessToken {
            urlRequest.headers.add(.authorization(bearerToken: accessToken))
        }
        else {
            return completion(.failure(AppError(reason: .TokenNotFound)))
        }
        
        //if input headerfield setValue
        //urlRequest.setValue(header, forHTTPHeaderField: "HeaderField")
        return completion(.success(urlRequest))
    }
}

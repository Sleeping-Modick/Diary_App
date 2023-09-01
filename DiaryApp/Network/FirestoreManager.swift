//
//  FirestoreManager.swift
//  DiaryApp
//
//  Created by t2023-m0056 on 2023/09/01.
//

import Foundation
import FirebaseFirestore

final class FirestoreService {
    let db = Firestore.firestore()
    
    func getPostData(completion: @escaping ([Post]?) -> Void) {
        var names: [[String:Any]] = [[:]]
        var post: [Post]?
        
        db.collection("Post").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(post) // 호출하는 쪽에 빈 배열 전달
                return
            }
            for document in querySnapshot!.documents {
                names.append(document.data())
            }
            names.remove(at: 0)
            post = self.dictionaryToObject(objectType: Post.self, dictionary: names)
            completion(post) // 성공 시 이름 배열 전달
        }
    }
    
    func addPostDocument(content: String, goal: String, image: String, tag: Array<String>, temperature: String, weather: String, weatherIcon: String, completion: @escaping (String) -> Void) {
        // Add a new document with a generated ID
        db.collection("Info").document(goal).setData([
            "content": content,
            "goal": goal,
            "image": image,
            "tag": tag,
            "temperature": temperature,
            "weather": weather,
            "weatherIcon": weatherIcon,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                completion("Post Document added")
            }
        }
    }
}

extension FirestoreService {
    func dictionaryToObject<T:Decodable>(objectType:T.Type,dictionary:[[String:Any]]) -> [T]? {
        
        guard let dictionaries = try? JSONSerialization.data(withJSONObject: dictionary) else { return nil }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let objects = try? decoder.decode([T].self, from: dictionaries) else { return nil }
        return objects
    }
    
    func dicToObject<T:Decodable>(objectType:T.Type,dictionary:[String:Any]) -> T? {
        
        guard let dictionaries = try? JSONSerialization.data(withJSONObject: dictionary) else { return nil }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let objects = try? decoder.decode(T.self, from: dictionaries) else { return nil }
        return objects
    }
}

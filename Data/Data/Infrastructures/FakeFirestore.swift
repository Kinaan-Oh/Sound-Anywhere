//
//  FakeFirestore.swift
//  Data
//
//  Created by 오현식 on 2022/04/23.
//

final class FakeFirestore<T>: Firestore {
    final class Collection {
        final class Document {
            // MARK: - Document Properties, Methods
            
            enum DocumentError: Error {
                case notExist
            }
            
            var data: T?
            
            func setData(from data: T) {
                self.data = data
            }
            
            func getDocument(completion: @escaping (Result<T, DocumentError>) -> Void) {
                guard let data = data else {
                    completion(.failure(.notExist))
                    return
                }
                completion(.success(data))
            }
        }
        
        // MARK: - Collection Properties, Methods
        
        var collection: [String: Document] = [:]
        
        func document(name: String) -> Document {
            guard let document = collection[name] else {
                let newDocument = Document()
                collection[name] = newDocument
                return newDocument
            }
            return document
        }
    }
    
    // MARK: - FakeFirestore Properties, Methods
    
    var db: [String: Collection] = [:]
    
    func collection(name: String) -> Collection {
        guard let collection = db[name] else {
            let newCollection = Collection()
            db[name] = newCollection
            return newCollection
        }
        return collection
    }
}

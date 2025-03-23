//
//  ToDoListViewViewModel.swift
//  PhotoFinish
//
//  Created by Jonathan Cai on 2025-03-22.
//

import FirebaseFirestore
import Foundation

// ViewModel for list of items view
// Primary Tab
class ToDoListViewViewModel: ObservableObject {
    @Published var showingNewItemView = false
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    func delete(id: String) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("todos")
            .document(id)
            .delete()
        
    }
}

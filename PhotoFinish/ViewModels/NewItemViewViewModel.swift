//
//  NewItemViewViewModel.swift
//  PhotoFinish
//
//  Created by Jonathan Cai on 2025-03-22.
//
import FirebaseAuth
import FirebaseFirestore
import Foundation


class NewItemViewViewModel: ObservableObject {
    @Published var title = ""
    @Published var dueDate = Date()
    @Published var showAlert = false
    
    init() {}
    
    func save() {
        guard canSave else { return }
        
        // Get current user id
        guard let uId = Auth.auth().currentUser?.uid else { return }
        
        // Create Model
        let newId = UUID().uuidString
        let newItem = ToDoListItem(id: newId,
                                   title: title,
                                   dueDate: dueDate.timeIntervalSince1970,
                                   createdDate: Date().timeIntervalSince1970,
                                   isDone: false
            )
        
        // Save Model
        let db = Firestore.firestore()
        db.collection("users")
            .document(uId)
            .collection("todos")
            .document(newId)
            .setData(newItem.asDictionary())
            
    }
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        
        guard dueDate >= Date().addingTimeInterval(-86400) else { return false }
        
        return true
    }
}

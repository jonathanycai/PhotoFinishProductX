//
//  ToDoListView.swift
//  PhotoFinish
//
//  Created by Jonathan Cai on 2025-03-22.
//
import FirebaseFirestore
import SwiftUI

struct ToDoListView: View {
    @StateObject var viewModel: ToDoListViewViewModel
    @FirestoreQuery var items: [ToDoListItem]
    
    init(userId: String) {
        self._items = FirestoreQuery(
            collectionPath: "users/\(userId)/todos"
        )
        self._viewModel = StateObject(wrappedValue: ToDoListViewViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                // Stack for the "Tasks" heading and the list
                VStack(alignment: .leading) {
                    // Subheading "Tasks"
                    Text("Tasks")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                        // Increase this value to add more space below the nav bar
                        .padding(.top, 60)
                    
                    // Your list of tasks
                    List(items) { item in
                        ToDoListItemNoCheckView(item: item)
                            .swipeActions {
                                Button("Delete") {
                                    viewModel.delete(id: item.id)
                                }
                                .tint(.red)
                            }
                            .listRowBackground(Color.black)
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                }
                .navigationTitle("")                  // Remove default nav title text
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    // The centered PhotoFinish title
                    ToolbarItem(placement: .principal) {
                        Text("PhotoFinish")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color.blue,
                                        Color.cyan
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
                    
                    // The plus button on the trailing side
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewModel.showingNewItemView = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $viewModel.showingNewItemView) {
                    NewItemView(newItemPresented: $viewModel.showingNewItemView)
                }
            }
        }
    }
}

#Preview {
    ToDoListView(userId: "goJ2xZFms6coUBOnMPb3hWT6qY92")
}

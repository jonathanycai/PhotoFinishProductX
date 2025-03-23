//
//  ToDoListItemView.swift
//  PhotoFinish
//
//  Created by Jonathan Cai on 2025-03-22.
//

import SwiftUI

struct ToDoListItemView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    @State private var showingSheet = false
    let item: ToDoListItem
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.body)
                
                Text("\(Date(timeIntervalSince1970: item.dueDate).formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote)
                    .foregroundColor(Color(.secondaryLabel))
            }
            Spacer()
            
            Button {
                viewModel.toggleIsDone(item: item)
                showingSheet = true
            } label: {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(Color.blue)
            }
            .sheet(isPresented: $showingSheet) {
                ContentView()
            }
        }
    }
}

#Preview {
    ToDoListItemView(item: .init(id: "123",
                                 title: "Write Code",
                                 dueDate: Date().timeIntervalSince1970,
                                 createdDate: Date().timeIntervalSince1970,
                                 isDone: true))
}

//
//  ToDoListItemNoCheckView.swift
//  PhotoFinish
//
//  Created by Jonathan Cai on 2025-03-23.
//

import SwiftUI

struct ToDoListItemNoCheckView: View {
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
        }
    }
}

#Preview {
    ToDoListItemNoCheckView(item: .init(id: "123",
                                 title: "Write Code",
                                 dueDate: Date().timeIntervalSince1970,
                                 createdDate: Date().timeIntervalSince1970,
                                 isDone: true))
}

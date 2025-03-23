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
                    .foregroundColor(.white) // Adjust color as desired
                
                Text(
                    Date(timeIntervalSince1970: item.dueDate)
                        .formatted(date: .abbreviated, time: .shortened)
                )
                .font(.footnote)
                .foregroundColor(.white.opacity(0.8))
            }
            Spacer()
        }
        .padding()
        .background(

            
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.35, green: 0.23, blue: 0.73),
                            Color(red: 0.54, green: 0.34, blue: 0.91)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }
}

#Preview {
    ToDoListItemNoCheckView(
        item: .init(
            id: "123",
            title: "Write Code",
            dueDate: Date().timeIntervalSince1970,
            createdDate: Date().timeIntervalSince1970,
            isDone: false
        )
    )
}

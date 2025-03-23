//
//  NewItemView.swift
//  PhotoFinish
//
//  Created by Jonathan Cai on 2025-03-22.
//

import SwiftUI

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var newItemPresented: Bool
    
    var body: some View {
        VStack {
            Text("New Item")
                .font(.system(size: 32))
                .bold()
                .padding(.top, 100)
                .foregroundColor(.white)
            
            Form {
                Section {
                    TextField("Title", text: $viewModel.title)
                        .foregroundColor(.white)
                    
                    DatePicker("Due Date", selection: $viewModel.dueDate)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .foregroundColor(.white)
                }
                .listRowBackground(Color.darkGray)
                
                // Use your existing TLButton here, just set background to purple
                TLButton(title: "Save", background: .purple) {
                    if viewModel.canSave {
                        viewModel.save()
                        newItemPresented = false
                    } else {
                        viewModel.showAlert = true
                    }
                }
                .padding()
                .listRowBackground(Color.black)
            }
            // Hide default Form background (iOS 16+)
            .scrollContentBackground(.hidden)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Please fill in all fields and select a due date that is today or later.")
                )
            }
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}


#Preview {
    NewItemView(newItemPresented: Binding(get: {
        true
    }, set: { _ in}))
}

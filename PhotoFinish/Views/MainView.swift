//
//  MainView.swift
//  PhotoFinish
//
//  Created by Jonathan Cai on 2025-03-22.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            accountView
        } else {
            LoginView()
        }
    }
    
    @ViewBuilder
    var accountView: some View {
        TabView {
            PhotoUpload(userId: viewModel.currentUserId)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            ToDoListView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("List", systemImage:"list.clipboard")
                }
            
            NavigationView {
                CalendarView(
                    monthDate: DateComponents(calendar: .current, year: 2025, month: 3).date!
                )
            }
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
        }
    }
}

#Preview {
    MainView()
}

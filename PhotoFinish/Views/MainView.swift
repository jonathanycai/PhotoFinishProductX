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
                    Label("New", systemImage:"plus")
                }
            ToDoListView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            NavigationView {
                CalendarView(
                    monthDate: DateComponents(calendar: .current, year: 2025, month: 3).date!
                )
            }
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    MainView()
}

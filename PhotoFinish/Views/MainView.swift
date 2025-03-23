//
//  MainView.swift
//  PhotoFinish
//
//  Created by Jonathan Cai on 2025-03-22.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()
    @State private var selection = 2

    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            accountView
        } else {
            LoginView()
        }
    }
    
    @ViewBuilder
    var accountView: some View {
        TabView (selection:$selection){
            ToDoListView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("List", systemImage:"list.clipboard")
                }.tag(1)
            PhotoUpload(userId: viewModel.currentUserId)
                .tabItem {
                    Label("Home", systemImage: "house")
                }.tag(2)
            
            NavigationView {
                CalendarView(
                    monthDate: DateComponents(calendar: .current, year: 2025, month: 3).date!
                )
            }
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }.tag(3)
        }
    }
}

#Preview {
    MainView()
}

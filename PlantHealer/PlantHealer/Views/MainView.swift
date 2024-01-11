//
//  MainView.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 17.04.2023.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var plantsVM: PlantViewModel = PlantViewModel()
    @State private var tabSelection = 1
    
    var body: some View {
        ZStack {
            TabView(selection: $tabSelection) {
                HomeView(tabSelection: $tabSelection)
                    .tabItem {
                        Label("My plants", systemImage: "leaf.fill")
                    }
                    .tag(1)
                    .environmentObject(plantsVM)
                
                CameraView(tabSelection: $tabSelection)
                    .tabItem {
                        Label("Scan plant", systemImage: "camera")
                    }
                    .tag(2)
                    .environmentObject(plantsVM)
            }
            .onAppear {
                NotificationManager.shared.deleteAllNotifications()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

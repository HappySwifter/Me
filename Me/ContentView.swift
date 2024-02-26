//
//  ContentView.swift
//  Me
//
//  Created by Artem on 17.02.2024.
//

import SwiftUI
import SwiftData
import TabularData

struct ContentView: View {
    let csvHelpers: CsvHelpers
    @Environment(\.modelContext) private var modelContext
    @State var isCreateFeaturePresented = false
    @State var isCreateRowPresented = false
    
    var body: some View {
        NavigationSplitView {
            List {
                
            }
            .toolbar {
                ToolbarItem {
                    Button("Add row", systemImage: "plus") {
                        isCreateRowPresented.toggle()
                    }
                }
                ToolbarItem {
                    Button("Add Feature", systemImage: "heart") {
                        isCreateFeaturePresented.toggle()
                    }

                }
            }
        } detail: {
            Text("Select an item")
        }
        .popover(isPresented: $isCreateFeaturePresented) {
            CreateNewFeatureView(csvHelpers: csvHelpers, showSheet: $isCreateFeaturePresented)
        }
        .popover(isPresented: $isCreateRowPresented) {
            CreateNewRowView(viewModel: CreateNewRowViewModel(modelContext: modelContext, csvHelpers: csvHelpers))
        }
        .onAppear {
            
        }
    }

}

#Preview {
    ContentView(csvHelpers: MeApp().csv)

}

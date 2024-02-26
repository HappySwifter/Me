//
//  CreateNewRowView.swift
//  Me
//
//  Created by Artem on 23.02.2024.
//

import SwiftUI
import SwiftData

struct CreateNewRowView: View {
    @State var viewModel: CreateNewRowViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(zip(viewModel.features.indices, viewModel.features)), id: \.0) { index, item in
                    
                    HStack {
                        Image(systemName:"person").foregroundColor(.gray).padding(10)
                        
                        TextField("\(item.name)", text: Binding(
                            get: { return viewModel.values[index].wrappedValue },
                            set: { (newValue) in return viewModel.values[index] = .constant(newValue) }
                        ))
                    }
                    .border(.gray)
                }
                
            }
            .toolbar {
                ToolbarItem {
                    Button("Add row", systemImage: "plus") {
                        viewModel.saveRow()
                    }
                }
            }
        }
    }
}

@Observable
class CreateNewRowViewModel {
    var modelContext: ModelContext
    var features = [Feature]()
    var values = [Binding<String>]()
    let csvHelpers: CsvHelpers

    
    init(modelContext: ModelContext, csvHelpers: CsvHelpers) {
        self.modelContext = modelContext
        self.csvHelpers = csvHelpers
        fetchData()
    }
    
    func fetchData() {
        do {
            features = try csvHelpers.getFeatures()
            features.forEach { _ in
                values.append(.constant(""))
            }
        } catch {
            print("Fetch failed", error)
        }
    }
    
    func saveRow() {
        let date = Calendar(identifier: .gregorian).startOfDay(for: Date())
        do {
            for (index, value) in values.enumerated() {
                let item = Item(timestamp: date,
                                featureName: features[index].name,
                                value: Double(value.wrappedValue)!)
                try csvHelpers.saveNew(item: item)
            }
        } catch {
            print(error)
        }
    }
}

#Preview {
    CreateNewRowView(viewModel: CreateNewRowViewModel(modelContext: MeApp().sharedModelContainer.mainContext, csvHelpers: MeApp().csv))
}

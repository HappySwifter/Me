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
            VStack {
                ForEach(Array(zip(viewModel.features.indices, viewModel.features)), id: \.0) { index, feature in
                    
                    switch feature.type {
                    case .option:
                        
                        VStack {
                            Text(feature.name)
                            Picker(selection: Binding(
                                get: { return viewModel.values[index].wrappedValue },
                                set: { (newValue) in return viewModel.values[index] = .constant(newValue) }
                            )) {
                                ForEach(feature.options, id: \.self) { option in
                                    Text(option)
                                }
                            } label: {
                                Text("")
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        
                    case .yesNo:
                        Toggle(isOn: Binding(
                            get: {
                                return viewModel.boolValue(for: index)
                            },
                            set: { (newValue) in
                                return viewModel.values[index] = .constant(newValue.description) }
                        )) {
                            Text(feature.name)
                        }
                        
                    case .mumeric:
                        Spacer()
                    }
                    
                }
                Spacer()
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
    
    func boolValue(for index: Int) -> Bool {
        Bool(values[index].wrappedValue)!
    }
    
    func fetchData() {
        do {
            features = try csvHelpers.getFeatures()
            features.forEach { feature in
                switch feature.type {
                case .option:
                    values.append(.constant(feature.options.first ?? ""))
                case .yesNo:
                    values.append(.constant("true"))
                case .mumeric:
                    values.append(.constant("0"))
                }
                
            }
        } catch {
            print("Fetch failed", error)
        }
    }
    
    func saveRow() {
        print(values.map { $0.wrappedValue })
        
        let date = Calendar(identifier: .gregorian).startOfDay(for: Date())
        do {
            var items = [Item<Any>]()
            
            for (index, value) in values.enumerated() {
                let type = features[index].type
                let item: Item<Any>
                switch type {
                case .option:
                    item = Item(timestamp: date,
                                    featureName: features[index].name,
                                    value: value.wrappedValue as Any)
                    
                case .yesNo:
                    item = Item(timestamp: date,
                                    featureName: features[index].name,
                                    value: Bool(value.wrappedValue)! as Any)
                case .mumeric:
                    item = Item(timestamp: date,
                                    featureName: features[index].name,
                                    value: Double(value.wrappedValue)! as Any)
                }
                items.append(item)
            }
            try csvHelpers.add(row: items)
            
        } catch {
            print(error)
        }
    }
    
}

#Preview {
    CreateNewRowView(viewModel: CreateNewRowViewModel(modelContext: MeApp().sharedModelContainer.mainContext, csvHelpers: MeApp().csv))
}

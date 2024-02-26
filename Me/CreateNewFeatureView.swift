//
//  CreateNewFeatureView.swift
//  Me
//
//  Created by Artem on 23.02.2024.
//

import SwiftUI
import SwiftData


struct CreateNewFeatureView: View {
    let csvHelpers: CsvHelpers
    @Environment(\.modelContext) private var modelContext
    @Binding var showSheet: Bool
    @State private var name = ""
    @State private var pickedType = InputType.option
    @State private var options: [Binding<String>] = [.constant(""), .constant("")]
    
    enum FocusField: Hashable {
      case field
    }
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack {
                        TextField("Enter name", text: $name)
                            .focused($focusedField, equals: .field)
                            .onAppear {
                              self.focusedField = .field
                          }
                        Divider()
                    }
                    .padding(.vertical)
                    
                    Text("Select input type")
                    Picker(selection: $pickedType) {
                        ForEach(InputType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                                .tag(type)
                        }
                    } label: {
                        Text("")
                    }
                    .pickerStyle(.segmented)
                    
                    VStack(alignment: .leading) {
                        switch pickedType {
                        case .option:
                            Text("Add at least two options")
                            OptionsListView(options: $options)
                        case .yesNo:
                            Spacer()
                        case .mumeric:
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                    
                    Button(action: {
                        saveFeature()
                    }, label: {
                        Text("Save")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(saveButtonColor)
                            .clipShape(Capsule())
                    })
                    .disabled(!isSaveButtonEnabled())
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Hello", systemImage: "pencil.slash") {
                        print(pickedType.rawValue)
                        showSheet.toggle()
                    }
                }

            }
            .navigationTitle("Create new feature")
            .navigationBarTitleDisplayMode(.inline)
        }
        .padding()
        
    }
    
    private func isSaveButtonEnabled() -> Bool {
        if name.isEmpty { return false }
        switch pickedType {
        case .option:
            return options.count >= 2 &&
            !options[0].wrappedValue.isEmpty &&
            !options[1].wrappedValue.isEmpty
        case .yesNo:
            return true
        case .mumeric:
            return false
        }
    }
    
    var saveButtonColor: Color {
        return isSaveButtonEnabled() ? .blue : .blue.opacity(0.3)
    }
    
    private func saveFeature() {
        withAnimation {
            let feature = Feature(name: name,
                                  type: pickedType,
                                  options: options.map { $0.wrappedValue })
            do {
                let date = Calendar(identifier: .gregorian).startOfDay(for: Date())
                let item = Item(timestamp: date, featureName: name, value: 0)
                try csvHelpers.add(feature: feature, value: item)
                modelContext.insert(feature)
                try modelContext.save()
                showSheet = false
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    CreateNewFeatureView(csvHelpers: MeApp().csv, showSheet: .constant(true))
}



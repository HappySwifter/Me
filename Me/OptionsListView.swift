//
//  OptionsListView.swift
//  Me
//
//  Created by Artem on 26.02.2024.
//

import SwiftUI

struct OptionsListView: View {
    //    @State var viewModel: OptionsListViewModel
    @Binding var options: [Binding<String>]
    
    var body: some View {
        VStack(alignment: .leading, content: {
            
            LazyVStack {
                
                ForEach(Array(zip(options.indices, options)), id: \.0) { index, item in
                    
                    VStack {
                        TextField("Option \(index + 1)", text: Binding(
                            get: { return options[index].wrappedValue },
                            set: { (newValue) in return options[index] = .constant(newValue) }
                        ))
                        .font(.system(size: 20))
                        .padding(.vertical, 8)
                        Divider()
                    }
                }
            }
            .padding(.vertical)
            
            Button(action: {
                plusPressed()
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.accentColor)
                    .clipShape(Circle())
            }
        })
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    func plusPressed() {
        options.append(.constant(""))
    }
}



#Preview {
    OptionsListView(options: .constant([.constant(""), .constant("")]))
        .padding()
}

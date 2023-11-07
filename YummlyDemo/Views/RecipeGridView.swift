//
//  RecipeGridView.swift
//  YummlyDemo
//
//  Created by Praveen Nagaraj on 11/6/23.
//

import SwiftUI

struct RecipeGridView: View {
  
  var recipes: [Recipe]
  
  let columns = [
      GridItem(.adaptive(minimum: 256)),
  ]
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns) {
        ForEach(recipes) { recipe in
          RecipeCardView(recipe: recipe)
        }
        Spacer()
      }
      .padding()
    }
  }
}

//#Preview {
//  RecipeGridView(recipes: <#T##[Recipe]#>)
//}

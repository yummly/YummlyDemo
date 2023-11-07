//
//  CollectionDetailView.swift
//  YummlyDemo
//
//  Created by Praveen Nagaraj on 11/6/23.
//

import SwiftUI

struct CollectionDetailView: View {
  
  @EnvironmentObject var store: Store
  
  var collection: RecipeCollection
  
  var body: some View {
    NavigationStack {
      if store.showPlaceholderForCollection(collection) {
        placeholder
      } else {
        RecipeGridView(recipes: store.recipesForCollection(collection))
      }
    }
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        VStack(alignment: .leading) {
          Text(collection.name)
            .font(.largeTitle)
          Text(collection.description)
            .font(.body)
        }
        .padding(.top, 20)
      }
    }
  }
  
  private var placeholder: some View {
    VStack {
      Image(Constants.Images.noRecipe, bundle: .main)
        .resizable()
        .frame(width: 96, height: 96)
        .foregroundStyle(.secondary)
      Text("Add to this collection")
        .font(.title2)
        .foregroundStyle(.primary)
        .padding(.top)
      Text("You have yet to add any recipes to this collection")
        .font(.body)
        .foregroundStyle(.secondary)
        .padding(.top, 2)
    }
  }
}

#Preview {
  CollectionDetailView(collection: RecipeCollection(id: "all-yums", name: "All Saved Recipes", description: "Recipes collected on Yummly", recipeIds: []))
}

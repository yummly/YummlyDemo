//
//  RecipeCardView.swift
//  YummlyDemo
//
//  Created by Praveen Nagaraj on 11/6/23.
//

import SwiftUI

struct RecipeCardView: View {
    
  @EnvironmentObject var store: Store
  
  var recipe: Recipe

  @State var updateCollectionsIsPresented: Bool = false
  @State var showAlert: Bool = false
  
  var body: some View {
    VStack {
      AsyncImage(url: recipe.imageUrl) { image in
        image
          .resizable()
          .scaledToFill()
          .frame(width: 256)

      } placeholder: {
        // TODO: add placeholder
      }
      .clipShape(.rect(cornerRadius: 16, style: .continuous))
      .padding([.top, .leading, .trailing], 16)

      HStack {
        VStack(alignment: .leading) {
          Text(recipe.title)
            .font(.headline)
            .foregroundStyle(.primary)
            .padding(.top, 8)
            .lineLimit(2)
          Text(recipe.author)
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        Spacer()
        Button(action: {
          if store.isRecipeInCollection(recipe) {
            updateCollectionsIsPresented = true
          } else {
            store.heartUnheartRecipe(recipe)
          }
        }, label: {
          Image(systemName: store.isRecipeInCollection(recipe) ? "heart.fill" : "heart")
            .foregroundStyle(store.isRecipeInCollection(recipe) ? .red : .white)
        })
        .buttonBorderShape(.circle)
        .buttonStyle(.bordered)
      }
      .padding([.bottom, .leading, .trailing], 16)
    }
    .contentShape(.rect(cornerRadius: 32, style: .continuous))
    .backgroundStyle(.regularMaterial)
    .hoverEffect(.automatic)
    .sheet(isPresented: $updateCollectionsIsPresented, content: {
      NavigationView {
        List {
          ForEach(store.collections) { collection in
            if !collection.isPersonalRecipesCollection {
              Button {
                if collection.isAllSavedRecipesCollections {
                  if store.isRecipeInMultipleCollections(recipe) {
                    showAlert = true
                  } else {
                    store.addRemoveRecipeFromCollection(recipe, collection: collection)
                    updateCollectionsIsPresented = false
                  }
                } else {
                  store.addRemoveRecipeFromCollection(recipe, collection: collection)
                }
              } label: {
                HStack {
                  Image(systemName: store.isRecipeInCollection(recipe, collection: collection) ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                  Text(collection.name)
                    .padding(.leading)
                  Spacer()
                }
              }
              .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
          }
        }
        .listStyle(.plain)
        .navigationTitle("Update Collections")
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Button("", systemImage: "xmark") {
              updateCollectionsIsPresented = false
            }
            .buttonBorderShape(.circle)
          }
        }
      }
      .alert(isPresented: $showAlert) {
        Alert(title: Text("Remove from all collections?"),
              message: Text("This recipe will no longer be saved and will be removed from all collections"),
              primaryButton: .cancel(),
              secondaryButton: .destructive(
                Text("Remove"),
                action: {
                  showAlert = false
                  updateCollectionsIsPresented = false
                  store.heartUnheartRecipe(recipe)
                }
              )
        )
      }
    })
  }
}


//#Preview {
//  RecipeCardView(recipe: store.mockRecipe)
//}

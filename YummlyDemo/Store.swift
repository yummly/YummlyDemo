//
//  Store.swift
//  YummlyDemo
//
//  Created by Praveen Nagaraj on 11/6/23.
//

import Foundation

class Store: ObservableObject {
  
  // MARK: - Properties
    
  @Published var cookbookSections: [CookbookSection] = []
  @Published var collections: [RecipeCollection] = []
  
  fileprivate var recipes: [Recipe] = []
  
  // MARK: - Lifecycle
  
  init() {
    reset()
  }
  
  // MARK: - Helpers
  
  func reset() {
    guard let mockData = Decode.loadJSON(name: Constants.mockFileName, decodingType: YummlyDemoResponse.self) else { return }
    recipes = mockData.recipes
    
    cookbookSections = mockData.cookbook.sections
    cookbookSections = cookbookSections.map {
      var mutableCookbookSection = $0
      mutableCookbookSection.recipes = []
      switch mutableCookbookSection.contentType {
      case .recipe:
        for recipeId in mutableCookbookSection.contentIds {
          if let recipe = recipe(given: recipeId) {
            mutableCookbookSection.recipes?.append(recipe)
          }
        }
      case .article:
        break
      }
      return mutableCookbookSection
    }
    
    collections = mockData.collections
    collections = collections.map {
      var mutableCollection = $0
      mutableCollection.recipes = []
      for recipeId in mutableCollection.recipeIds {
        if let recipe = recipe(given: recipeId) {
          mutableCollection.recipes?.append(recipe)
        }
      }
      return mutableCollection
    }
  }
  
  func heartUnheartRecipe(_ recipe: Recipe) {
    if isRecipeInCollection(recipe) {
      var mutableCollections: [RecipeCollection] = []
      for collection in collections {
        var mutableCollection = collection
        mutableCollection.recipeIds = collection.recipeIds.filter({ $0 != recipe.id })
        mutableCollection.recipes = collection.recipes?.filter({ $0.id != recipe.id })
        mutableCollections.append(mutableCollection)
      }
      collections = mutableCollections
    } else {
      var mutableCollection = collections[0]
      mutableCollection.recipeIds.insert(recipe.id, at: 0)
      mutableCollection.recipes?.insert(recipe, at: 0)
      collections[0] = mutableCollection
    }
  }
  
  func isRecipeInCollection(_ recipe: Recipe) -> Bool {
    if collections[0].recipeIds.contains(where: { $0 == recipe.id }) {
      return true
    } else {
      return false
    }
  }
  
  func isRecipeInCollection(_ recipe: Recipe, collection: RecipeCollection) -> Bool {
    guard let collection = collections.first(where: { $0.id == collection.id}) else { return true }
    if collection.recipeIds.contains(where: { $0 == recipe.id }) {
      return true
    } else {
      return false
    }
  }
  
  func isRecipeInMultipleCollections(_ recipe: Recipe) -> Bool {
    for collection in collections.filter({ !$0.isAllSavedRecipesCollections }) {
      if collection.recipeIds.contains(where: { $0 == recipe.id }) {
        return true
      }
    }
    return false
  }
  
  func addRemoveRecipeFromCollection(_ recipe: Recipe, collection: RecipeCollection) {
    guard let index = collections.firstIndex(of: collection) else { return }
    var mutableCollection = collections[index]
    if isRecipeInCollection(recipe, collection: collection) {
      mutableCollection.recipeIds = mutableCollection.recipeIds.filter({ $0 != recipe.id })
      mutableCollection.recipes = mutableCollection.recipes?.filter({ $0.id != recipe.id })
    } else {
      mutableCollection.recipeIds.insert(recipe.id, at: 0)
      mutableCollection.recipes?.insert(recipe, at: 0)
    }
    collections[index] = mutableCollection
  }
  
  func showPlaceholderForCollection(_ collection: RecipeCollection) -> Bool {
    guard let collection = collections.first(where: { $0.id == collection.id}) else { return true }
    return collection.recipes?.isEmpty ?? true
  }
  
  func recipesForCollection(_ collection: RecipeCollection) -> [Recipe] {
    guard let collection = collections.first(where: { $0.id == collection.id}) else { return [] }
    return collection.recipes ?? []
  }
  
  func createCollection(title: String, description: String) {
    collections.insert(RecipeCollection(id: UUID().uuidString, name: title, description: description, recipeIds: []), at: 2)
  }
    
  fileprivate func recipe(given recipeId: String) -> Recipe? {
    recipes.first(where: { $0.id == recipeId })
  }
  
  // MARK: - SwiftUI Preview Helpers
  
  var mockRecipe: Recipe {
    return recipes.first!
  }
}

//
//  Models.swift
//  YummlyDemo
//
//  Created by Praveen Nagaraj on 11/6/23.
//

import Foundation

struct YummlyDemoResponse: Codable {
  let recipes: [Recipe]
  let cookbook: Cookbook
  let collections: [RecipeCollection]
}

struct Recipe: Identifiable, Codable {
  let id, title, author: String
  let imageUrl: URL?
  let overview: Overview
  let ingredients: [Ingredient]
  let directions: [String]
//  let nutrition: Nutrition
//  let notes: [Note]  
}

struct Overview: Codable {
  let rating, servings: Double
  let calories: Int
  let time: Int64
}

struct Ingredient: Identifiable, Codable {
  let id, name: String
}

struct Nutrition: Codable {
  let protein, carbs, fat: Int
}

struct Note: Identifiable, Codable {
  let id, title, content: String
}

struct Cookbook: Codable {
  let sections: [CookbookSection]
}

struct CookbookSection: Identifiable, Codable {
  let id, title: String
  let contentType: ContentType
  var contentIds: [String]
  var recipes: [Recipe]? = []
  
  enum ContentType: String, Codable {
    case recipe
    case article
  }
}

struct RecipeCollection: Identifiable, Equatable, Codable {
  static func == (lhs: RecipeCollection, rhs: RecipeCollection) -> Bool {
    lhs.id == rhs.id
  }
  
  let id, name, description: String
  var recipeIds: [String]
  var recipes: [Recipe]? = []
}

extension RecipeCollection {
  /// Returns `true` if the collection type is "All Saved Recipes"
  var isAllSavedRecipesCollections: Bool {
    id == Constants.allSavedRecipesCollectionId
  }
  
  /// Returns `true` if the collection type is "My Personal Recipes"
  var isPersonalRecipesCollection: Bool {
    id == Constants.personalRecipesCollectionId
  }
}


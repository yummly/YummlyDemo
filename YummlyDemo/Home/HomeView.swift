//
//  HomeView.swift
//  YummlyDemo
//
//  Created by Praveen Nagaraj on 11/6/23.
//

import SwiftUI

struct HomeView: View {
  
  @EnvironmentObject var store: Store

  var body: some View {
    NavigationStack {
      RecipeGridView(recipes: store.cookbookSections.first?.recipes ?? [])
        .navigationTitle("Good Morning!")
    }
  }
}

#Preview {
  HomeView()
}

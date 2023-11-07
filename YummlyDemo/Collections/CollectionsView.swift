//
//  CollectionsView.swift
//  YummlyDemo
//
//  Created by Praveen Nagaraj on 11/6/23.
//

import SwiftUI

struct CollectionsView: View {
  
  @EnvironmentObject var store: Store
  
  @State var newCollectionIsPresented: Bool = false
  @State var newCollectionTitle: String = ""
  @State var newCollectionDescription: String = ""

  var body: some View {
    NavigationView {
      List {
        ForEach(store.collections) { collection in
          NavigationLink(destination: CollectionDetailView(collection: collection)) {
            Text(collection.name)
              .foregroundStyle(.primary)
            Spacer()
            Text(String(collection.recipeIds.count))
              .foregroundStyle(.secondary)
          }
        }
      }
      .listStyle(.plain)
      .navigationTitle("Collections")
      .toolbar {
        ToolbarItem {
          Button("", systemImage: "plus") {
            newCollectionIsPresented = true
          }
          .buttonBorderShape(.circle)
        }
      }
    }
    .environmentObject(store)
    .navigationViewStyle(.automatic)
    .sheet(isPresented: $newCollectionIsPresented, content: {
      NavigationView {
        VStack {
          TextField("", text: $newCollectionTitle, prompt: Text("Name your collection"))
            .textFieldStyle(.roundedBorder)
          TextField("", text: $newCollectionDescription, prompt: Text("Add a description (optional)"))
            .textFieldStyle(.roundedBorder)
            .padding(.top)
          Spacer()
          Button {
            store.createCollection(title: newCollectionTitle, description: newCollectionDescription)
            newCollectionIsPresented = false
          } label: {
            Text("Save")
          }
          .padding(.bottom)
        }
        .padding()
        .navigationTitle("Add Collection")
        .onDisappear(perform: {
          newCollectionTitle = ""
          newCollectionDescription = ""
        })
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Button("", systemImage: "xmark") {
              newCollectionIsPresented = false
            }
            .buttonBorderShape(.circle)
          }
        }
      }
    })
  }
}

#Preview {
  CollectionsView()
}

//
//  ContentView.swift
//  FurryFriends
//
//  Created by Russell Gordon on 2022-02-26.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Stored properties
    @State var currentFurryFriend: FurryFriend = FurryFriend(message: "", status: "")
    
    // Address for main image
    // Starts as a transparent pixel – until an address for an animal's image is set
    @State var currentImage = URL(string: "https://www.russellgordon.ca/lcs/miscellaneous/transparent-pixel.png")!
    
    // MARK: Computed properties
    var body: some View {
        VStack {
            VStack {
                
                // Shows the main image
                RemoteImageView(fromURL: currentImage)
                
                
                
                // An heart image to add the dog images to favourites.
                Image(systemName: "heart.circle")
                    .font(.largeTitle)
                
                
                Button(action: {
                    // The task help us update the user interface when the data is ready.
                    Task {
                        // Call the function that will get us a new dog image.
                        await loadNewFurryFriend()
                    }
                    
                }, label: {
                    Text("Another one!")
                })
                    .buttonStyle(.bordered)
                
                HStack {
                    Text("Favourites")
                        .bold()
                    
                    
                }
                // Push main image to top of screen
                Spacer()
                
            }
            
            // Runs once when the app is opened
            .task {
                // Load a dog picture from the endpoint.
                // We are "calling" or "invoking" the function named loadNewFurryFriend
                // The term is called "call site" of a function
                await loadNewFurryFriend()
                
            }
            
            
            .navigationTitle("Furry Friends")
            
            
            
        }
    }
    
    
    // MARK: Functions
    
    // Define the function "loadNewFurryFriend"
    // This part is for definiton.
    // Async keyword means this func can run alongside other tasks.
    func loadNewFurryFriend() async {
        // Example images for each type of pet
        //let remoteCatImage = //"https://purr.objects-us-east-1.dream.io/i/JJiYI.jpg"
        let remoteDogImage = "https://images.dog.ceo/breeds/labrador/lab_young.JPG"
        
        // Replaces the transparent pixel image with an actual image of an animal
        // Adjust according to your preference ☺️
        currentImage = URL(string: remoteDogImage)!
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}

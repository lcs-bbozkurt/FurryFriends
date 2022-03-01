//
//  ContentView.swift
//  FurryFriends
//
//  Created by Russell Gordon on 2022-02-26.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Stored properties
    @Environment(\.scenePhase) var scenePhase
    @State var currentImageURL: FurryFriend = FurryFriend(message: "", status: "")
    
    @State var currentFurryFriend: FurryFriend = FurryFriend(message: "", status: "")
    
    @State var favourites: [FurryFriend] = []   // empty list to start
    
    // Current picture exits currently or not.
    @State var currentFurryFriendAddedToFavourites: Bool = false
    
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
                
                
                //                      CONDITION                        true   false
                    .foregroundColor(currentFurryFriendAddedToFavourites == true ? .red : .secondary)
                    .onTapGesture {
                        
                        // Only add to the list if it is not already there
                        if currentFurryFriendAddedToFavourites == false {
                            
                            // Adds the current joke to the list
                            favourites.append(currentFurryFriend)
                            
                            // Record that we have marked this as a favourite
                            currentFurryFriendAddedToFavourites = true
                            
                        }
                    
                    }
                    .onTapGesture {
                        
                        if currentFurryFriendAddedToFavourites == false {
                            
                            // Adds the current joke to the list
                            favourites.append(currentFurryFriend)
                            
                            // Record that we have marked this as a favourite
                            currentFurryFriendAddedToFavourites = true
                            
                        }
                        
                    }
                
                
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
                // Iterate over the list of favourites
                List(favourites, id: \.self) { currentFavourite in
                    Text(currentFavourite.message)
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
                print("I tried to load a new furryFriend")
                
                // Load the favourites from the file saved on the device
                loadFurryFriends()
                
             
                
            }
            
            // React to changes of state for the app. (foreground, inactive, background)
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .inactive {
                    print("Inactive")
                } else if newPhase == .active {
                    print("Active")
                } else {
                    print("Background")
                    // Permanently save the list of tasks
                    persistFurryFriends()
                }
            }
            .navigationTitle("Furry Friends")
            .padding()
            
            
        }
    }
    
    // MARK: Functions
    
    // Define the function "loadNewFurryFriend"
    // This part is for definiton.
    // Async keyword means this func can run alongside other tasks.
    func loadNewFurryFriend() async {
        let url = URL(string: "https://dog.ceo/api/breeds/image/random")!
        
        // Define the type of data we want from the endpoint
        // Configure the request to the web site
        var request = URLRequest(url: url)
        // Ask for JSON data
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        
        // Start a session to interact (talk with) the endpoint
        let urlSession = URLSession.shared
        
        // Try to fetch a new joke
        // It might not work, so we use a do-catch block
        do {
            
            // Get the raw data from the endpoint
            let (data, _) = try await urlSession.data(for: request)
            
            // Attempt to decode the raw data into a Swift structure
            // Takes what is in "data" and tries to put it into "currentQuote"
            //                                 DATA TYPE TO DECODE TO
            //                                         |
            //                                         V
            currentFurryFriend = try JSONDecoder().decode(FurryFriend.self, from: data)
            
            // Use the String that contains the address of the image
            // to make the RemoteImageView show the image
            
            
          //  @State var currentFurryFriend: FurryFriend = FurryFriend(message: "", status: "")
            
           // RemoteImageView(fromURL: currentImage)
            currentImage = URL(string: currentFurryFriend.message)!
                       
            // Reset the flag that tracks whether the current joke
            // is a favourite
             currentFurryFriendAddedToFavourites = false
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            // Print the contents of the "error" constant that the do-catch block
            // populates
            print(error)
        }
    }
    func persistFurryFriends() {
        // Get a location under which to save the data
        let filename = getDocumentsDirectory().appendingPathComponent(savedFurryFriendsLabel)
        print(filename)
        // Try to encode the data in our list of favourites to JSON
        do {
            // Create a JSONEncoder()
            let encoder = JSONEncoder()
            // Configured the encoder to "pretty print" the JSON
            encoder.outputFormatting = .prettyPrinted
            // encode the list of favourites we have collect
            let data = try encoder.encode(favourites)
            // Write the JSON to a file in the filename location we came up with earlier.
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            // See the data that was written
            print("Saved data to the Documents directory successfully.")
            print("=========")
            print(String(data: data, encoding: .utf8)!)
        } catch {
            print("Unable to write list of favourites to the Documents directory")
            print("=======")
            print(error.localizedDescription)
        }
    }
    func loadFurryFriends() {
        // Get a location under which to save the data
        let filename = getDocumentsDirectory().appendingPathComponent(savedFurryFriendsLabel)
        print(filename)
        // Attempt to load the data
        do {
            // load the row data
            let data = try Data(contentsOf: filename)
            // See the data that was written
            print("Saved data to the Documents directory successfully.")
            print("=========")
            print(String(data: data, encoding: .utf8)!)
            // Decode the JSON into Swift native data structures.
            // NOTE: We use [Quote] since we are loading into a list (array)
            favourites = try JSONDecoder().decode([FurryFriend].self, from: data)
        } catch {
            // What went wrong
            print("Could not load the data from the JSON file")
            print("====")
            print(error.localizedDescription)
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}

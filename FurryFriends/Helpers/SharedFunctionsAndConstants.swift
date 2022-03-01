//
//  SharedFunctionsAndConstants.swift
//  FurryFriends
//
//  Created by Berk Bozkurt on 2022-03-01.
//

import Foundation

// Return the location of the documents directory for this app.
func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    // Return the first path
    return paths[0]
}

// Define a file name (label) that we will write the data to in the directory.
let savedFurryFriendsLabel = "SavedFurryFriends"

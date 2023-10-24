//
//  Movie.swift
//  ios101-lab6-flix
//

import Foundation

struct MovieFeed: Decodable {
    let results: [Movie]
}

struct Movie: Codable, Equatable {
    let title: String
    let overview: String
    let posterPath: String? // Path used to create a URL to fetch the poster image

    // MARK: Additional properties for detail view
    let backdropPath: String? // Path used to create a URL to fetch the backdrop image
    let voteAverage: Double?
    let releaseDate: Date?

    // MARK: ID property to use when saving movie
    let id: Int

    // MARK: Custom coding keys
    // Allows us to map the property keys returned from the API that use underscores (i.e. `poster_path`)
    // to a more "swifty" lowerCamelCase naming (i.e. `posterPath` and `backdropPath`)
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case id
    }
}

// Methods for saving, retrieving and removing movies from favorites
extension Movie {
    // The "Favorites" key: a computed property that returns a String.
    //    - Use when saving/retrieving or removing from UserDefaults
    //    - `static` means this property is "Type Property" (i.e. associated with the Movie "type", not any particular movie instance)
    //    - We can access this property anywhere like this... `Movie.favoritesKey` (i.e. Type.property)
    static var favoritesKey: String {
        return "Favorites"
    }

    // Save an array of favorite movies to UserDefaults.
    //    - Similar to the favoritesKey, we add the `static` keyword to make this a "Type Method".
    //    - We can call it from anywhere by calling it on the `Movie` type.
    //    - ex: `Movie.save(favoriteMovies, forKey: favoritesKey)`
    // 1. Create an instance of UserDefaults
    // 2. Try to encode the array of `Movie` objects to `Data`
    // 3. Save the encoded movie `Data` to UserDefaults
    static func save(_ movies: [Movie], forKey key: String) {
        // 1.
        let defaults = UserDefaults.standard
        // 2.
        let encodedData = try! JSONEncoder().encode(movies)
        // 3.
        defaults.set(encodedData, forKey: key)
    }

    // Get the array of favorite movies from UserDefaults
    //    - Again, a static "Type method" we can call anywhere like this...`Movie.getMovies(forKey: favoritesKey)`
    // 1. Create an instance of UserDefaults
    // 2. Get any favorite movies `Data` saved to UserDefaults (if any exist)
    // 3. Try to decode the movie `Data` to `Movie` objects
    // 4. If 2-3 are successful, return the array of movies
    // 5. Otherwise, return an empty array
    static func getMovies(forKey key: String) -> [Movie] {
        // 1.
        let defaults = UserDefaults.standard
        // 2.
        if let data = defaults.data(forKey: key) {
            // 3.
            let decodedMovies = try! JSONDecoder().decode([Movie].self, from: data)
            // 4.
            return decodedMovies
        } else {
            // 5.
            return []
        }
    }
    
    // Adds the movie to the favorites array in UserDefaults.
    // 1. Get all favorite movies from UserDefaults
    //    - We make `favoriteMovies` a `var` so we'll be able to modify it when adding another movie
    // 2. Add the movie to the favorite movies array
    //   - Since this method is available on "instances" of a movie, we can reference the movie this method is being called on using `self`.
    // 3. Save the updated favorite movies array
    func addToFavorites() {
        // 1.
        var favoriteMovies = Movie.getMovies(forKey: Movie.favoritesKey)
        // 2.
        favoriteMovies.append(self)
        // 3.
        Movie.save(favoriteMovies, forKey: Movie.favoritesKey)
    }

    // Removes the movie from the favorites array in UserDefaults
    // 1. Get all favorite movies from UserDefaults
    // 2. remove all movies from the array that match the movie instance this method is being called on (i.e. `self`)
    //   - The `removeAll` method iterates through each movie in the array and passes the movie into a closure where it can be used to determine if it should be removed from the array.
    // 3. If a given movie passed into the closure is equal to `self` (i.e. the movie calling the method) we want to remove it. Returning a `Bool` of `true` removes the given movie.
    // 4. Save the updated favorite movies array.
//    func removeFromFavorites() {
//        // 1.
//        var favoriteMovies = Movie.getMovies(forKey: Movie.favoritesKey)
//        // 2.
//        favoriteMovies.removeAll { movie in
//            // 3.
//            return self == movie
//        }
//        // 4.
//        Movie.save(favoriteMovies, forKey: Movie.favoritesKey)
//    }
// MARK: - CodeAI Output
        func removeFromFavorites() {
    // 1.
    var favoriteMovies = Movie.getMovies(forKey: Movie.favoritesKey)
    // 2.
    favoriteMovies.removeAll { movie in
        // 3.
        return self == movie
    }
    // 4.
    Movie.save(favoriteMovies, forKey: Movie.favoritesKey)
}
}

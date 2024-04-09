//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Maksim on 08.04.2024.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    
    
    private let networkClient = NetworkClient()
    
    private var mostPopularMoviesUrl: URL {
          
           guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_kiwxbi4y") else {
               preconditionFailure("Unable to construct mostPopularMoviesUrl")
           }
           return url
       }
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
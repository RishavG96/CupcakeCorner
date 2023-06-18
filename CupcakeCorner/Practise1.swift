//
//  Practise1.swift
//  CupcakeCorner
//
//  Created by Rishav Gupta on 18/06/23.
//

import SwiftUI

class User: ObservableObject, Codable {
    var name = "Paul Hudson" // string conforms to codable out of the box
    @Published var name1 = "Paul Hudson" // will not compile - because of Published named property wrapper. Name1 property is automatically wrapped inside another type. In this case it is going to announce any any swift ui views which is watching this
    // In the case of @Published property wrapper, this this is its own struct called Published, and I can store any kind of value. Published struct uses generics. You can make an instance of Published with a type attached to it like Published string or Published Int. You cannot make a Published Object by itself without a type.
    // Swift already have rules in place that if an array contains codable types then the array itself is also codable. then you can read and write arrays. Same as Dict & Sets.But not for Published.
    // So we have to make Published conform to Codable explictely. Tell swift which properties should be loaded and saved and how to do both those actions.
    // Enum that conforms to a special protocol called CodingKey, this means every case of our enum is a value that should be coded (aerchived and unarchived)
    
    enum CodingKeys: CodingKey {
        case name1
    }
    
    // Next, Make some kind of custom initializer given some kind of container and it would use that to read values of all out properties in this case
    
    required init(from decoder: Decoder) throws { // gives Decoder which has all kinds of data for us to read it.
        // required init makes use of the case when if anyone who subclasses our User class with a custom impl they must override this init to add their own values
        let container = try decoder.container(keyedBy: CodingKeys.self) // Ask the decoder for the container which will have the keys of our CodingKeys enum
        name = try container.decode(String.self, forKey: .name1) // Find a string and decode it  for key .name1
    }
    
    // We made the above the above init to decode but we need to tell Swift to encode the type as well
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name1, forKey: .name1)
    }
    
    // now our code compiles.
}

struct Response: Codable {
    var results: [Result]
    
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct Practise1: View {
    @State private var results = [Result]()
    
    @State private var username = ""
    @State private var email = ""
    
    var body: some View {
//        List(results, id: \.trackId) { item in
//            VStack(alignment: .leading) {
//                Text(item.trackName)
//                    .font(.headline)
//
//                Text(item.collectionName)
//                    .font(.headline)
//            }
//        }
//        .task {
//            await loadData()
//            // ack with await that this func might go to sleep
//        }
        VStack {
            AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"), scale: 3) // mention scale as 3x as it downloads 1200 high image and we need to tell it to scale down to 400 points.
            //Resizable and Frame modifiers does not work with AsyncImages to images that get downloaded
            // if we apply modifier to AsyncImage(url:) like frame(width: 300, height: 300) then it is applies to the AsyncImage not to the image inside the AsyncImage
            // thus we use a complex form of AsyncImage that will pass us image when its ready
         
            AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"), scale: 3) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 20, height: 20)
            
            
            // Third way of Async Image - 1. Wether the image was loaded 2. Or Hit an error 3. Or Hasnt finished yet
            
            AsyncImage(url: URL(string: "https://hws.dev/img/bad.png")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                    Text("There was an error loading the image")
                } else {
                    ProgressView()
                }
            }
            .frame(width: 20, height: 20)
            
            Form {
                Section {
                    TextField("Username",text: $username)
                    TextField("Email",text: $email)
                }
                
                Section {
                    Button("Create Account") {
                        print("Creating Account")
                    }
                }
                .disabled(disableForm)
            }
        }
    }
    
    var disableForm: Bool {
        username.count < 5 || email.count < 5
    }
    
    func loadData() async { // writing async tell it that this loadData method here might want to go to sleep in order for it to complete it work. This function cannot be be called on onAppear method as that requires a sync function. SwiftUI provides a task modifier for this. This can call functions that can go to sleep
        
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
        } catch {
            print("Invalid Data")
        }
    }
}

// AsyncImage: Downloads data, caches it locally, and updates the UI view  to display the image when its ready

struct Practise1_Previews: PreviewProvider {
    static var previews: some View {
        Practise1()
    }
}

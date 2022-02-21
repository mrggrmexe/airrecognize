//
//  ContentView.swift
//
//  Created by German Shtukmauster on 06.04.2021.
//

import SwiftUI

var temperature: Int = 0
var pressure: Int = 0
var co2: Int = 0

struct ContentView: View {
    
    @State var posts: [Post] = []
    let timer123 = Timer.publish(every: 10, on: .current, in: .common).autoconnect()
    
    var body: some View {
        
        List(posts){ post in
            VStack{
                if post.temperature != 0 {
                    Text("Temperature:      " + String(post.temperature) + "C               ").fontWeight(.bold).font(.system(size: 20)).animation(.default)
                }
                if post.pressure != 0 {
                    Text("Pressure:       " + String(post.pressure) + "mm.hg        ").fontWeight(.bold).font(.system(size: 20)).animation(.default)
                }
                if post.co2 != 0 {
                    Text("CO:                     " + String(post.co2) + "ppm           ").fontWeight(.bold).font(.system(size: 20)).animation(.default)
                }
            }
            if post.temperature < 30 && post.pressure < 770 && post.co2 < 300 {
                Text("Status: " ).fontWeight(.bold).font(.system(size: 10)).animation(.default)
                Text("OK").fontWeight(.bold).font(.system(size: 10)).animation(.default).foregroundColor(Color.green)
            } else {
                Text("Status: " ).fontWeight(.bold).font(.system(size: 10)).animation(.default)
                Text("BAD").fontWeight(.bold).font(.system(size: 10)).animation(.default).foregroundColor(Color.red)
            }
        }.offset(x: 0, y: 15).onAppear(){
            Api().getPost { (posts) in
                self.posts = posts
            }
            UITableView.appearance().separatorStyle = .none
        }.onReceive(timer123){ posts in
            Api().getPost { (posts) in
                self.posts = posts
            }
        }
    }
}

struct Post: Codable, Identifiable {
    let id = UUID()
    var temperature: Int
    var pressure: Int
    var co2: Int
}

class Api {
    func getPost(completion: @escaping ([Post]) -> ()){
        guard let url = URL(string: "http://172.20.10.2") else {return}
        sleep(2)
        URLSession.shared.dataTask(with: url){ (data, _, _) in
            let posts = try! JSONDecoder().decode([Post].self, from: data!)
            DispatchQueue.main.async {
                completion(posts)
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

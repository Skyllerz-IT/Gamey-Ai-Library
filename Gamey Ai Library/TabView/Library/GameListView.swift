//import SwiftUI
//
//struct GameListView: View {
//    
//    let favorites: [Gamess] = [
//        Gamess(name: "Mario Kart 8 Deluxe", imageName: "mariokart"),
//        Gamess(name: "Path of Exile 2", imageName: "path_of_exile"),
//        Gamess(name: "S.T.A.L.K.E.R.", imageName: "stalker"),
//        Gamess(name: "Marvel Rivals", imageName: "marvel_rivals"),
//        Gamess(name: "Delta Force", imageName: "delta_force"),
//        Gamess(name: "Indiana Jones", imageName: "indiana_jones")
//    ]
//    
//    let recentlyViewed: [Gamess] = [
//        Gamess(name: "Infinity Nikki", imageName: "infinity_nikki"),
//        Gamess(name: "Call of Duty", imageName: "call_of_duty"),
//        Gamess(name: "FIFA 23", imageName: "fifa"),
//        Gamess(name: "Silent Hill 2", imageName: "silent_hill"),
//        Gamess(name: "Satisfactory", imageName: "satisfactory"),
//        Gamess(name: "Kena", imageName: "kena"),
//    ]
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 20) {
//                    Text("Favourites")
//                        .font(.title)
//                        .bold()
//                        .padding(.horizontal)
//                    
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        LazyVGrid(columns: Array(repeating: GridItem(.fixed(120), spacing: 20), count: 3), spacing: 20) {
//                            ForEach(favorites) { Gamess in
//                                VStack {
//                                    Image(Gamess.imageName)
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(width: 120, height: 160)
//                                        .clipShape(RoundedRectangle(cornerRadius: 12))
//                                    
//                                    Text(Gamess.name)
//                                        .font(.caption)
//                                        .multilineTextAlignment(.center)
//                                        .lineLimit(2)
//                                        .fontWeight(.semibold)
//                                }
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                    
//                    Text("Recently Viewed")
//                        .font(.title)
//                        .bold()
//                        .padding(.horizontal)
//                    
//                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
//                        ForEach(recentlyViewed) { Gamess in
//                            Image(Gamess.imageName)
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 120, height: 90)
//                                .clipShape(RoundedRectangle(cornerRadius: 12))
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//                .padding(.top)
//            }
//            .background(
//                LinearGradient(gradient: Gradient(colors: [Color(hex: "E3D1FF"), Color.white]), startPoint: .top, endPoint: .bottom)
//                    .edgesIgnoringSafeArea(.all)
//            )
//        }
//    }
//}
//
//struct Gamess: Identifiable {
//    let id = UUID()
//    let name: String
//    let imageName: String
//}
//
//// Custom Color initializer
//extension Color {
//    init(hex: String) {
//        let scanner = Scanner(string: hex)
//        var rgb: UInt64 = 0
//        scanner.scanHexInt64(&rgb)
//        self.init(
//            .sRGB, red: Double((rgb & 0xFF0000) >> 16) / 255,
//            green: Double((rgb & 0x00FF00) >> 8) / 255,
//            blue: Double(rgb & 0x0000FF) / 255, opacity: 1
//        )
//    }
//}
//
//#Preview {
//    GameListView()
//}

import SwiftUI

// MARK: - 1. DESIGN SYSTEM
struct AppColors {
    static let beige = Color(red: 0.93, green: 0.92, blue: 0.88)
    static let sage = Color(red: 0.71, green: 0.78, blue: 0.71)
    static let brown = Color(red: 0.42, green: 0.29, blue: 0.22)
}

struct PrimaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(AppColors.sage)
            .foregroundColor(.white)
            .font(.system(size: 18, weight: .bold))
            .cornerRadius(25)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
}

// MARK: - 2. MODELLE
struct Product: Identifiable {
    let id = UUID()
    let name: String
    let price: String
    let imageName: String
}

// MARK: - 3. HAUPTEINSTIEG
struct ContentView: View {
    var body: some View {
        NavigationView {
            WelcomeScreen()
        }
        .accentColor(AppColors.brown)
    }
}

// MARK: - 4. WELCOME SCREEN
struct WelcomeScreen: View {
    var body: some View {
        ZStack {
            AppColors.beige.ignoresSafeArea()
            
            VStack(spacing: 10) {
                Spacer()
                
                // LOGO-CHECK: Stelle sicher, dass "logo" in Assets.xcassets exakt so heißt
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    // Falls das Bild fehlt, zeigt dieser Platzhalter, dass der Code läuft:
                    .background(Color.gray.opacity(0.1))
                
                VStack(spacing: 10) {
                    Text("Maria")
                        .font(.system(size: 42, weight: .regular, design: .serif))
                    Text("Mental Wellness")
                        .font(.subheadline)
                        .kerning(2)
                }
                .foregroundColor(AppColors.brown)
                
                Spacer()
                
                VStack(spacing: 15) {
                    NavigationLink(destination: BookingScreen()) {
                        Text("Termine buchen")
                            .modifier(PrimaryButtonModifier())
                    }
                    
                    NavigationLink(destination: ShopScreen()) {
                        Text("Boutique Shop")
                            .modifier(PrimaryButtonModifier())
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - 5. BOOKING SCREEN
struct BookingScreen: View {
    @State private var selectedDate = Date()
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "de_DE")
        return formatter
    }

    let treatments = [
        ("Geführte Meditation", "30 Min - 45€"),
        ("Aroma-Therapie Massage", "60 Min - 85€"),
        ("Silent Yoga Session", "45 Min - 60€"),
        ("Mental Coaching", "50 Min - 120€")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack {
                    DatePicker("Tag wählen", selection: $selectedDate, in: Date()..., displayedComponents: [.date])
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .accentColor(AppColors.brown)
                        .padding(10)
                }
                .background(Color.white)
                .cornerRadius(20)
                .padding()
                .shadow(color: Color.black.opacity(0.05), radius: 10)

                VStack(spacing: 12) {
                    Text("Verfügbar am \(dateFormatter.string(from: selectedDate))")
                        .font(Font.system(size: 14))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    ForEach(treatments, id: \.0) { name, details in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(name)
                                    .font(Font.system(size: 18, weight: .bold))
                                    .foregroundColor(AppColors.brown)
                                Text(details)
                                    .font(Font.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button("Wählen") { print("\(name) gewählt") }
                                .font(Font.system(size: 14, weight: .bold))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 15)
                                .background(AppColors.sage.opacity(0.2))
                                .foregroundColor(AppColors.brown)
                                .cornerRadius(10)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
        .background(AppColors.beige.ignoresSafeArea())
        .navigationTitle("Wellness Termine")
    }
}

// MARK: - 6. SHOP SCREEN
struct ShopScreen: View {
    @State private var showAlert = false
    @State private var selectedProduct = ""
    
    let products = [
        Product(name: "Haus-Marmelade", price: "5.50€", imageName: "Marmelade"),
        Product(name: "Wellness Saft", price: "4.00€", imageName: "Saft"),
        Product(name: "Wein", price: "14.00€", imageName: "Wein"),
        Product(name: "Alm-Käse", price: "8.90€", imageName: "Kaese"),
        Product(name: "Bio-Eier", price: "3.50€", imageName: "Eier"),
        Product(name: "Waldhonig", price: "7.20€", imageName: "Honig")
    ]
    
    let columns = [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(products) { product in
                    Button(action: {
                        selectedProduct = product.name
                        showAlert = true
                    }) {
                        VStack(spacing: 0) {
                            // Bilder aus Assets
                            Image(product.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 120)
                                .clipped()
                                .background(AppColors.sage.opacity(0.1))
                            
                            VStack(spacing: 4) {
                                Text(product.name)
                                    .font(Font.system(size: 14, weight: .bold))
                                    .foregroundColor(AppColors.brown)
                                    .multilineTextAlignment(.center)
                                Text(product.price)
                                    .font(Font.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                        }
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                    }
                }
            }
            .padding()
        }
        .background(AppColors.beige.ignoresSafeArea())
        .navigationTitle("Hofladen")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Warenkorb"), message: Text("\(selectedProduct) wurde hinzugefügt."), dismissButton: .default(Text("OK")))
        }
    }
}

//
//  Home.swift
//  PizzaAnimation
//
//  Created by Szymon Wnuk on 11/10/2022.
//

import SwiftUI

struct Home: View {
    // MARK: Animation Properties
    @State var selectedPizza: Pizza = pizzas[0]
    @State var swipeDirection: Alignment = .center
    @State var animatePizza: Bool = false
    @State var pizzaSize: String = "MEDIUM"
    @Namespace var animation
    var body: some View {
        VStack {
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "menucard")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                }
                Spacer()
                
                Button {
                    
                } label: {
                    Image("pic")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 38, height: 38)
                        .clipShape(Circle())
                }
            }
            .overlay{
                Text(attributedTitle)
                    .font(.title)
                
            }
            
            Text("Select Your Pizza" .uppercased())
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 15)
            
            // MARK: Custom slider
            AnimatedSlider()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(15)
    }
    // MARK: Attrubuted title
    var attributedTitle: AttributedString {
        var string = AttributedString(stringLiteral: "EATPIZZA")
        if let range = string.range(of: "PIZZA") {
            string[range].font = .system(.title, weight: .bold)
        }
        return string
    }
    
    // MARK: Animated Custom Slider
    @ViewBuilder
    func AnimatedSlider() -> some View {
        GeometryReader{ proxy in
            let size = proxy.size
            
            //MARK: Usage of lazy stack to use less memory
            LazyHStack(spacing: 10) {
                ForEach(pizzas) { pizza in
                    let index = getIndex(pizza: pizza)
                    let mainIndex = getIndex(pizza: selectedPizza)
                    VStack(spacing: 10) {
                        Text(pizza.pizzaTitle)
                            .font(.largeTitle.bold())
                        
                        Text(pizza.pizzaDescription)
                            .font(.callout)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.horizontal)
                            .padding(.top,10)
                    }
                    .frame(width: size.width, height: size.height, alignment: .top)
                    //MARK: View change based on gesture
                    .rotationEffect(.init(degrees: mainIndex == index ? 0 : (index > mainIndex ? 180 : -180)))
                    .offset(x: -CGFloat(mainIndex) * size.width, y: index == mainIndex ? 0 : 40)
                }
            }
            // MARK: Pizza View
            PizzaView()
                .padding(.top,120)
            
        }
        .padding(.horizontal,-15)
        .padding(.top,35)
        
    }
    @ViewBuilder
    func PizzaView() -> some View {
        GeometryReader{ proxy in
            let size = proxy.size
            
            ZStack(alignment: .top) {
                Image(selectedPizza.pizzaImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                // MARK: Background flour
                    .background(alignment: .top, content: {
                        Image("Powder")
                            .resizable()
                            .aspectRatio( contentMode: .fit)
                            .frame(width: size.width)
                            .offset(y: -60)
                    })
                    .scaleEffect(1.05, anchor: .top)
                
                ZStack(alignment: .top) {
                    if pizzas.first?.id != selectedPizza.id {
                        // MARK: Left side
                        ArcShape()
                            .trim(from: 0.05, to: 0.3)
                            .stroke(Color.gray, lineWidth: 1)
                            .offset(y: 75)
                        //MARK: Arrow image
                        Image(systemName: "chevron.left")
                            .foregroundColor(.gray)
                            .rotationEffect(.init(degrees: -30))
                            .offset(x: -(size.width / 2) + 30, y: 55)
                    }
                   
                    
                    if pizzas.last?.id != selectedPizza.id {
                        // MARK: Right side
                        ArcShape()
                            .trim(from: 0.7, to: 0.95)
                            .stroke(Color.gray, lineWidth: 1)
                            .offset(y: 75)
                        //MARK: Arrow image
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .rotationEffect(.init(degrees: 30))
                            .offset(x: (size.width / 2) - 30, y: 55)
                    }
                    
                    // MARK: Price attributed string
                    Text(priceAttributedString(value: selectedPizza.pizzaPrice))
                        .font(.largeTitle.bold())
                }
                .offset(y : -80)
                    
            }
            .rotationEffect(.init(degrees: animatePizza ? (swipeDirection == .leading ? -360 : 360) : 0))
            .offset(y: size.height / 2)
            
            //MARK: Gestures
            .gesture(DragGesture()
                .onEnded{
                    value in
                    let translation = value.translation.width
                    let index = getIndex(pizza: selectedPizza)
                    
                    if animatePizza {return}
                  
                    // MARK: if for left swipe
                    if translation < 0 && -translation > 50 && index != (pizzas.count - 1){
                        swipeDirection = .leading
                        handleSwipe()
                    }
                    // MARK: if for right swipe
                    if translation > 0 && translation > 50 && index > 0 {
                        swipeDirection = .trailing
                        handleSwipe()
                    }
                    
                }
            
            )
            
            HStack {
                ForEach(["SMALL","MEDIUM","LARGE"], id: \.self) {text in
                Text(text)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(pizzaSize == text ? .orange : .white)
                            .padding(.vertical, 20)
                            .overlay(alignment: .bottom, content: {
                                if pizzaSize == text {
                                    Circle()
                                        .fill(.orange)
                                        .frame(width: 7, height: 7)
                                        .offset(y: 3)
                                        .matchedGeometryEffect(id: "SIZETAB", in: animation)
                                }
                            })
                            .onTapGesture {
                                withAnimation{
                                    pizzaSize = text
                                }
                            }
                }
                }
            .padding(.horizontal)
            .background{
                ZStack(alignment: . top) {
                    Rectangle()
                        .trim(from: 0.25, to: 1)
                        .stroke(.gray.opacity(0.4), lineWidth: 1)
                    
                    Rectangle()
                        .trim(from: 0, to: 0.17)
                        .stroke(.gray.opacity(0.4), lineWidth: 1)
                    
                    Text("SIZE")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .offset(y: -7)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top,10)
        } .padding(.top)
        
    }
    // MARK: Handle swipe
    func handleSwipe() {
        let index = getIndex(pizza: selectedPizza)
        if swipeDirection == .leading {
            withAnimation(.easeInOut(duration: 0.85)) {
                selectedPizza = pizzas[index + 1]
                animatePizza = true
            }
        }
        if swipeDirection == .trailing {
            withAnimation(.easeInOut(duration: 0.85)) {
                selectedPizza = pizzas[index - 1]
                animatePizza = true
            }
        }
        // MARK: Restoring
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            animatePizza = false
        }
    }
    //MARK: Pizza index
    func getIndex(pizza: Pizza) -> Int {
        return pizzas.firstIndex{
            CPizza in CPizza.id == pizza.id
        } ?? 0
    }
    // MARK: Price string
    func priceAttributedString(value: String) -> AttributedString {
        var attrString = AttributedString(stringLiteral: value)
        if let range = attrString.range(of: "PLN") {
            attrString[range].font = .system(.callout, weight: .bold)
        }
        return attrString
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

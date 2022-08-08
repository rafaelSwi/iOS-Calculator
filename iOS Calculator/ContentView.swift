// Created by Rafael Neuwirth Swierczynski
// Released on Github on August 8, 2022
// Release 1.0

import SwiftUI

struct ContentView: View {
    
    @State var storedNumber = 0.0
    
    @State var showStoredNumber = false
    
    @State var displayText = "0" {
        didSet {
            if (displayText == "0.0" || displayText == "-nan") {displayText = "0"}
            while (displayText.count > 7) {displayText.removeLast()}
            if (displayText.hasSuffix(".0"))
            {displayText.removeLast(); displayText.removeLast()}
        }
    }
    
    @State var darkModeScreen = true
    
    let buttonsArray: [[buttonsCalc]] = [
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .divide],
        [.one, .two, .three, .minus],
        [.zero, .dot, .equals, .plus],
        [.revealStored, .darkmode, .switchOperator, .clear]
    ]
    
    enum buttonsCalc: String {
        
        case one = "1"
        case two = "2"
        case three = "3"
        
        case four = "4"
        case five = "5"
        case six = "6"
        
        case seven = "7"
        case eight = "8"
        case nine = "9"
        
        case zero = "0"
        case dot = "⋅"
        case equals = "＝"
        
        case switchOperator = "∓"
        
        case plus = "＋"
        case minus = "−"
        case divide = "÷"
        case multiply = "×"
        
        case clear = "↺"
        
        case darkmode = "❏"
        
        case revealStored = "⌾"
        
    }
    
    enum lastActions {
        case nothing
        case plus
        case minus
        case multiply
        case divide
    }
    
    @State var lastAction = lastActions.nothing
    
    func resetAll () {
        
        self.displayText = "0"
        self.storedNumber = 0.0
        lastAction = lastActions.nothing
        
    }
    
    func buttonColor (specificButton: buttonsCalc) -> Color {
        
        switch specificButton {
            
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
            return .orange
            
        case .clear: return .red
            
        case .multiply, .minus, .plus, .divide: return .teal
            
        case .equals, .dot: return .blue
            
        case .switchOperator: return .brown
            
        case .darkmode: return Color("ColorModeButton")
            
        case .revealStored: return .gray
            
            
        }
        
        
        
    }
    
    func specificAction (specificButton: buttonsCalc) {
        
        switch specificButton {
            
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            writeDisplay(what: specificButton.rawValue)
            
        case .zero:
            switch displayText {
            case "0": return
            default: displayText += "0"
            }
            
        case .plus:
            lastAction = lastActions.plus
            moveToStored()
            
        case .minus:
            lastAction = lastActions.minus
            moveToStored()
            
        case .multiply:
            lastAction = lastActions.multiply
            moveToStored()
            
        case .divide:
            lastAction = lastActions.divide
            moveToStored()
            
        case .switchOperator:
            if (displayText.contains("-") || displayText == "0")
            {return} else {
                let holdThis = displayText
                displayText = ""
                displayText += "-"
                displayText += holdThis
            }
            
        case .equals: equals(lastAction: lastAction)
            
        case .clear: resetAll()
            
        case .dot:
            if (displayText.contains(".")) {return}
            else {displayText += "."}
            
        case .darkmode:
            darkModeScreen.toggle()
            
        case .revealStored:
            showStoredNumber.toggle()
            
        }
        
    }
    
    func writeDisplay (what: String) {
        
        switch self.displayText {
        case "0": displayText = what
        default: displayText += what
        }
        
    }
    
    func equals (lastAction: lastActions) {
        
        let doubleDisplayText = Double(displayText) ?? 0.0
        let doubleStoredNumber = Double(storedNumber)
        
        switch lastAction {
            
        case .nothing:
            return
        case .divide:
            displayText = "\(doubleStoredNumber / doubleDisplayText)"
        case .multiply:
            displayText = "\(doubleStoredNumber * doubleDisplayText)"
        case .plus:
            displayText = "\(doubleStoredNumber + doubleDisplayText)"
        case .minus:
            displayText = "\(doubleStoredNumber - doubleDisplayText)"
            
        }
        
        storedNumber = 0
        
    }
    
    func moveToStored () {
        storedNumber = Double(displayText) ?? 0.0
        displayText = "0"
    }
    
    var body: some View {
        
        ZStack {
            
            switch darkModeScreen {
            case true: Color(.black).ignoresSafeArea()
            case false: Color("LightWhiteMode").ignoresSafeArea()
            }
            
            VStack {
                
                Spacer()
                
                // Display Text
                HStack {
                    Spacer()
                    Text (self.displayText)
                        .bold()
                        .font(.system(size: 68))
                        .foregroundColor(.white)
                        .padding()
                        .offset(x: 0, y: 15)
                    
                }
                
                if (showStoredNumber == true) {
                    Text("\(storedNumber)")
                        .foregroundColor(.white)
                        .offset(x: 144, y: 0)
                }
                
                VStack {
                    
                    ForEach (buttonsArray, id: \.self) { section in
                        
                        HStack {
                            
                            ForEach (section, id: \.self) { button in
                                
                                Button("\(button.rawValue)") {
                                    self.specificAction(specificButton: button)
                                }
                                .frame(width: 80, height:80)
                                .foregroundColor(.white)
                                .background(buttonColor(specificButton: button))
                                .cornerRadius(43)
                                .font(.system(size:39))
                                
                            }
                            
                        }
                    }
                }
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

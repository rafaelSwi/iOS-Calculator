// Created by RafaelSwi on GitHub
// Released on Github on August 8, 2022
// Release 2.3 (Released August 9, 2022)

import SwiftUI

struct ContentView: View {
    
    @State var storedNumber = 0.0
    
    @State var showStoredNumber = false
    
    let doNotDisplay = ["0.0","-nan", "nan", "inf"]
    
    @State var displayText = "0" {
        didSet {
            for state in doNotDisplay
            {if (displayText == state) {displayText = "0"}}
            
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
    
    enum possibleActions {
        case nothing
        case plus
        case minus
        case multiply
        case divide
    }
    
    @State var lastAction = possibleActions.nothing
    @State var penultimateAction = possibleActions.nothing
    
    func resetAll () {
        
        self.displayText = "0"
        self.storedNumber = 0.0
        lastAction = possibleActions.nothing
        penultimateAction = possibleActions.nothing
        
    }
    
    func buttonColor (specificButton: buttonsCalc) -> Color {
        
        switch specificButton {
            
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
            return .orange
            
        case .clear: return .red
            
        case .multiply, .minus, .plus, .divide: return .teal
            
        case .equals, .dot: return .blue
            
        case .switchOperator: return .brown
            
        case .darkmode:
            if (darkModeScreen == true) {return Color("ColorModeButton")}
            if (darkModeScreen == false) {return .black}
            else {return .black}
            
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
            actionManager(lastAction: possibleActions.plus)
            equalsWhileWork(penultimateAction: penultimateAction, lastAction: lastAction)
            
        case .minus:
            actionManager(lastAction: possibleActions.minus)
            equalsWhileWork(penultimateAction: penultimateAction, lastAction: lastAction)
            
        case .multiply:
            actionManager(lastAction: possibleActions.multiply)
            equalsWhileWork(penultimateAction: penultimateAction, lastAction: lastAction)
            
        case .divide:
            actionManager(lastAction: possibleActions.divide)
            equalsWhileWork(penultimateAction: penultimateAction, lastAction: lastAction)
            
        case .switchOperator:
            
            if (displayText.contains("-")) {displayText.removeFirst(); return}
            
            if (displayText == "0")
            {return} else {
                let holdThis = displayText
                displayText = ""
                displayText += "-"
                displayText += holdThis
            }
            
        case .equals:
            equals(lastAction: lastAction)
            
        case .clear: resetAll()
            
        case .dot:
            if (displayText.contains(".")) {return}
            else {displayText += "."}
            
        case .darkmode:
            darkModeScreen.toggle()
            
        case .revealStored:
            showStoredNumber.toggle()
            
        }
        
        func actionManager (lastAction: possibleActions) {
            
            self.penultimateAction = self.lastAction
            self.lastAction = lastAction
            
            if (penultimateAction == possibleActions.nothing)
            {penultimateAction = lastAction}
            
        }
        
        
    }
    
    func writeDisplay (what: String) {
        
        switch self.displayText {
        case "0": displayText = what
        default: displayText += what
        }
        
    }
    
    func equalsWhileWork (penultimateAction: possibleActions, lastAction: possibleActions) {
        
        let doubleDisplayText = Double(displayText) ?? 0.0
        let doubleStoredNumber = Double(storedNumber)
        
        if (storedNumber == 0.0) {moveToStored()}
        else {
            
            switch penultimateAction {
                
            case .nothing:
                return
            case .divide:
                storedNumber = (doubleStoredNumber / doubleDisplayText)
            case .multiply:
                storedNumber = (doubleStoredNumber * doubleDisplayText)
            case .plus:
                storedNumber = (doubleStoredNumber + doubleDisplayText)
            case .minus:
                storedNumber = (doubleStoredNumber - doubleDisplayText)
                
            }
            
            displayText = "0"
            
        }
    }
    
    func equals (lastAction: possibleActions) {
        
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
            case false: Color("ColorModeButton").ignoresSafeArea()
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


import SwiftUI

struct ClassicClickWheelView: View {
    // Callbacks for interactions
    var onMenuPress: (() -> Void)?
    var onPlayPausePress: (() -> Void)?
    var onPrevPress: (() -> Void)?
    var onNextPress: (() -> Void)?
    
    // Callbacks for the rotary control
    var onTick: ((Int) -> Void)?
    var onCenterPress: (() -> Void)?

    // --- Theme ---
    private let wheelBgColor = Color(red: 245/255, green: 245/255, blue: 247/255)
    private let buttonColor = Color.gray.opacity(0.8)
    private let chicagoFont = Font.system(size: 14, weight: .bold)

    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                // The main rotary control for gesture input
                RotaryControlView(onTick: onTick, onCenterPress: onCenterPress)
                    .frame(width: 300, height: 300)

                // --- Button Labels and Icons ---
                
                // MENU Button (Top)
                Button(action: { onMenuPress?() }) {
                    Text("MENU")
                        .font(chicagoFont.weight(.bold))
                        .tracking(1.0)
                        .foregroundColor(buttonColor)
                        .frame(width: 80, height: 40)
                }
                .offset(y: -115)
                
                // PREV Button (Left)
                Button(action: { onPrevPress?() }) {
                    Image(systemName: "backward.end.fill")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(buttonColor)
                        .frame(width: 60, height: 60)
                }
                .offset(x: -110)

                // NEXT Button (Right)
                Button(action: { onNextPress?() }) {
                    Image(systemName: "forward.end.fill")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(buttonColor)
                        .frame(width: 60, height: 60)
                }
                .offset(x: 110)

                // PLAY/PAUSE Button (Bottom)
                Button(action: { onPlayPausePress?() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "play.fill")
                        Image(systemName: "pause.fill")
                    }
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(buttonColor)
                    .frame(width: 80, height: 60)
                }
                .offset(y: 115)
            }
            
            Spacer().frame(height: 40)
        }
    }
}

#Preview {
    ClassicClickWheelView()
}

//
//  EmptyStateView.swift
//  Journali
//
//  Created by WajenN on 30/05/1448 AH.
//

import SwiftUI

struct EmptyStateView : View {
    var body: some View {
        VStack(spacing:16){
            Image(.emptyStateIllustration)
                .resizable()
                .scaledToFit()
                .frame(width: 140)
            
            Text("Begin Your Journal")
                .font(.system(size: 24,weight: .bold))
                .foregroundStyle(Color(.textAccent))
            
            Text("Craft your personal diary , tap the plus icon to begin")
                .font(.system(size: 18,weight: .light))
                .foregroundStyle(Color(.textPrimary))
                .multilineTextAlignment(.center)
                        
            
            
        }
        .padding(.horizontal, 40)

    
    }
}
#Preview {
    EmptyStateView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.backgroundPrimary))
}
 

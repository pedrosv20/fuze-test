import Foundation
import SwiftUI
import SharedExtensions
import CSTVMatchesService
import DesignSystem

struct ErrorView: View {
    var error: String
    var retryButtonAction: () -> Void
    
    init(
        error: String,
        retryButtonAction: @escaping () -> Void
    ) {
        self.error = error
        self.retryButtonAction = retryButtonAction
    }

    var body: some View {
        VStack(spacing: DS.Spacing.m) {
            Text("OOPS, algo deu errado")
                .setCustomFontTo(.bold(size: DS.FontSize.xm))
                .foregroundColor(DS.Colors.white)
            
            Text(error)
                .setCustomFontTo(.regular(size: DS.FontSize.medium))
                .foregroundColor(DS.Colors.white)
            
            Button(
                action: {
                    retryButtonAction()
                }, label: {
                    Text("Tente novamente")
                        .setCustomFontTo(.bold(size: DS.FontSize.medium))
                }
            )
            .padding()
            .background(DS.Colors.rowBackground)
            .clipShape(Capsule())
        }
    }
}

import UIKit

import BaseFeature
import DesignSystem
import Lottie

final class BroadcastCollectionLoadView: BaseView {
    private let shookAnimationView = LottieAnimationView(name: "shook", bundle: Bundle(for: DesignSystemResources.self))
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private lazy var stackView = UIStackView(arrangedSubviews: [shookAnimationView, titleLabel, subtitleLabel])
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shookAnimationView.play()
    }
    
    override func setupViews() {
        addSubview(stackView)
        
        titleLabel.text = "방송을 불러오는 중이에요!"
        
        subtitleLabel.text = "잠시만 기다려주세요!"
    }
    
    override func setupStyles() {
        shookAnimationView.contentMode = .scaleAspectFit
        shookAnimationView.loopMode = .loop
        shookAnimationView.animationSpeed = 0.4
        
        titleLabel.font = .setFont(.title())
        
        subtitleLabel.textColor = .gray
        subtitleLabel.font = .setFont(.body2())
        
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
    }
    
    override func setupLayouts() {
        stackView.ezl.makeConstraint {
            $0.center(to: self)
        }
        
        shookAnimationView.ezl.makeConstraint {
            $0.width(220)
                .height(80)
        }
    }
}

#if DEBUG
import SwiftUI

struct BroadcastCollectionLoadViewPreview: UIViewRepresentable {
    func makeUIView(context: Context) -> BroadcastCollectionLoadView {
        return BroadcastCollectionLoadView()
    }
    
    func updateUIView(_ uiView: BroadcastCollectionLoadView, context: Context) { }
}

struct BroadcastCollectionLoadViewPreview_Previews: PreviewProvider {
    static var previews: some View {
        BroadcastCollectionLoadViewPreview()
            .background(Color.black)
    }
}
#endif

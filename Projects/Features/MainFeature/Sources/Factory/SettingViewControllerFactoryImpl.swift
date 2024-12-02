import UIKit

import BroadcastDomainInterface
import LiveStationDomainInterface
import MainFeatureInterface

public struct SettingViewControllerFactoryImpl: SettingViewControllerFactory {
    private let fetchChannelInfoUsecase: any FetchChannelInfoUsecase
    private let makeBroadcastUsecase: any MakeBroadcastUsecase
    private let deleteBroadCastUsecase: any DeleteBroadcastUsecase
    
    public init(fetchChannelInfoUsecase: any FetchChannelInfoUsecase, makeBroadcastUsecase: any MakeBroadcastUsecase, deleteBroadCastUsecase: any DeleteBroadcastUsecase) {
        self.fetchChannelInfoUsecase = fetchChannelInfoUsecase
        self.makeBroadcastUsecase = makeBroadcastUsecase
        self.deleteBroadCastUsecase = deleteBroadCastUsecase
    }
    
    public func make() -> UIViewController {
        let viewModel = SettingViewModel(
            fetchChannelInfoUsecase: fetchChannelInfoUsecase,
            makeBroadcastUsecase: makeBroadcastUsecase,
            deleteBroadCastUsecase: deleteBroadCastUsecase
        )
        
        return SettingUIViewController(viewModel: viewModel)
    }
}

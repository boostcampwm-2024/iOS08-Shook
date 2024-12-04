import Combine
import Foundation

import BaseFeatureInterface
import BroadcastDomainInterface
import LiveStationDomainInterface
import MainFeatureInterface

public class SettingViewModel: ViewModel {
    public struct Input {
        let didWriteStreamingName: PassthroughSubject<String, Never> = .init()
        let didWriteStreamingDescription: PassthroughSubject<String, Never> = .init()
        let didTapStartBroadcastButton: PassthroughSubject<Void, Never> = .init()
        let didTapFinishStreamingButton: PassthroughSubject<Void, Never> = .init()
    }

    public struct Output {
        let streamingStartButtonIsActive: PassthroughSubject<Bool, Never> = .init()
        let errorMessage: PassthroughSubject<String?, Never> = .init()
        let isReadyToStream: PassthroughSubject<Bool, Never> = .init()
    }

    private var cancellables = Set<AnyCancellable>()

    private let fetchChannelInfoUsecase: any FetchChannelInfoUsecase
    private let makeBroadcastUsecase: any MakeBroadcastUsecase
    private let deleteBroadCastUsecase: any DeleteBroadcastUsecase

    private var broadcastName: String = ""
    private var channelDescription: String = ""

    private let channelID = UserDefaults.standard.string(forKey: "CHANNEL_ID")
    private let userName = UserDefaults.standard.string(forKey: "USER_NAME")

    private let rtmpKey = "RTMP_SEVICE_URL"
    private let streamKey = "STREAMING_KEY"

    let sharedDefaults = UserDefaults(suiteName: "group.kr.codesquad.boostcamp9.Shook")
    let extensionBundleID = "kr.codesquad.boostcamp9.Shook.BroadcastUploadExtension"
    let isStreamingKey = "IS_STREAMING"

    public init(
        fetchChannelInfoUsecase: FetchChannelInfoUsecase,
        makeBroadcastUsecase: MakeBroadcastUsecase,
        deleteBroadCastUsecase: DeleteBroadcastUsecase
    ) {
        self.fetchChannelInfoUsecase = fetchChannelInfoUsecase
        self.makeBroadcastUsecase = makeBroadcastUsecase
        self.deleteBroadCastUsecase = deleteBroadCastUsecase
    }

    public func transform(input: Input) -> Output {
        let output = Output()

        input.didWriteStreamingName
            .sink { [weak self] name in
                guard let self else { return }
                let validness = valid(name)
                output.streamingStartButtonIsActive.send(validness.isValid)
                output.errorMessage.send(validness.errorMessage)
                if validness.isValid {
                    broadcastName = name
                }
            }
            .store(in: &cancellables)

        input.didWriteStreamingDescription
            .sink { [weak self] description in
                self?.channelDescription = description
            }
            .store(in: &cancellables)

        input.didTapStartBroadcastButton
            .flatMap { [weak self] in
                guard let self, let channelID, let userName else { return Empty<ChannelInfoEntity, Error>().eraseToAnyPublisher() }
                output.isReadyToStream.send(false)
                return fetchChannelInfoUsecase.execute(channelID: channelID)
                    .zip(
                        makeBroadcastUsecase.execute(
                            id: channelID,
                            title: broadcastName,
                            owner: userName,
                            description: channelDescription
                        )
                    )
                    .map { channelInfo, _ in channelInfo }
                    .eraseToAnyPublisher()
            }
            .sink { _ in
            } receiveValue: { [weak self] channelInfo in
                guard let self else { return }
                sharedDefaults?.set(channelInfo.rtmpUrl, forKey: rtmpKey)
                sharedDefaults?.set(channelInfo.streamKey, forKey: streamKey)
                output.isReadyToStream.send(true)
            }
            .store(in: &cancellables)

        input.didTapFinishStreamingButton
            .flatMap { [weak self] _ in
                guard let self,
                      let channelID else { return Empty<Void, Error>().eraseToAnyPublisher() }
                return deleteBroadCastUsecase.execute(id: channelID)
                    .eraseToAnyPublisher()
            }
            .sink { _ in
            } receiveValue: { [weak self] _ in
                NotificationCenter.default.post(name: NotificationName.finishStreaming, object: self)
            }
            .store(in: &cancellables)

        return output
    }

    /// 방송 이름이 유효한지 확인하는 메서드
    /// - Parameter _:  방송 이름
    /// - Returns: (Bool, String?) - 유효 여부와 에러 메시지
    private func valid(_ value: String) -> (isValid: Bool, errorMessage: String?) {
        let trimmedValue = value.trimmingCharacters(in: .whitespaces)

        if trimmedValue.isEmpty {
            return (false, "공백을 제외하고 최소 1글자 이상 입력해주세요.")
        } else {
            return (true, nil)
        }
    }
}

import ReplayKit

class SampleHandler: RPBroadcastSampleHandler {
    override func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
        print("스트리밍 시작")
    }
    
    override func broadcastPaused() {
        print("스트리밍 일시 정지")
    }
    
    override func broadcastResumed() {
        print("스트리밍 재개")
    }
    
    override func broadcastFinished() {
        print("스트리밍 종료")
    }
}

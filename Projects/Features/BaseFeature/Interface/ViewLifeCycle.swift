import Foundation

public protocol ViewLifeCycle {
    /// 뷰 초기화
    func setupViews()
    
    /// 스타일 초기화
    func setupStyles()
    
    /// 스타일 업데이트
    func updateStyles()
    
    /// 레이아웃 초기화
    func setupLayouts()
    
    /// 레이아웃 업데이트
    func updateLayouts()
    
    /// 액션(이벤트) 초기화
    func setupActions()
}

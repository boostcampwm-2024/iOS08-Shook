<div align="center">
<img width = "80" src="https://github.com/user-attachments/assets/89e83a64-37f4-4848-aebc-f26f8031e645">

# Shook
잘하면 재밌고, 못하면 더 재밌는 실시간 게임 스트리밍!


![shook_thumbnail](https://github.com/user-attachments/assets/ae77a4c5-0f33-458c-b61b-6249d26a7a5d)

언제 어디서든 쉽게 모바일 게임 스트리밍을 할 수 있는 실시간 스트리밍 애플리케이션입니다.  
Shook은 게임 스트리밍의 장벽을 낮추고, 누구나 쉽고 재미있게 스트리밍을 시작할 수 있는 환경을 제공합니다.

</div>

## ⭐️ 서비스 소개

실시간으로 스트리밍하는 방송을 확인하고, 스트리머와 소통해 보세요! <br>
채팅을 직접 입력하거나 하트 이모티콘을 활용해 간단한 반응을 남길 수도 있어요.

![description1](https://github.com/user-attachments/assets/e3e624c4-6e8c-434e-b0b2-3a89047d6ace)



## 🧑🏻‍💻 팀원

<table>
  <tr align=center>
    <td width="160px"><img src="https://avatars.githubusercontent.com/u/120548537?v=4"></td>
    <td width="160px"><img src="https://avatars.githubusercontent.com/u/131857557?v=4"></td>
    <td width="160px"><img src="https://avatars.githubusercontent.com/u/91936941?v=4"></td>
    <td width="160px"><img src="https://avatars.githubusercontent.com/u/48616183?v=4"></td>
  </tr>
  <tr align=center>
    <td width="160px"><a href="https://github.com/hyunjuntyler">hyunjuntyler</a></td>
    <td width="160px"><a href="https://github.com/INYEKIM">INYEKIM</a></td>
    <td width="160px"><a href="https://github.com/Siwon-L">Siwon-L</a></td>
    <td width="160px"><a href="https://github.com/yongbeomkwak">yongbeomkwak</a></td>
  </tr>
  <tr align=center>
    <td width="160px">김현준</td>
    <td width="160px">김인예</td>
    <td width="160px">이시원</td>
    <td width="160px">곽용범</td>
  </tr>
</table>

## 💻 개발 환경

<img height="22" src="https://img.shields.io/badge/iOS-16.0+-lightgray"> <img height="22" src="https://img.shields.io/badge/Xcode-16.1-skyblue"> <img height="22" src="https://img.shields.io/badge/Swift-5-orange"> <img height="22" src="https://img.shields.io/badge/Platform-iOS-lightgreen"> <img height="22" src="https://img.shields.io/badge/Tuist-4.12.1-blueviolet">

## ⚙️ 기술 스택

### 🍎 First Party
Apple에서 제공하는 강력한 프레임워크들을 활용하여 안정성과 효율성을 극대화했습니다.
- **URLSession, WebSocket**: Apple의 네트워킹 프레임워크를 활용해 안정적이고 실시간 반응이 가능한 채팅 시스템 구현.
- **Combine**: 비동기 데이터를 효율적으로 처리하고 뷰모델과 뷰 간의 데이터 바인딩을 구현하여 반응형 UI 제공.
- **AVFoundation**: 커스텀 플레이어 구성으로 Shook 만의 스트리밍 경험을 제공.
- **ReplayKit, Broadcast Extension**: 실시간 SampleBuffer를 전송하여 모바일 게임 스트리밍을 안정적으로 구현.

### 🍏 Third Party
검증된 오픈소스 라이브러리를 활용하여 개발 효율을 높이고 사용자 경험을 향상했습니다.
- **Tuist**: 프로젝트를 모듈화하여 프로젝트 세팅이나 코드 구조를 체계적으로 관리하여 개발 과정의 효율성을 높임.
- **HaishinKit**: RTMP 프로토콜을 사용하여 실시간 스트리밍 전송의 안정성을 보장.
- **Lottie**: 인터랙티브 애니메이션을 통해 앱 사용성을 강화하고 사용자 만족도를 높이고자 함.

### 🎈 Our Party
우리 팀의 전문성을 바탕으로 직접 설계하고 구현한 모듈들로, 프로젝트에 차별화된 강점을 더했습니다
- **EasyLayout**: 레이아웃을 쉽고 직관적으로 구성할 수 있도록 설계된 커스텀 모듈. 기존의 Auto Layout에 비해 코드의 가독성과 유지보수성이 높아짐.
- **NetworkModule**: 네트워크 요청 처리 및 데이터 핸들링을 단순화한 독자적 모듈. 프로젝트에 맞춤화된 통신 환경 제공.

### ☁️ Cloud Integration
클라이언트와 서버 간의 원활한 데이터 흐름과 실시간 스트리밍을 지원하기 위해 클라우드 기반 서비스를 적극적으로 활용했습니다.
- **Spring Kotlin**: 서버 사이드 로직과 데이터 처리를 위해 Spring 프레임워크와 Kotlin 언어를 사용. WebSocket 기반의 실시간 채팅 및 스트리밍 제어 기능 구현.
- **Naver Cloud LiveStation**: RTMP 스트리밍 지원 및 방송 송출 기능을 통해 대규모 실시간 스트리밍을 안정적으로 제공.
- **Naver VPC (Virtual Private Cloud)**: Naver Cloud 플랫폼을 기반으로 안전하고 확장 가능한 네트워크 환경을 구축.

## 🚧 아키텍쳐



## ✨기능

### 🎮 모바일 게임 실시간 스트리밍
- ReplayKit과 Broadcast Extension을 활용하여 모바일 게임 화면을 실시간으로 스트리밍.
- HaishinKit을 통해 RTMP 프로토콜을 지원, 원활한 방송 송출 가능.

### 💬 시청자 실시간 시청 및 채팅
- WebSocket 기반의 실시간 채팅 기능으로 스트리머와 시청자 간 원활한 소통 지원.
- 시청자 입장 표시 및 채팅 내용 표시로 실시간 인터랙션 경험 제공.

## 📝 링크

[Wiki](https://github.com/boostcampwm-2024/iOS08-Shook/wiki) | [그라운드 룰](https://github.com/boostcampwm-2024/iOS08-Shook/wiki/그라운드-룰) | [컨벤션](https://github.com/boostcampwm-2024/iOS08-Shook/wiki/깃-컨벤션) | [회의록](https://gorgeous-tibia-3b6.notion.site/ce054a9c415d4bfe84789b985e7884e9?v=73d0a6b91b8845b8b2fbf5b8f573d547&pvs=4) | [브랜드디자인](https://github.com/boostcampwm-2024/iOS08-Shook/wiki/BI) | [UX](https://github.com/boostcampwm-2024/iOS08-Shook/wiki/UX) | [피그마](https://www.figma.com/design/hkrLldcqJ3roPELQa2TSib/Shook?node-id=0-1&t=xLGZhOqOlpR9fV2s-1) |
| -- | -- | -- | -- | -- | -- | -- |

# 간단한 유저 노티피케이션 & 컴바인 사용기

해당 프로젝트는 User Notification & Combine 공부를 위한 레포지토리 입니다!.

## 구현(연습)된 유저 노티피케이션

1. TimeInterval(Trigger)<br>
  1.1 AVFoundation의 AVAudioPlayer를 이용한 알람(Foreground & background)<br>
  1.2 일반 알람(User Notification)을 이용한 알람<br>
  1.3 취소 기능(현재 기준으로 작동하는 알람들에 대한 취소)<br>
  1.4 알람이 진행 될 때 custom haptic 사용<br>
3. Calendar(Trigger)
4. Actions(Category)

위의 순으로 구현되있습니다.

Action은 총 3가지에 대한 Attchment 체험 가능

1. 사진(picture)
2. 동영상(movie)
3. 음원(music)

## Combine을 사용한 이유?

부스트캠프에서는 RxSwift라는 라이브러리를 이용해본적 있음
Combine도 간단하게 공부를 해보았지만 어떻게 사용하는지 & 얼마나 다른지 잘 모름

→ 리엑티브 프로그래밍을 위함 + Combine에 익숙해주기 위해서!

여기서는 Combine을 공부해보고 User Notification의 Delegate 부분 과 Completion Handler를 Combine으로 처리함.

이렇게 해본 이유는 다음과 같음

1. UIKit으로 프로젝트 개발
2. Combine을 적절하게 사용해볼 수 있는 사용처(?)

### 어떤 점이 새로웠는가.
1. 큰틀에서 Combine과 RxSwift는 다르지 않음
  - Publisher <-> Observable, Subscriber <-> Observer와 매칭(100%는 아닌듯 함)
2. RxSwift는 DisPosebag있어 메모리 누수와 같은 현상을 쉽게 관리 할 수 있다는 것이 있었는데 Combine은 그렇지는 못함
  - Combine은 직접 Set<AnyCancellable>을 만들어서 처리를 해주어야 하는 번거로움(?) 있음
3. UserNotification을 많이 사용해보지 않았고, 직전 프로젝트나 다른 프로젝트에서도 사용해보았는데 어떤 구체적인 것이 있는지 알지 못했었음
  - 현재는 구체적인 알람 종류, 트리거, Custom Action과 같은 것들에 대해서 알게됨
4. 알람에 대해서 새롭게 생각하게 됨
  - 애플의 알람 정책(애플은 기본 알람과 똑같은 앱을 복제해서 만들지 못하도록 함)을 알게 되었고, 여러가지 경우(ex: 소리가 계속 나오게 하고 싶은 알람은 어떻게 만들까?)에 대해서 생각하게 됨)
5. 진동은 Audio Tool Box 와 Haptic에 대한 차이점이 있다!

## 공부 기록
  
### AVFoundation(Audio)
 https://cubic-detail-8ce.notion.site/AVFoundation-Audio-e782c978286f4d6ea1aa645758eee65a

### User Notification

[https://cubic-detail-8ce.notion.site/User-Notification-37c9f48b693f445da616533c402385a0](https://www.notion.so/User-Notification-37c9f48b693f445da616533c402385a0)

## Combine

[https://cubic-detail-8ce.notion.site/About-Combine-9006b796693f463296b1e90d3bb6c7bb](https://www.notion.so/About-Combine-9006b796693f463296b1e90d3bb6c7bb)

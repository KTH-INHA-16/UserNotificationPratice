# 간단한 유저 노티피케이션 & 컴바인 사용기

해당 프로젝트는 User Notification & Combine 공부를 위한 레포지토리 입니다!.

## 구현(연습)된 유저 노티피케이션

1. TimeInterval(Trigger)
2. Calendar(Trigger)
3. Actions(Category)

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

## 공부 기록
  
### AVFoundation
 https://cubic-detail-8ce.notion.site/AVFoundation-Audio-e782c978286f4d6ea1aa645758eee65a

### User Notification

[https://cubic-detail-8ce.notion.site/User-Notification-37c9f48b693f445da616533c402385a0](https://www.notion.so/User-Notification-37c9f48b693f445da616533c402385a0)

## Combine

[https://cubic-detail-8ce.notion.site/About-Combine-9006b796693f463296b1e90d3bb6c7bb](https://www.notion.so/About-Combine-9006b796693f463296b1e90d3bb6c7bb)

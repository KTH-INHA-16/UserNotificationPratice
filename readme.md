# User Notification은 어떻게 사용하고 어떤 원리일까

iOS에서 알람 메세지를 보여주거나 할 때에는 User Notification이란 것을 사용한다. 

이 때 기본적으로 사용하는 클래스는 UNUserNotificationCenter를 사용한다.

## UNUserNotificationCenter

기본적으로 앱의 알람에 관련된 활동을 관리하는 클래스. 
기본적으로 여러가지를 할 수 있는데 다음과 같다.

- [유저에게 알람 권한 요청](https://developer.apple.com/documentation/usernotifications/asking_permission_to_use_notifications)
- [알람 타입 설정](https://developer.apple.com/documentation/usernotifications/declaring_your_actionable_notification_types)
- [앱의 로컬 알람 예약](https://developer.apple.com/documentation/usernotifications/scheduling_a_notification_locally_from_your_app)
- [알람 관련된 활동 처리(원격)](https://developer.apple.com/documentation/usernotifications/handling_notifications_and_notification-related_actions)
- [유저 커스텀 알람 처리](https://developer.apple.com/documentation/usernotifications/handling_notifications_and_notification-related_actions)

Delegate채택하여 알람에 관련된 이벤트 처리를 해도 된다.

`.current()` 를 통해 알람 객체 instance에 접근 가능

[Apple Developer Documentation](https://developer.apple.com/documentation/usernotifications/unusernotificationcenter)

## [UNUserNotificationCenterDelegate](https://developer.apple.com/documentation/usernotifications/unusernotificationcenterdelegate)

앱이 동작중(화면 사용중)일 때 알람 관련 이벤트 처리. 

> 앱이 시작할때, 즉 App Delegate에서 알람 Delegate를 할당해서 처리해 주어야함. 이렇게 함으로서 앱에서 무시 되는 알람이 없도록 할 수 있음(앱이 백그라운드거나, inactive할 때)
`[application(_:willFinishLaunchingWithOptions:)](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623032-application)` 
 `[application(_:didFinishLaunchingWithOptions:)](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622921-application)`
보통 위의 두가지 기본 매서드에서 delegate처리 함.
> 

Delegate는 Custom Action 처리, 알람 수신, 알람 보기 설정 3가지 기능에 대한 처리 가능.

[Apple Developer Documentation](https://developer.apple.com/documentation/usernotifications/unusernotificationcenterdelegate)

## 알람 Category & Action

### [Cateogry](https://developer.apple.com/documentation/usernotifications/unnotificationcategory)

UNNotificationCategory 객체로 정의되며 해당 객체는 알람의 종류에 관하여 정의함.

UNUserNotificationCenter에 카테고리를 등록가능 함. 이 때 Identifier를 설정하는 것이 중요. 

해당 식별자는 독립적이며, 구분 가능해야함.

카테고리에서 Action들을 가지고 있음

- properties
    - `[var identifier: String](https://developer.apple.com/documentation/usernotifications/unnotificationcategory/1649276-identifier)`
    - `[var actions: [UNNotificationAction]](https://developer.apple.com/documentation/usernotifications/unnotificationcategory/1649274-actions)`
    - `[var intentIdentifiers: [String]](https://developer.apple.com/documentation/usernotifications/unnotificationcategory/1649282-intentidentifiers)`
    - `[var hiddenPreviewsBodyPlaceholder: String](https://developer.apple.com/documentation/usernotifications/unnotificationcategory/2873736-hiddenpreviewsbodyplaceholder)`
    - `[var categorySummaryFormat: String](https://developer.apple.com/documentation/usernotifications/unnotificationcategory/2963112-categorysummaryformat)`

### [Action](https://developer.apple.com/documentation/usernotifications/unnotificationaction)

알람에 관련된 액션에 대한 처리를 담당하는 부분

어떤 알람에 대한 액션을 카테고리에 추가하여 원하는 동작을 하도록 처리하는 것이 가능하다.

## [알람의 Content](https://developer.apple.com/documentation/usernotifications/unmutablenotificationcontent)

알람 Content는 로컬 알람에서 알람의 내용을 넣기 위해서 사용하는 인스턴스.

단순하게 메세지를 설정하는 것 뿐만아닌, 개발자가 직접 원하는 양식으로 알람 내용을 꾸미는 것이 가능.

EX) Image, Sound, Label Etc

해당 Content는 [Request 객체](https://developer.apple.com/documentation/usernotifications/unnotificationrequest)에 할당되어 처리됨. request 객체에 알람이 발동될 조건, 시간과 같은 것들을 추가하는 것이 가능.

만약 알람의 메세지를 다국어 처리를 한다고 하면 Localizable.strings를 활용하는 것이 가능

- properties
    - `[var title: String](https://developer.apple.com/documentation/usernotifications/unmutablenotificationcontent/1649858-title)`
    - `[var subtitle: String](https://developer.apple.com/documentation/usernotifications/unmutablenotificationcontent/1649873-subtitle)`  주된 이유에서 벗어난 서브 이유(알람을 띄우는?)
    - `[var body: String](https://developer.apple.com/documentation/usernotifications/unmutablenotificationcontent/1649874-body)`
    
    위는 알람에 대한 미리보기 문자열
    
    - `[var badge: NSNumber?](https://developer.apple.com/documentation/usernotifications/unmutablenotificationcontent/1649875-badge)`
    - `[var sound: UNNotificationSound?](https://developer.apple.com/documentation/usernotifications/unmutablenotificationcontent/1649868-sound)`
    
    sound는 특히 주의점이 필요한데, 우선 소리는 30초를 넘길 수 없다.(넘길시 기본 소리 출력)
    
    3가지 file type(aiff, wav, caf)지원
    
    음원 파일 경로를 넣어주는 방식으로 custom sound 출력 가능
    
    - `[var launchImageName: String](https://developer.apple.com/documentation/usernotifications/unmutablenotificationcontent/1649861-launchimagename)`
    
    이미지 파일 경로 넣어주어야 함
    
    - `[var userInfo: [AnyHashable : Any]](https://developer.apple.com/documentation/usernotifications/unmutablenotificationcontent/1649867-userinfo)`
    
    사용자에게는 보이지 않지만 관련 정보를 dictionary로 저장함(key-value) 
    
    알람 확장에 관련된 정보들을 저장하는 Dictionary
    
    - `[var attachments: [UNNotificationAttachment]](https://developer.apple.com/documentation/usernotifications/unmutablenotificationcontent/1649857-attachments)`
    
    알람에 관련된 확장된 정보(영상, 소리...)같은 정보들을 담아두는 부분
    
    [Attachment](https://developer.apple.com/documentation/usernotifications/unnotificationattachment)는 소리(5MB), 사진(10MB), 영상(50MB)가능
    
    여기서 영상물의 Thumbnail은 [UNNotificationAttachmentOptionsThumbnailClippingRectKey](https://developer.apple.com/documentation/usernotifications/unnotificationattachmentoptionsthumbnailclippingrectkey)를 이용
    
    만약 재생되는 영상물인 경우 [UNNotificationAttachmentOptionsThumbnailTimeKey](https://developer.apple.com/documentation/usernotifications/unnotificationattachmentoptionsthumbnailtimekey)를 이용하여 thumbnail 설정 가능
    
    - `[var interruptionLevel: UNNotificationInterruptionLevel](https://developer.apple.com/documentation/usernotifications/unmutablenotificationcontent/3747253-interruptionlevel)`
    
    알람의 수준 설정 가능
    
    4가지 설정 가능
    
    - active 화면에 즉시 표시되고, 소리 재생
    - critical 즉시 화면에 표시되고, 음소거를 무시하고 소리 재생
    - passive 상황에 따라 소리 및 화면에 표시되거나 재생되지 않음
    - timeSensitive 시스템에 설정된 알람 설정을 무시하지 않고 소리 및 화면에 표시, 재생

## [알람 Request](https://developer.apple.com/documentation/usernotifications/unnotificationrequest)

Content(Mutable, 일반 Content)+ Trigger 객체를 통해 알람을 활성화 함. 

request는 add 매서드를 통해 알람 객체에서 순차적으로 처리하게 됨.

## [알람 Trigger](https://developer.apple.com/documentation/usernotifications/unnotificationtrigger)

4가지 종류의 트리거 사용 가능

- `[UNTimeIntervalNotificationTrigger](https://developer.apple.com/documentation/usernotifications/untimeintervalnotificationtrigger)`

초단위에 따른 

- `[UNCalendarNotificationTrigger](https://developer.apple.com/documentation/usernotifications/uncalendarnotificationtrigger)`

달력 정보에 따른

- `[UNLocationNotificationTrigger](https://developer.apple.com/documentation/usernotifications/unlocationnotificationtrigger)`

위치에 따른(들어오거나, 나가거나)

- `[UNPushNotificationTrigger](https://developer.apple.com/documentation/usernotifications/unpushnotificationtrigger)`

APNs(Apple push notification Service)를 이용

## 알람 관련 정보 & 종류

- 앱의 알람 종류에 따라
    - badge
    
    앱 아이콘 위의 나타나는 문자
    
    - sound
    
    알람 소리 
    
    - alert
    
    알람 표시 여부
    
    - carPlay
    
    carPlay 환경에서 알람
    
    - criticalAlert
    
    음소거, 무음 모드와 같은 모드 무시하고 알람을 표시
    
    - providesAppNotificationsSettings
    
    앱 내부에서 제공되는 알람 형식
    
    - provisional
    
    알람을 띄우지 않으면서 알람 센터에서는 확인 할 수 있는 알람
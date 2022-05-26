# 프로젝트 소개
### Sound Anywhere은 일상 속 의미있는 공간에 어울리는 음원을 공유하는 위치기반 서비스입니다.

## 프로젝트 구조
### **MVVM** / **Clean Architecture**
* * *
![](./ScreenShots/001.jpeg)
* * *


## 프로젝트 구현 기능
### 지도 화면

| 위치 권한 요청 및 현재 위치 표시    | 사운드 존 표시 |
| --------------------------- | --------------------------- |
| ![](./ScreenShots/001.gif)  | ![](./ScreenShots/002.gif) |

## 기술적 도전

---

### Clean Architecture
- 비즈니스 로직(Domain)을 외부 레이어(Presentation, Data)에 독립적 테스트. (외부 레이어에 의존 X)

---

### Modularization
- Clean Architecture Layer를 별도 모듈로 분리.
- Storyboard, Asset, Dummy(json)를 Resource 모듈로 분리.
- 전역적으로 사용되는 Extension, UserDefault를 Common 모듈로 분리.
- Rx에 의존적인 Extension을 RxCommon 모듈로 분리.
- RxPackage, RxTestPackage 모듈로 Unit Test시 RxSwift [중복적재 이슈](./Trouble-Shooting/001.md) 해결. 

---

### MVVM
- Data Binding을 통해 ViewModel이 View에 의존하지 않으므로 View에 독립적 테스트.

---

### RxSwift
- Observable 모델은 비동기 이벤트 스트림을 Operator로 쉽게 처리. 또한 복잡한 CallBack을 회피하여 가독성 개선,
의도하지 않은 버그 회피.

---

### Testablity
- Concrete Type 대신 Interface에 의존하여 Testability 개선.
- 인터페이스를 Command, Query 인터페이스로 분리하여 Unit Test에 Mock, Stub 적용.
- Firestore 대신 HashTable로 구현한 FakeFirestore를 Debug/Unit Test에 도입하여 Side Effect 제거, 
Unit Test 시간 감축.

---

## 기술적 고민
###
[1. CoreLocation 위치권한처리](./Technical-Difficulties/001.md)
<br/>
[2. UI Test 도입하기](./Technical-Difficulties/004.md)
<br/>
###

---

## 트러블 슈팅

### 
[1. UnitTest Target에 RxTest/RxBlocking 추가 시 RxSwift 중복적재 문제](./Trouble-Shooting/001.md)
<br/>
### 

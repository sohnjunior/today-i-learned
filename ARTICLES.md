> 💡 도움이 될 만한 좋은 글들을 모아놓습니다.

### 🌐 Web

- 카카오페이지 CORS 원인을 파악하고 해결하기까지의 과정
    - [1편 - 문제정의 및 해결방법](https://fe-developers.kakaoent.com/2023/230420-beyond-solving-problem-part-1/)
    - [2편 - 원인 규명하기](https://fe-developers.kakaoent.com/2023/230421-beyond-solving-problem-part-2/)
    - stylesheet 전역 import 와 개별 import 에서 발생하는 빌드 결과의 차이, 브라우저마다 다른 캐시 정책과 그로 인해 발생한 stylesheet fetch 요청 CORS 에러 등의 문제 해결 사례
    - 원인을 찾고 해결하는 과정이 인상깊은 글이다.


### 👨‍💻 React Tips & Snacks

- [state initialize pattern](https://kentcdodds.com/blog/the-state-initializer-pattern)
    - 변하지 않아야하는 초기값과 이를 재설정하는 패턴에 관한 소소한 팁

- [웹의 발전사와 React 튜토리얼 시각화 자료](https://react.gg/visualized/)
    - 웹이 발전한 역사적인 배경을 러프하게 살펴보고 리액트의 기능과 동작 방식을 시각적으로 소개하는 자료


### 🏗 Frontend (Architecture)
- [합성 컴포넌트로 모달 구현하기](https://fe-developers.kakaoent.com/2022/220731-composition-component/)
    - 컴포넌트 재사용성을 위한 compound pattern 을 예시와 함께 설명한 글

- [프론트엔드 개발에서 SOLID 원칙이란?](https://fe-developers.kakaoent.com/2023/230330-frontend-solid/)
    - 프론트엔드 개발자의 관점에서 바라본 SOLID 원칙에 관한 글
    - 실무에서 적용해봄직한 예제들로 SOLID 원칙을 소개한다.


### 🎨 Frontend (css)

- [좋은 transition 구현을 위한 10가지 팁](https://joshcollinsworth.com/blog/great-transitions)
    - UX 관점에서 좋은 transition 이란? 에 관한 내용을 주로 담고 있는 글
    - transition 성능을 위한 팁들 (`will-change` 속성, layout 을 유발하는 속성 피하기) 도 알려준다.


### 📶 Network

- [load-balancing 알고리즘](https://samwho.dev/load-balancing/)
    - 다양한 로드밸런싱 알고리즘에 관한 소개글
    - dynamic weight round robin, least-connection 등등의 방법을 시각적으로 확인할 수 있다.

### 🧪 Testing

- [Avoid Nesting when you're Testing](https://kentcdodds.com/blog/avoid-nesting-when-youre-testing#apply-aha-avoid-hasty-abstractions)
    - 과한 추상화, 중첩된 테스트 로직과 mutable variable 에 대한 경고와 대안들에 관한 글
    - [AHA 원칙](https://kentcdodds.com/blog/aha-programming) 도 함께 읽어보자

### 🔀 Git/Branch Strategy

- [당근페이 - 매일 배포하는 팀이 되는 여정, GitHub Flow](https://medium.com/daangn/%EB%A7%A4%EC%9D%BC-%EB%B0%B0%ED%8F%AC%ED%95%98%EB%8A%94-%ED%8C%80%EC%9D%B4-%EB%90%98%EB%8A%94-%EC%97%AC%EC%A0%95-1-%EB%B8%8C%EB%9E%9C%EC%B9%98-%EC%A0%84%EB%9E%B5-%EA%B0%9C%EC%84%A0%ED%95%98%EA%B8%B0-1a1df85b2cff)
    - 애자일 문화에서 GitHub Flow 도입에 관한 글

- [당근페이 - 매일 배포하는 팀이 되는 여정, Feature Toggle 활용하기](https://medium.com/daangn/%EB%A7%A4%EC%9D%BC-%EB%B0%B0%ED%8F%AC%ED%95%98%EB%8A%94-%ED%8C%80%EC%9D%B4-%EB%90%98%EB%8A%94-%EC%97%AC%EC%A0%95-2-feature-toggle-%ED%99%9C%EC%9A%A9%ED%95%98%EA%B8%B0-b52c4a1810cd)
    - Feature Toggle 로 유연한 배포 환경을 구축한 사례 분석글

- [git diff 에서 범위 연산차 .., ... 차이](https://stackoverflow.com/questions/7251477/what-are-the-differences-between-double-dot-and-triple-dot-in-git-dif/46345364#46345364)
     - trunk 배포가 아닌 경우에 유의하자. 누락되는 diff 가 발생할 수 있다.


> 💡 도움이 될 만한 좋은 글들을 모아놓습니다.

### 🌐 Web

- [web 서비스 아키텍쳐 overview](https://medium.com/storyblocks-engineering/web-architecture-101-a3224e126947)
    - 모던 웹 서비스가 어떤 컴포넌트들로 구성되어있는지 전체적인 그림을 살펴보자.

- 카카오페이지 CORS 원인을 파악하고 해결하기까지의 과정
    - [1편 - 문제정의 및 해결방법](https://fe-developers.kakaoent.com/2023/230420-beyond-solving-problem-part-1/)
    - [2편 - 원인 규명하기](https://fe-developers.kakaoent.com/2023/230421-beyond-solving-problem-part-2/)
    - stylesheet 전역 import 와 개별 import 에서 발생하는 빌드 결과의 차이, 브라우저마다 다른 캐시 정책과 그로 인해 발생한 stylesheet fetch 요청 CORS 에러 등의 문제 해결 사례
    - 원인을 찾고 해결하는 과정이 인상깊은 글이다.

### 👨‍💻 React overview

- [React 와 선언형 UI](https://blog.mathpresso.com/declarative-react-and-inversion-of-control-7b95f3fbddf5)
    - 선언형 UI 라이브러리로서의 React 에 대한 설명글

- [Hook 의 call index 방식을 사용하는 이유](https://overreacted.io/why-do-hooks-rely-on-call-order/)
    - 다른 대안 (key 방식) 을 사용했을때 발생하는 이슈들을 분석해보고 `call-index` 방식이 주는 유연함을 설명해주는 글

- [Hook 의 등장배경](https://medium.com/@dan_abramov/making-sense-of-react-hooks-fdbde8803889)
    - Hook 으로 풀고자 했던 문제들을 소개하는 글

- [useState 가 올바른 renderer 와 동작하는 방법](https://overreacted.io/how-does-setstate-know-what-to-do/)
    - react 패키지와 react-renderer (react-dom, react-dom-server 등) 와 함께 동작하는 방식을 간단히 설명한 글 (의존성 주입) 

### 👨‍💻 React Tips & Snacks

- [state initialize pattern](https://kentcdodds.com/blog/the-state-initializer-pattern)
    - 변하지 않아야하는 초기값과 이를 재설정하는 패턴에 관한 소소한 팁

- [웹의 발전사와 React 튜토리얼 시각화 자료](https://react.gg/visualized/)
    - 웹이 발전한 역사적인 배경을 러프하게 살펴보고 리액트의 기능과 동작 방식을 시각적으로 소개하는 자료

- [Context API 튜토리얼](https://velog.io/@velopert/react-context-tutorial)
    - Context API 를 사용하는 몇가지 유용한 패턴에 대해서 알려주는 입문글

- [compound component 에서 ref 전달하는 방법](https://stackoverflow.com/questions/70202711/how-to-attach-a-compound-component-when-using-react-forward-ref-property-does-n)
    - `Object.assign` 을 사용하는 방법이 더 좋아보인다.

### 🏗 Frontend (Architecture)
- [합성 컴포넌트로 모달 구현하기](https://fe-developers.kakaoent.com/2022/220731-composition-component/)
    - 컴포넌트 재사용성을 위한 compound pattern 을 예시와 함께 설명한 글

- [프론트엔드 개발에서 SOLID 원칙이란?](https://fe-developers.kakaoent.com/2023/230330-frontend-solid/)
    - 프론트엔드 개발자의 관점에서 바라본 SOLID 원칙에 관한 글
    - 실무에서 적용해봄직한 예제들로 SOLID 원칙을 소개한다.

- [widget driven development](https://alexei.me/blog/widget-driven-development/)
    - 컴포넌트를 설계할 때 시도해볼만한 구조
    - data layer 를 분리하고 container 의 역할을 widget 에 위임한다. (widget 은 하위 presentation component 로 구성)

- [micro frontend 아키텍처](https://martinfowler.com/articles/micro-frontends.html)
    - micro frontend 구조에 대한 장단점
    - SPA 에서 micro frontend 아키텍처를 코드레벨로 구현하는 예시와 함께 설명

### 🎨 Frontend (css)

- [좋은 transition 구현을 위한 10가지 팁](https://joshcollinsworth.com/blog/great-transitions)
    - UX 관점에서 좋은 transition 이란? 에 관한 내용을 주로 담고 있는 글
    - transition 성능을 위한 팁들 (`will-change` 속성, layout 을 유발하는 속성 피하기) 도 알려준다.

- [styled-component 내부 동작 원리](https://john015.netlify.app/styled-components%EB%8A%94-%EC%96%B4%EB%96%BB%EA%B2%8C-%EB%8F%99%EC%9E%91%ED%95%A0%EA%B9%8C)
    - styled-component 가 각 컴포넌트마다 고유한 스타일을 할당하는 방법에 대한 소개글

- [border 동작이 헷갈릴 때 참고할만한 그림](https://www.csscodelab.com/html-css-border-radius-triangle/)
    - border 를 조작해서 여러 도형 만들기

### 📶 Network

- [load-balancing 알고리즘](https://samwho.dev/load-balancing/)
    - 다양한 로드밸런싱 알고리즘에 관한 소개글
    - dynamic weight round robin, least-connection 등등의 방법을 시각적으로 확인할 수 있다.

### 🧪 Testing

- [Avoid Nesting when you're Testing](https://kentcdodds.com/blog/avoid-nesting-when-youre-testing#apply-aha-avoid-hasty-abstractions)
    - 과한 추상화, 중첩된 테스트 로직과 mutable variable 에 대한 경고와 대안들에 관한 글
    - [AHA 원칙](https://kentcdodds.com/blog/aha-programming) 도 함께 읽어보자

- [테스트 전략](https://web.dev/ta-strategies/)
    - 다양한 테스트 전략들을 소개하는 글
    - 개인적으로 testing trophy 가 실용적으로 보인다.

### 🔀 Git/Branch Strategy

- [당근페이 - 매일 배포하는 팀이 되는 여정, GitHub Flow](https://medium.com/daangn/%EB%A7%A4%EC%9D%BC-%EB%B0%B0%ED%8F%AC%ED%95%98%EB%8A%94-%ED%8C%80%EC%9D%B4-%EB%90%98%EB%8A%94-%EC%97%AC%EC%A0%95-1-%EB%B8%8C%EB%9E%9C%EC%B9%98-%EC%A0%84%EB%9E%B5-%EA%B0%9C%EC%84%A0%ED%95%98%EA%B8%B0-1a1df85b2cff)
    - 애자일 문화에서 GitHub Flow 도입에 관한 글

- [당근페이 - 매일 배포하는 팀이 되는 여정, Feature Toggle 활용하기](https://medium.com/daangn/%EB%A7%A4%EC%9D%BC-%EB%B0%B0%ED%8F%AC%ED%95%98%EB%8A%94-%ED%8C%80%EC%9D%B4-%EB%90%98%EB%8A%94-%EC%97%AC%EC%A0%95-2-feature-toggle-%ED%99%9C%EC%9A%A9%ED%95%98%EA%B8%B0-b52c4a1810cd)
    - Feature Toggle 로 유연한 배포 환경을 구축한 사례 분석글

- [git diff 에서 범위 연산차 .., ... 차이](https://stackoverflow.com/questions/7251477/what-are-the-differences-between-double-dot-and-triple-dot-in-git-dif/46345364#46345364)
     - trunk 배포가 아닌 경우에 유의하자. 누락되는 diff 가 발생할 수 있다.

### 🧹 Coding Convention

- [좋은 commit 메시지 남기기](http://who-t.blogspot.com/2009/12/on-commit-messages.html)
    - 의도와 side-effect, 접근 방법에 대해 서술하는 message body 와 50~78자 사이의 summary 를 제공하자

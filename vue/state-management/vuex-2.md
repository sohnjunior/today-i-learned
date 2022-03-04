# [Vue 상태관리 2편] Vuex 를 이용한 상태 관리

## 📌 Vuex 란?

`Vuex` 는 `vue` 커뮤니티에서 공식 지원하는 중앙 집중식 상태 관리 시스템입니다.

관리하는 데이터가 중앙에 집중되어있는 덕분에 데이터를 `props` 와 `event emit` 으로

다른 컴포넌트들과 통신하는 복잡도를 낮출 수 있습니다.

## 📌 Vuex 를 왜 써야할까?

### 앱이 사용자와 상호작용하는 과정

우리의 애플리케이션(SPA)은 다음과 같이 `view, state, actions` 의 흐름으로

사용자와의 상호작용이 일어납니다.

![1](https://user-images.githubusercontent.com/37819666/156787553-7c871529-747e-4329-a22e-36b8c2b54aa9.png)

사용자가 특정 `action` 을 취하면 그에 따라 `state` 가 바뀌고 이것이 `view` 에 반영됩니다.

우리가 구현하는 각각의 컴포넌트들은 `view` 를 구성하고 있으며

때문에 각각의 `state` 는 컴포넌트에 종속되어 있습니다.

### 그렇다면 대규모 앱에서는?

작은 크기의 앱이라면 위와 같은 구조는 전혀 문제될 것이 없습니다.

단순히 각각의 컴포넌트에서 상태를 관리해주면 되는 것입니다.

하지만 현대 모던 웹 애플리케이션은 복잡한 화면들로 구성되어있고,

그에 따라 다음과 같이 복잡한 컴포넌트 트리를 이루고 있습니다.

![2](https://user-images.githubusercontent.com/37819666/156787550-11a359b0-bb70-4cc0-8784-8d7403907b14.png)

`Vue` 에서는 부모와 자식간의 데이터 전달은 `props` 로 하고,

자식은 부모에게 `event emit` 을 통해 부모에게서 전달받은 상태값이 변화해야 한다는 것을 알립니다.

복잡한 구조로 되어있는 컴포넌트 트리에서는 데이터를 받아야하는 하위 컴포넌트에 도달할 때까지

존재하는 모든 자식 컴포넌트들에게 `props` 를 계속 전달해주는 이슈가 발생할 수 있는 것입니다.

이를 흔히 `props drilling` 이라고 하며 `상태관리` 는 이러한 이슈 때문에 등장하게 되었습니다.

### 상태 관리를 이용한 앱 구조는 이렇게 변합니다.

`Vuex` 는 중앙 집중식 상태 관리 시스템입니다.

컴포넌트끼리 공유되어야 하는 상태는 `Vuex` 를 통해 관리하며

따라서 다음과 같은 구조를 가지게 됩니다.

![3](https://user-images.githubusercontent.com/37819666/156787548-5ece2d74-2b93-48e7-a5a0-dca940bf34e7.png)

### 또 다른 예시

`Vuex` 를 사용하기 전과 후의 앱 구조를 보여주는 좋은 예시가 있어서 가져왔습니다.

`loggedInUser` 라는 데이터를 하위 컴포넌트들에서 사용해야하는 상황인데

`props & event emit` 방식과 `vuex` 를 사용할 경우의 차이점이 명확히 보이네요 😄.

![4](https://user-images.githubusercontent.com/37819666/156787545-0266573d-0017-40bd-b36b-c43f261051c6.png)

## 📌 Vuex 와 FLUX 패턴

`Vuex` 는 `Flux` 패턴에 영감을 받아 만들어진 상태관리 라이브러리입니다.

그렇다면 `Flux` 패턴은 무엇이고 어떤 문제를 해결하려고 했던 것일까요?

### MVC 패턴

![5](https://user-images.githubusercontent.com/37819666/156787539-2ca39083-00ca-43f6-8662-b66cc2544100.png)

![6](https://user-images.githubusercontent.com/37819666/156787537-abf9c544-2349-4d64-a7ee-b7cc7c334774.png)

`MVC` 패턴은 `Model, View, Controller` 로 구성되며 각각 다음 역할을 담당합니다.

- Model : 데이터를 관리합니다.
- View : 모델을 UI 상으로 보여줍니다.
- Controller : View 와 Model 사이에 중간 다리 역할을 합니다.

시스템이 커질수록 각 기능간의 결합도가 높아질 수 있습니다.

높은 결합도는 코드 수정시 `side effect` 를 발생시킬 수 있기 때문에 유지보수에 불리해집니다.

`MVC` 는 이러한 문제를 해결하기 위해 등장했으며 UI 시스템을 역할별로 분리하여

기능간의 결합도를 낮췄습니다.

### MVC 패턴의 한계

하지만 이러한 `MVC` 패턴에도 한계점은 존재합니다.

애플리케이션의 규모가 커질수록 다수의 `view` 와 `model` 이 서로 연결되기 때문에

`controller` 가 비대해지는 문제가 생깁니다.

이를 흔히 `massive-view-controller` 라고 하며 다음과 같은 형태를 띕니다.

다수의 `model` 이 서로 의존성이 있는 다른 `model` 을 업데이트하는 등

애플리케이션 내부 구조가 복잡해기기 때문에 예측 불가능한 상태가 됩니다.

![7](https://user-images.githubusercontent.com/37819666/156787530-15371dc2-809c-4438-93be-84eb93b8a197.png)

또한 위에서 볼 수 있듯이 `MVC` 패턴은 한쪽의 데이터 변경이 또 다른쪽에 영향을 줄 수 있어

`양방향 데이터 흐름` 의 가능성도 내포하고 있습니다.

### Flux 패턴의 등장

페이스북 개발팀은 `MVC` 가 대규모 서비스에서 확장성이 떨어진다고 판단한 뒤

`Flux` 패턴을 코드 베이스에 적용시키는 것이 좋겠다고 발표한 적이 있습니다.

이들은 `MVC` 패턴을 사용할 경우 다음과 같은 단점이 있다고 말했습니다.

```jsx
* 새로운 기능을 추가할 때 시스템의 복잡도가 기하급수적으로 증가한다.
* 깨지기 쉽고 예측이 불가능하다.
* 새로운 기능을 추가할 때 어떤 side effect 를 일으킬지 예측이 힘들다.
```

`좀 더 예측 가능한 형태로 코드를 구조화하기 위해` 페이스북 개발팀은 `FLUX` 패턴을 적용했고

이는 아주 성공적이었다고 합니다.

![8](https://user-images.githubusercontent.com/37819666/156787526-60ade43e-b558-4241-bc91-5515bbbb05d0.png)

- Store(s) : 데이터를 관리하는 곳이며 보통 각 비즈니스 도메인별로 `store` 를 생성합니다.
- Action : `action` 종류에 따라 데이터를 `dispatcher` 에게 전달합니다.
- Dispatcher : `action` 들의 종류에 따라 `store` 를 업데이트합니다.
- View & Controller-View : MVC 패턴의 `View` 와 동일하며 UI 상으로 데이터를 보여줍니다.

위 그림과 같이 `Dispatcher` 는 어떤 `Action` 이 발생했을 때

어떻게 `Store` 를 갱신할 지 결정합니다.

그리고 `Store` 가 갱신되면 이에 따라 `View` 도 갱신되는 구조이기 때문에

`단방향으로 데이터 흐름이 유지됨` 을 알 수 있습니다.

<aside>
💡 `Controller View` 는 무엇일까?

일반적인 `View` 와는 다르게 `Controller View` 는 `store` 의 데이터를 받아
하위 계층의 컴포넌트에게 `props` 로 전달해주는 역할을 합니다.
이것이 `MVC` 패턴의 `Controller` 와 유사하여 `Controller View` 라고 합니다.

</aside>

<aside>
💡 `Redux` 는 `Flux` 와 다르게 단일 store 로 구성됩니다

이는 특정 action 에서 처리해야하는 `store` 가 많아지면 업데이트가 필요한 부분을
추적하기가 힘들고 이로 인해 상태 관리 이슈를 불러올 수 있기 때문입니다.

</aside>

## 📌 Vuex 는 어떻게 구성되어있을까?

해외 포스트를 보니 `Vuex` 의 동작 방식을 모션으로 잘 만들어놓은 것이 있어서 가져왔습니다.

앞서 살펴본 `Flux` 패턴에서 영감을 받은 구조임이 명확히 보이죠?

![9](https://user-images.githubusercontent.com/37819666/156787497-50e4e6d7-138f-498c-9835-97be723493ae.gif)

### State

`Vuex` 는 `단일 상태 트리(single state tree)` 를 사용합니다.

애플리케이션에서 `store` 는 오직 하나의 객체이며 이를 통해 상태를 관리합니다.

각 상태에 대한 스냅샷을 추적하기 쉬워 디버깅에 용이합니다.

하나의 `store` 라고해서 모듈화가 불가능한 것은 아닙니다.

`Vuex` 는 하나의 `store` 를 여러개의 `submodule` 로 분리할 수 있는 방법을 제공합니다.

### Getter

가끔씩 저장된 `state` 값을 이용해서 로직을 수행한 결과값이 필요할 수 있습니다.

`getter` 는 이러한 경우를 위해 존재하며 종속된 `state` 가 변화할 때

필요한 연산을 수행해서 결과값을 반환해줍니다.

### Mutation

`store` 에 저장된 `state` 를 변경하기 위해서는 `mutation` 을 이용해야 합니다.

`mutation` 은 이벤트 키값과 이벤트 핸들러로 구성됩니다.

핸들러는 `store` 의 `state` 에 접근해서 업데이트를 수행합니다.

단, `mutation` 은 반드시 `동기적인 작업` 만 수행해야합니다.

그 이유는 다음과 같습니다.

```markdown
- 비동기 함수이기 때문에 `devtool` 이 `mutation` 수행 전후에 스냅샷으로 상태 변화를 추적하는 것이 불가능합니다.
- mutation 에 상태를 변경하는 비동기 코드가 포함되면 어떤 mutation 이 상태를 변화시켰는지 알 수 없습니다.
```

### Actions

`action` 은 `mutation` 과 유사하지만 `비동기작업` 이 포함될 수 있다는 차이점이 존재합니다.

상태를 직접 변화시키는 대신, `mutation` 을 이용해서 상태를 업데이트합니다.

## 📌 Vuex 사용 시 장점은?

### 데이터를 다루는 일정한 패턴 제공

우리의 `store` 가 중앙 집중식으로 데이터를 관리하고

이에 접근할 수 있는 일정한 인터페이스 (`actions, mutations, getters`) 들이 제공되는 것은

대규모 애플리케이션에서 데이터 흐름을 추적하는데 큰 도움이 됩니다.

데이터에 아무렇게나 접근이 가능하면 데이터가 수정되는 것을 추적하기가 힘들어집니다.

`vuex` 는 일정한 방식으로 데이터를 다루기에 이러한 문제점들이 해결됩니다.

### 데이터 동기화 문제 해결

앞서 말한 것처럼 데이터를 다루는 일정한 패턴을 제공하기 때문에

해당 데이터를 바라고보고있는 여러 개의 컴포넌트 간 동기화 문제를 해결할 수 있습니다.

### Time Travel 을 통한 편리한 디버깅

현업에서 `Vuex` 를 사용하면서 가장 편리하다고 느낀점이 바로 `time travel` 기능이었습니다.

데이터의 흐름을 추적할 수 있기 때문에 시간을 거꾸로 거슬러올라가

`Vuex` 에 저장되어있던 이전 상태값들을 추적할 수 있습니다.

이는 디버깅시 아주 유용하게 사용되며 값이 바인딩된 화면의 변화도 함께 확인하며

개발자가 올바르게 값을 다루고 있는지 확인하는데 큰 도움이 될 수 있습니다.

## 📌 주의할 점은 없을까?

그렇다면 `Vue` 애플리케이션에서 상태관리를 위해 `Vuex` 가 항상 정답일까요?

모든 기술에는 장단점이 있고 우리는 이를 잘 알고 선택하는 것이 중요합니다.

## 📌 참고 자료

[What is a Store in Vue.js? - Vue.js Tutorials](https://vueschool.io/articles/vuejs-tutorials/what-is-a-store-in-vue-js/)

[[VueMastery] Mastering Vuex - part 1](https://coursehunters.online/t/vuemastery-mastering-vuex-part-1/541)

[[Vue.js] Vuex란? Vuex의 컨셉과 구조](https://ict-nroo.tistory.com/106)

[페이스북의 결정: MVC는 확장에 용이하지 않다. 그렇다면 Flux다.](https://blog.coderifleman.com/2015/06/19/mvc-does-not-scale-use-flux-instead/)

[MVC(Model, View, Controller) Pattern](https://junhyunny.github.io/information/design-pattern/mvc-pattern/)

[MVC vs Flux vs Redux - The Real Differences](https://www.clariontech.com/blog/mvc-vs-flux-vs-redux-the-real-differences)

[[Vue.js] Vuex란? Vuex의 컨셉과 구조](https://ict-nroo.tistory.com/106)

[What is Vuex? | Vuex](https://vuex.vuejs.org/)

[In-Depth Overview | Flux](https://facebook.github.io/flux/docs/in-depth-overview)

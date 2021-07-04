# Lazy loading & Code Splitting in Vue.js

## Webpack bundling 이 동작하는 원리

![1](https://user-images.githubusercontent.com/37819666/124385263-e7509d00-dd0f-11eb-9d43-80c62d9c186f.png)

의존성 그래프 예시

`webpack` 은 `의존성 그래프` 라고 하는 것을 통해서 각 모듈을 관리합니다.

이는 파일 기반으로 우리가 `import` 한 것들의 의존성을 표현한 것입니다.

여기서 `root` 가 되는 진입점 파일은 우리가 엔트리 포인트로 지정한 최상위 파일이며

`Vue.js` 의 경우 `main.js` 가 되는 것입니다.

![2](https://user-images.githubusercontent.com/37819666/124385266-e91a6080-dd0f-11eb-87fc-bcf7fe9aff81.png)

`webpack` 은 최종 결과물이 될 번들 파일에 어떤 모듈들이 필요한지 파악하기 위해서

의존성 그래프를 활용합니다. 

그렇기 때문에 프로젝트의 규모가 커질수록 번들 사이즈 또한 커진다는 특징을 가지게 됩니다.

파일 사이즈의 증가는 다운로드 속도 저하와 파싱하는데 더 많은 시간을 필요로 하게 되고

이는 곧 앱 퍼포먼스 저하로 연결됩니다.

구글에 따르면 페이지 로딩에 3초 이상 걸릴 경우 53%의 사용자가 이탈한다고 합니다. 😱

## Lazy loading

![3](https://user-images.githubusercontent.com/37819666/124385267-eae42400-dd0f-11eb-949c-cfbe69e617f1.png)

위 문제를 해결할 수 있는 하나의 방법은 `lazy loading` 입니다.

`lazy loading` 은 말 그대로 앱의 `chunk` 를 필요해질때 나중에 불러오는 것을 말합니다.

이를 위해서는 chunk 를 분리하는 작업이 필요한데, 이때 `code splitting` 이 활용됩니다.

이 방법이 효과적인 이유는 대부분의 경우 서비스 방문 시 모든 모듈이 필요하지는 않기 때문입니다.

사용자가 보고 있는 화면을 위해 일부의 모듈만 필요한 상황에서 모든 모듈을 불러오고

파싱한 뒤 렌더링 하는 것은 불필요합니다.

### 개발자 도구로 사용되지 않는 JS 코드 분석하기

<img width="844" alt="4" src="https://user-images.githubusercontent.com/37819666/124385268-ecade780-dd0f-11eb-84f6-07ff5803baba.png">

개발자 도구의 `source` 탭에서 `coverage` 를 선택한 뒤 `record` 를 이용하면

현재 각 소스들에서 사용되지 않는 `JS` 코드를 확인할 수 있습니다.

## Dynamic import

`webpack` 에서 제공하는 `dynamic import` 기능을 사용하면 

동적으로 필요한 모듈을 불러올 수 있습니다.

```jsx
// main.js
const getCat = () => import('./cat.js')

// later in the code as a response to some user interaction like click or route change
getCat()
  .then({ meow } => meow())
```

`webpack` 은 동적으로 import 된 모듈을 별도의 파일로 분리하여 번들링합니다.

때문에 `cat.js` 가 별도의 `chunk` 로 빠지게 되고 

해당 모듈을 불러오는 함수는 `promise` 를 반환하는 형태를 가지게 됩니다.

덕분에 우선 의존성 그래프에서 제외 되었다가 필요할 때 추가될 수 있는 것입니다.

### Vue.js 에서 Dynamic import 사용하기

```jsx
<template>
  <div> 
    <lazy-component />
  </div>
</template>

<script>
const lazyComponent = () => import('Component.vue')
export default {
  components: { lazyComponent }
}

// Another syntax
export default {
  components: {
    lazyComponent: () => import('Component.vue')
  }
}
</script>
```

앞선 예시와 동일한 방법으로 구현할 수 있습니다.

여기서 주의할 점은 `lazy-component` 가 DOM 구조 상으로 필요해질 때 

`dynamic import` 된다는 것입니다.

따라서 만약 다음과 같이 DOM 구조 상으로 제거한다면,

```jsx
<lazy-component v-if="false" />
```

해당 컴포넌트는 DOM 구조 상에서 제거되기 때문에 `v-if` 가 `true` 로 변경되기 전까지는

`dynamic import` 가 실행되지 않습니다.

## 참고 자료

[Lazy loading and code splitting in Vue.js - Vue.js Tutorials](https://vueschool.io/articles/vuejs-tutorials/lazy-loading-and-code-splitting-in-vue-js/)
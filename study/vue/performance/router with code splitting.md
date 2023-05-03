# Vue.js 라우터 성능

## 거대한 애플리케이션에서 발생 가능한 문제

앱이 커질 수록 더욱 많은 컴포넌트를 필요로 하기 때문에 `로딩 시간` 에 대한 문제가 생길 수 있습니다.

간단한 애플리케이션에서는 다음과 같이 라우팅을 설정합니다.

```tsx
// router.js
import Home from './Home.vue'
import About from './About.vue'

const routes = [
  { path: '/', component: Home }
  { path: '/about', component: About }
]
```

실제 배포되는 애플리케이션에서는 `로딩 시간` 을 줄이기 위해 

꼭 필요한 파일만 필요할 때 불러오도록 하는 것이 좋습니다.

저자의 말에 따르면 `1초` 를 넘어갈 경우 사용자는 접근을 꺼려한다고 합니다 

## 코드 스플리팅과 Vue 라우팅

웹팩에서 제공해주는 `dynamic import` 를 이용하면 위 문제점을 최적화 가능합니다.

```tsx
// router.js 
const routes = [
  { path: '/', component: () => import('./Home.vue') }
  { path: '/about', component: () => import('./About.vue') }
]
```

이 경우 하나의 파일로 빌드되던 결과물이 다음과 같이 3가지의 파일로 분리됩니다.

`app.js` 는 메인 번들이고 라이브러리 파일을 포함합니다.

`home.js` 와 `about.js` 는 각각 `/` 와 `/about` 로 라우팅에 필요한 컴포넌트를 포함합니다.

![1](https://user-images.githubusercontent.com/37819666/137752760-bf91c6f9-31dc-4e11-96c2-a9a40fe0ca24.png)

## 안티 패턴 주의하기

라우터 기반의 코드 스플리팅을 할 때 주의할 점이 한가지 있습니다.

![2](https://user-images.githubusercontent.com/37819666/137752774-0367aaea-595c-4fe2-8a70-16ede94667db.png)

위와 같이 서드 파티 라이브러리를 `vendor.js` 라는 번들 파일에 하나로 빌드할 경우

`lodash` 는 `About.vue` 에 접근할 때만 사용되지만 

해당 페이지에 접근하기 전에 먼저 로드를 해와야하는 문제가 생깁니다.

이를 해결하기 위해서는 모든 의존성을 하나의 파일에 몰아 넣는 것이 아니라 각각의 라우터에서

필요한 의존성만 바라볼 수 있도록 번들링하는 것이 필요합니다.

이는 웹팩에서 제공하는 `splitChunkPlugin` 을 통해서 해결 가능합니다.

```tsx
// webpack.config.js
optimization: {
  splitChunks: {
    chunks: 'all'
  }
}
```

사용 가능한 옵션에는 `all, async, initial` 이 존재하고 각 옵션에 따라 번들링하는 기준이 달라집니다.

해당 플러그인에 대한 자세한 설명은 다음 블로그에 잘 나와있습니다.

[https://medium.com/dailyjs/webpack-4-splitchunks-plugin-d9fbbe091fd0](https://medium.com/dailyjs/webpack-4-splitchunks-plugin-d9fbbe091fd0)

## 참고 자료

[https://vueschool.io/articles/vuejs-tutorials/vue-js-router-performance/](https://vueschool.io/articles/vuejs-tutorials/vue-js-router-performance/)
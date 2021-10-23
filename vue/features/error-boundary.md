# Vue 에서 Error Boundary로 에러 처리하기

## Error Boundary 란?

이전에 잠깐 `React` 공부할 때 공식 문서에 `Error Boundary` 라는 기법이 소개되어 있었습니다.

`Error Boundary` 는 컴포넌트에서 발생한 에러를 다루는 하나의 방법으로 

에러를 처리하는 컴포넌트(`Error Boundary`)를 만들어 앱의 실행에 문제가 생기지 않도록 하는 것입니다.

`Vue` 에도 해당 기법이 있을까 궁금해서 찾아봤었는데 이를 소개하는 글이 있어서 정리해봤습니다.

## Vue 에서 Error Boundary 사용하기

Vue 2.5 버전에서는 `errorCaputred` 라는 훅을 지원하기 시작했습니다.

해당 훅에서는 자식 컴포넌트에서 발생한 에러를 감지해 처리할 수 있습니다.

`Error Boundary` 를 구현하는 방법은 다음과 같습니다.

먼저 `errorCaptured` 훅을 사용해 `Error Boundary` 컴포넌트를 정의합니다.

```tsx
// ErrorBoundary.vue

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'

@Component({
  name: 'ErrorBoundary',
})
export default class ErrorBoundary extends Vue {
  private hasError = false;

  public errorCaptured () {
    this.hasError = true
  }

  public render(h: any) {
    return this.hasError ? h('li', 'something wrong') : this.$slots.default[0];
  }
}
</script>
```

그리고 일부로 에러를 발생시키도록 렌더링하는 예제를 생성합니다.

```tsx
// CarListItem.vue

<template>
  <li>
    이름: {{ carInfo.name }}
    가격 : {{ numberWithCommas(carInfo.price) }}
  </li>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator'

@Component({
  name: 'CarListItem'
})
export default class CarListItem extends Vue {
  @Prop({ required: true }) readonly carInfo!: { id: number; name: string; price: number; }

  public numberWithCommas(x: number) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
}
</script>
```

```tsx
// CarList.vue

<template>
  <ul>
    <template v-for="carInfo in carInfos">
      <error-boundary :key="carInfo.id">
        <car-list-item :carInfo="carInfo"  />
      </error-boundary>
    </template>
  </ul>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'

import CarListItem from './CarListItem.vue'
import ErrorBoundary from './ErrorBoundary.vue'

@Component({
  name: 'CarList',
  components: { CarListItem, ErrorBoundary }
})
export default class CarList extends Vue {
  private carInfos = [
    { id: 1, name: 'a', price: null },
    { id: 2, name: 'b', price: 1232321 },
    { id: 3, name: 'c', price: 123212323 },
  ]
}
</script>
```

예제에서 `null` 에 대해서 정규식을 수행할 수 없기 때문에 에러가 발생하고,

`ErrorBoundary` 덕분에 UI Fallback 을 지정할 수 있게 됩니다.

화면에는 다음과 같이 나오게 됩니다.

<img width="242" alt="1" src="https://user-images.githubusercontent.com/37819666/138560131-d337c71e-39e4-473d-81b6-e021a5dd0a8c.png">


## Vue 에서 에러 발생 규칙

Vue 에는 전역 `config.errorHandler` 가 존재하여 발생한 모든 에러는 해당 핸들러로 처리 가능합니다.

이를 통해 한 곳에서 에러에 대한 처리와 통계등을 수행할 수 있게됩니다.

만약 `errorCaptured` 훅이 존재한다면 모든 `errorCaptured` 훅이 호출되며 

최종적으로 `config.errorHandler` 에 도달합니다.

만약 `errorCaptured` 에서 `false` 를 반환한다면 에러가 전달되는 것을 막을 수 있습니다.

## 유의 사항

### DOM 이벤트 핸들러

`Dom` 에 직접 `v-on` 으로 이벤트 핸들러를 할당한 뒤 해당 핸들러에서 발생한 에러는

`Error Boundary` 에서 감지하지 못하는 문제가 있습니다.

해당 이슈에 대해서 제안된 사항이 이미 Github 에 존재하는데..

[feat(errors): sync/async error handling for lifecycle hooks and v-on handlers (#7653, #6953) by enkot · Pull Request #8395 · vuejs/vue](https://github.com/vuejs/vue/pull/8395)

Vue 의 주요 개발자 `Evan You` 는 다음과 같이 네 가지 경우에 대해서 `errorCaputred` 를 통해

처리할 수 있다고 언급했습니다.

- render functions
- watcher callbacks
- lifecycle hooks
- component event handlers

`PR` 도 처리되었고 해서 테스트 해봤더니 `Dom` 에 할당된 이벤트 핸들러 에러는 `errorCaptured` 에서

처리를 못하는 것으로 보입니다. (이 부분은 추가적인 확인이 필요해보임)

### 함수형 컴포넌트 사용 시

Vue 에서도 함수형 컴포넌트라는 기능을 제공합니다.

함수형 컴포넌트는 `eager-render` 되기 때문에 같은 `template` 스코프에 있는 다른 컴포넌트의

`errorCaptured` 에서 에러를 받아 처리할 수 없습니다.

이는 Vue 의 함수형 컴포넌트의 설계 방식에 따른 결과로 

Vue 의 함수형 컴포넌트 설계 구조가 변경되지 않는 이상 변하지 않을 것으로 보입니다.

## 참고 자료

[Handling Errors in Vue with Error Boundaries](https://medium.com/@dillonchanis/handling-errors-in-vue-with-error-boundaries-91f6ead0093b)

[API - Vue.js](https://vuejs.org/v2/api/#errorCaptured)
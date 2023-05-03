# Lazy Loading & Prefetching with Vue Component

## 어떤 컴포넌트를 지연되어서 가져와야 할까?

바로 `초기 렌더링에 필요하지 않은 것들` 을 지연되어 가져온다면

성능 향상을 기대할 수 있습니다.

대표적으로 `v-if` 로 분기 처리되어 있는 컴포넌트들 일 수 있습니다.

`Vue` 에서는 다음과 같이 두 가지 방법으로 컴포넌트를 동적으로 렌더링 할 수 있습니다.

```jsx
<modal v-if="showModal" />
<modal v-show="showModal" />
```

여기서 `v-show` 의 경우 `display: none` 을 통해서 DOM 요소를 렌더 트리에서

제거하는 것이기 때문에 실제 컴포넌트는 항상 불러오게 됩니다.

따라서 동적으로 불러올 컴포넌트는 `v-if` 를 사용하는 것에 유의합니다. 😀

### 지연된 컴포넌트 사용 방법

```jsx
<template>
  <div>
    <button @click="isModalVisible = true">Open modal</button>
    <modal-window v-if="isModalVisible" />
  </div>
</template>

<script>
export default {
  data () {
    return {
      isModalVisible: false
    }
  },
  components: {
    ModalWindow: () => import('./ModalWindow.vue')
  }
}
</script>
```

## Lazy Loading 의 한계점과 Prefetching 의 필요성

### Lazy Loading 이 사용자 경험에 미치는 영향

그런데 생각해보면 `Lazy Loading` 으로 초기 로딩에 필요하지 않은 컴포넌트를

이후에 불러온다고 하더라도 결국 요청된 순간에 빠른 응답속도로 렌더링 하지 않으면

사용자는 해당 앱이 느리거나 문제가 있다고 생각할 수 있습니다.

`RAIL` 모델에 따르면 사용자 입력에 최대 `100ms` 안에 응답을 줘야 문제가 없다고

느낀다고 합니다.

따라서 단순히 `Lazy Loading` 만 가지고는 해당 문제를 해결할 수 없는 것입니다.

### Prefetching 의 필요성

이러한 문제를 해결하기 위해서 `Prefetching` 을 함께 사용하게 됩니다. 😄

`Prefetching` 은 말 그대로 나중에 필요해질 것들을 미리 불러오는 것을 말합니다.

이를 통해 초기 로딩 속도에 영향을 주지 않고 UX 를 개선할 수 있습니다.

다음과 같이 `magic comments` 라는 webpack 의 기능을 사용하면 

원하는 컴포넌트에 `prefetch` 를 적용할 수 있습니다.

```jsx
components: {
  ModalWindow: () => import(/* webpackPrefetch: true */ './ModalWindow.vue')
}
```

이 경우 위 컴포넌트를 불러오는 `link` 태그가 `head` 태그 내부에 다음과 같이 삽입됩니다.

```jsx
<link rel="prefetch" href="path-to-chunk-with-modal-window" />
```

Vue CLI 3 이후의 버전을 사용할 경우 위와 같이 별도로 지정해줄 필요 없이 

`lazy loading` 처리가 된 컴포넌트들은 자동적으로 `prefetching` 이 적용됩니다. 😄

다만 빌드 설정에 따라 `production mode` 에서만 적용이 될 수도 있는 것에 유의합니다.

## Vue 의 비동기 컴포넌트

`Vue` 에서는 `비동기 컴포넌트` 라고 하는 아주 유용한 컴포넌트 구현 방법이 있습니다.

해당 컴포넌트는 다음과 같이 세 가지 요소로 구성됩니다.

- `dynamic component` : `lazy loading` 할 컴포넌트
- `loading component` : `dynamic component` 가 로드되기 전 보여줄 컴포넌트
- `error component` : 로딩에 실패할 경우 보여줄 컴포넌트

```jsx
const ModalWindow = () => ({
  component: import('./ModalWindow.vue'),
  loading: LoadingComponent,
  error: ErrorComponent,
  // The error component will be displayed if a timeout is
  // provided and exceeded. Default: Infinity.
  timeout: 3000
})

export default {
  components: {
    ModalWindow
  }
}
```

## 참고 자료

[Learn how to lazy load and prefetch components in Vue.js](https://vueschool.io/articles/vuejs-tutorials/lazy-loading-individual-vue-components-and-prefetching/)
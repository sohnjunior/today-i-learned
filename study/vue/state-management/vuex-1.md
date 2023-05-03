# [Vue 상태관리 1편] Vue.Observable 을 통한 상태관리

## 📌 Vue.Observable?

`Vue 2.6` 버전부터 데이터를 반응형으로 만들어 사용할 수 있는 방법이 생겼습니다.

이번 포스트에서는 이를 활용한 간단한 상태관리 방법에 대해서 살펴보겠습니다.

## 📌 Store 패턴 사용해보기

간단한 `counter` 앱을 통해서 `Vue.observable` 을 어떻게 사용할 수 있는지 살펴보겠습니다.

먼저 프로젝트를 생성하고 다음과 같이 `count` 값을 가지고 있는 컴포넌트를 생성합니다.

버튼을 클릭하면 `count` 가 1씩 증가하는 예제입니다.

```jsx
<template>
  <div>
    {{ count }}
    <button @click="onClick">클릭</button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      count: 0,
    }
  },

  methods: {
    onClick() {
      this.count += 1
    },
  },
}
</script>
```

현재 컴포넌트 상태값으로 관리하고 있는 `count` 값을 전역에서 관리하도록 변경하겠습니다.

먼저 `store` 디렉토리를 생성하고 `index.js` 파일에 다음과 같이 코드를 작성합니다.

```jsx
import Vue from "vue"

export const mapState = (state, properties = []) => {
  const computed = {}
  properties.forEach((prop) => (computed[prop] = () => state[prop]))
  return computed
}

export const state = Vue.observable({
  count: 0,
})

export const mutations = {
  increaseCount() {
    state.count += 1
  },
}
```

`mapState` 는 `store` 에 정의되어있는 상태값을 사용하는 컴포넌트의

`computed` 속성에 값을 반환하는 함수를 매핑해주는 헬퍼 함수입니다.

이는 `store` 의 `state` 에 대한 직접적인 접근 및 수정을 피하기 위한 방법입니다.

`state` 는 `Vue.observable` 을 통해 반환된 반응형 객체이며

이를 조작하는 `mutations` 도 함께 정의했습니다.

(같은 방법으로 `actions` 나 `getters` 도 정의 가능합니다 😄.)

이제 기존의 컴포넌트를 다음과 같이 수정합니다.

`count` 를 전역 상태로 옮겼을 뿐, 동일하게 동작하는 것을 확인할 수 있습니다.

```jsx
<template>
  <div>
    {{ count }}
    <button @click="onClick">클릭</button>
  </div>
</template>

<script>
import { state, mapState, mutations, } from "../store"

export default {
  computed: {
    ...mapState(state, ["count"]),
  },

  methods: {
    onClick() {
      mutations.increaseCount()
    },
  },
}
</script>
```

## 📌 언제 사용하는 것이 좋을까?

그렇다면 어떤 경우에 `Vue.observable` 를 사용해서 상태관리를 하는 것이 좋을까요?

규모가 크거나 확장될 것 같은 애플리케이션에서는 `Vuex` 나 `Pinia` 와 같은 상태관리 라이브러리를

사용하는 것이 좋습니다. 이들은 대규모 애플리케이션에 적합한 모듈화와 여러 기능들을 제공하기 때문입니다.

그렇지만 작은 규모의 애플리케이션에서는 굳이 `Vuex` 와 같은 방법을 이용해서 상태관리를 할 필요는 없습니다.

이는 boilerplate 코드로 인해 오히려 애플리케이션의 코드 복잡도를 높을 수 있기 때문입니다.

때문에 데이터의 흐름이 간단하거나, 규모가 작은 애플리케이션에서는

`Vue.observable` 로도 충분히 상태관리가 가능할 것이라고 생각합니다.

## 📌 참고 자료

[Home Rolled Store with Vue.observable (Vue 2) - Vue.js Tutorials](https://vueschool.io/articles/vuejs-tutorials/home-rolled-store-with-vue-observable-vue-2/)

[Deep dive into Vue state management - Vue.js Tutorials](https://vueschool.io/articles/vuejs-tutorials/deep-dive-into-vue-state-management/)

[API - Vue.js](https://kr.vuejs.org/v2/api/#Vue-observable)

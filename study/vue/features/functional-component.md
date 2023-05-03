# Vue 함수형 컴포넌트에 대해서

## 함수형 컴포넌트란?

`함수형 컴포넌트` 는 상태와 인스턴스가 존재하지 않는 컴포넌트를 말합니다.

컴포넌트가 상태가 없고 인스턴스화 되지 않기 때문에 `this 컨텍스트` 가 없습니다.

상태가 없기 때문에 초기 렌더링과 업데이트 시 성능 이점을 볼 수 있다는 특징이 있습니다.

## 함수형 컴포넌트 사용하기

이후에 사용되는 예제는 Vue 2.x 를 기준으로 작성되었음에 유의 바랍니다.

Vue 3 부터는 `functional: true` 속성대신 일반 함수로 함수형 컴포넌트를 구현할 수 있습니다.

### template 에 functional 속성 지정하기

`SFC(single file component)` 를 사용하는 경우 다음과 같이 `template` 옵션을 사용하면 됩니다.

```tsx
<template functional>
  <div>함수형 컴포넌트</div>
</template>

<script lang="ts">
import { Component, Vue, } from 'vue-property-decorator'

@Component({
  name: 'Functional'
})
export default class Functional extends Vue {}
</script>
```

`@Component` 데코레이터에 `functional: true` 옵션을 지정할 수 없나 찾아봤는데..

`vue-class-component` 레포에 해당 이슈가 등록되어있었습니다.

[How to create functional component in @Component? · Issue #120 · vuejs/vue-class-component](https://github.com/vuejs/vue-class-component/issues/120)

개발자 의견에 따르면 함수형 컴포넌트는 결국 인스턴스화되지 않기 때문에 클래스로 구현할 필요가 없고,

때문에 `@Component` 데코레이터를 통해 클래스로 컴포넌트를 만드는 것은 좋은 방법이 아니라고 합니다.

대신 다음과 같이 `Vue.extend` 를 사용하는 방법을 권고하고 있습니다.

### Vue.extend 와 render 함수를 이용해서 구현하기

`render` 함수는 `context` 라는 인자를 받는데, 이를 통해 컴포넌트의 여러 속성에 접근 가능합니다.

```tsx
<script lang="ts">
import { Vue, } from 'vue-property-decorator'

export default Vue.extend({
  functional: true,
  render: function(createElement, context) {
    return createElement('div', '함수형 컴포넌트')
  }
})
</script>
```

`context` 를 통해 접근 가능한 컴포넌트 속성들은 다음과 같습니다.

- props: 전달받은 props 객체
- children: 자식 VNode 배열
- slots: 슬롯 객체를 반환하는 함수
- scopedSlots: 범위가 지정된 슬롯을 렌더링하는 함수를 가진 객체입니다.
- data: 컴포넌트에 전달된 데이터 객체
- parent: 부모 컴포넌트에 대한 참조
- listeners: 부모에게 등록된 이벤트 리스너를 가진 객체
- injections: `inject` 옵션을 가진 경우 주입된 데이터를 가지고 있음

### 함수형 컴포넌트에 이벤트 리스너 할당하기

```tsx
// 부모 컴포넌트

<template>
  <functional-component @click="onClick" />
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'

import FunctionalComponent from '../components/Functional.vue'

@Component({
  name: 'Index',
  components: { FunctionalComponent }
})
export default class Index extends Vue {
  public onClick() {
    console.log('클릭됨')
  }
}
</script>
```

```tsx
// 자식 컴포넌트

<script lang="ts">
import { Vue, } from 'vue-property-decorator'

export default Vue.extend({
  functional: true,
  render: function(createElement, context) {
    return createElement('div', {
      on: {
        click: context.listeners.click
      }
    }, '함수형 컴포넌트')
  }
})
</script>
```

## 함수형 컴포넌트를 사용했을 때 장점은?

### 렌더링 속도가 빠르다.

함수형 컴포넌트는 상태가 없기 때문에 Vue 의 반응형 시스템을 위한 초기화 작업이 필요없습니다.

때문에 렌더링 속도에서 차이가 나는데, 이를 벤치마킹한 결과는 해외 한 블로거가 정리해놨습니다.

[https://codesandbox.io/s/vue-template-yterr?fontsize=14](https://codesandbox.io/s/vue-template-yterr?fontsize=14)

결과를 살펴보면 1000개의 리스트 목록을 렌더링 할 때, 함수형 컴포넌트로 구현할 경우 `40ms` 가 소요되며

상태가 존재하는 일반적인 컴포넌트로 구현하면 `140ms` 가 소요된다고 합니다.

때문에 상태가 필요하지 않은 `presentational component` 를 렌더링 할 때 사용하면 좋습니다.

## Vue 의 함수형 컴포넌트는 완전하지 않습니다.

### 속성 병합이 제대로 되지 않습니다.

Vue 에서는 다음과 같이 상위 컴포넌트에서 자식 컴포넌트에게 속성을 전달할 수 있습니다.

대부분의 속성의 경우 자식 컴포넌트에게 전달된 속성값으로 대체되는데 `class` 와 `style` 의 경우

병합이 이루어집니다.

따라서 만약 다음과 같이 컴포넌트를 정의한다면 자식 컴포넌트는 `fancy awesome` 모두를 가져야 합니다.

```tsx
// 부모 컴포넌트에서 자식 컴포넌트의 class 속성으로 fancy 지정

<template>
  <div>
    <functional-component class="fancy" @click="onClick" />
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'

import FunctionalComponent from '../components/Functional.vue'

@Component({
  name: 'Index',
  components: { FunctionalComponent }
})
export default class Index extends Vue {
  public onClick() {
    console.log('클릭됨')
  }
}
</script>

<style lang="scss">
.fancy {
  color: red;
}
</style>
```

```tsx
// 자식 컴포넌트(함수형 컴포넌트) 에서 class 속성으로 awesome 지정

<script lang="ts">
import { Vue, } from 'vue-property-decorator'

export default Vue.extend({
  functional: true,
  render: function(createElement, context) {
    return createElement('div', {
      on: {
        click: context.listeners.click
      },
      class: {
        awesome: true,
      },
    }, '함수형 컴포넌트')
  }
})
</script>

<style lang="scss">
.awesome {
  font-size: 5rem;
}
</style>
```

그런데 실행해보면 자식 컴포넌트는 `awesome` 하나만 가지고 있는 것을 확인할 수 있는데,

이는 다음과 같이 `staticClass` 를 직접 바인딩을 해줌으로써 해결 가능합니다.

```tsx
<script lang="ts">
import { Vue, } from 'vue-property-decorator'

export default Vue.extend({
  functional: true,
  render: function(createElement, context) {
    return createElement('div', {
      on: {
        click: context.listeners.click
      },
      class: {
        awesome: true,
        ...(context.data.staticClass && { [context.data.staticClass]: true })
      },
      attrs: {
        ...context.data.attrs
      }
    }, '함수형 컴포넌트')
  }
})
</script>
```

[How to apply classes to Vue.js Functional Component from parent component?](https://stackoverflow.com/questions/50355045/how-to-apply-classes-to-vue-js-functional-component-from-parent-component)

### 함수형 컴포넌트를 중첩된 컴포넌트로 사용시 문제가 발생합니다.

위 문제에 이어서 만약 위 코드에서 부모 컴포넌트의 스타일이 `scoped` 라면 부모에서 지정한

`scoped css` 가 적용이 안되는 이슈가 있습니다.

현재 이 이슈는 해결이 안된 것으로 보이는데... Vue 3 에서는 해결이 되었는지 확인이 필요해보입니다.

실제 함수형 컴포넌트 사용을 고려할 때 스타일이 필요하다면 큰 이슈로 작용될 것이라 생각됩니다.

[Scoped styles inconsistent between functional and stateful components · Issue #1136 · vuejs/vue-loader](https://github.com/vuejs/vue-loader/issues/1136)

[Nested functional components break SFC CSS scoping · Issue #1259 · vuejs/vue-loader](https://github.com/vuejs/vue-loader/issues/1259)

### 함수형 컴포넌트 내부에서 자식 컴포넌트를 렌더링할 때 문제가 생깁니다.

다음과 같이 `template` 속성을 사용해서 함수형 컴포넌트를 구성한 뒤 

자식 컴포넌트를 `import` 해서 렌더링하려고 하면 문제가 생긴다고 합니다.

```tsx
<template functional>
  <div>
    <some-children />
  </div>
</template>

<script>
import SomeChildren from "./SomeChildren"

export default {
  components: {
    SomeChildren
  }
}
</script>
```


이를 우회하는 방법으로 다음과 같이 컴포넌트를 주입해주는 방법을 사용하라고 제안하고 있습니다.

```tsx
<template functional>
  <div>
    <component :is="injections.components.SomeChildren"></component>
  </div>
</template>

<script>
import SomeChildren from "./SomeChildren.vue";
export default {
  inject: {
    components: {
      default: {
        SomeChildren
      }
    }
  }
};
</script>
```

그런데 직접 해본 결과, 그냥 `render` 함수를 통해 함수형 컴포넌트를 구현하면 

문제없이 자식 컴포넌트가 렌더링 되는 것을 확인했습니다.

그냥 맘 편하게 함수형 컴포넌트는 일반 함수를 통해 구현하는 것이 정신 건강에 좋을 것 같습니다. 😅

```tsx
<script lang="ts">
import { Vue, } from 'vue-property-decorator'
import Finance from './Finance.vue'

export default Vue.extend({
  functional: true,
  render: function(createElement, context) {
    return createElement('div', {
      on: {
        click: context.listeners.click
      },
      class: {
        awesome: true,
        ...(context.data.staticClass && { [context.data.staticClass]: true })
      },
      attrs: {
        ...context.data.attrs
      }
    },
    [createElement(Finance)]
    )
  }
})
</script>
```

[Functional single file component with components option. · Issue #7492 · vuejs/vue](https://github.com/vuejs/vue/issues/7492)

## 참고 자료

[함수형 컴포넌트(Functional Components) | Vue.js](https://v3.ko.vuejs.org/guide/migration/functional-components.html#%E1%84%92%E1%85%A1%E1%86%B7%E1%84%89%E1%85%AE%E1%84%85%E1%85%A9-%E1%84%86%E1%85%A1%E1%86%AB%E1%84%83%E1%85%B3%E1%86%AB-%E1%84%8F%E1%85%A5%E1%86%B7%E1%84%91%E1%85%A9%E1%84%82%E1%85%A5%E1%86%AB%E1%84%90%E1%85%B3)

[Vue.js functional components: what, why, and when?](https://medium.com/js-dojo/vue-js-functional-components-what-why-and-when-439cfaa08713)

[Render Functions & JSX - Vue.js](https://kr.vuejs.org/v2/guide/render-function.html#%ED%95%A8%EC%88%98%ED%98%95-%EC%BB%B4%ED%8F%AC%EB%84%8C%ED%8A%B8)

[Vue.js functional components: What, Why, and When?](https://austingil.com/vue-js-functional-components-what-why-and-when/)

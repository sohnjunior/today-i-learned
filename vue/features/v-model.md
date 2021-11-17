# Vue 의 v-model 에 대해서

## v-model 이란?

`v-model` 은 `Vue` 에서 양방향 바인딩을 사용할 수 있는 디렉티브입니다.

기본적으로 `form` 요소들에 사용할 수 있으며 이를 통해 현재 입력된 `form` 요소 값을 

동기적으로 손쉽게 다룰 수 있도록 해줍니다.

## v-model 의 사용 예시

```tsx
<template>
  <div>
    <input type="text" v-model="name" />
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'

@Component({
  name: 'Index',
})
export default class Index extends Vue {
  private name = ''
}
</script>
```

## v-model 과 함께 사용할 수 있는 수식어

`v-model` 과 함께 사용할 수 있는 수식어(`modifier`) 가 3가지 존재합니다.

각각의 수식어에 대해서 간단한 예시와 함께 살펴보도록 하겠습니다.

### .lazy

```tsx
<template>
  <div>
    <input type="text" v-model.lazy="firstName">
    <input type="text" v-model="lastName">
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'

@Component({
  name: 'Index',
})
export default class Index extends Vue {
  private firstName = ''
  private lastName = ''
}
</script>
```

`.lazy` 수식어를 사용할 경우 `change` 이벤트가 발생할 때 값의 동기화가 이루어지도록 변경할 수 있습니다.

위 예제의 경우 첫번째 `input` 요소에서 `focus out` 될 경우에 값이 동기화되는 것을 확인할 수 있습니다.

### .number

```tsx
<template>
  <div>
    <input type="number" v-model.number="price" />
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'

@Component({
  name: 'Index',
})
export default class Index extends Vue {
  private price = 0
}
</script>
```

`input` 요소에 `type=number` 를 사용하더라도 바인딩된 값은 문자열 타입으로 변환됩니다.

`.number` 수식어를 사용하면 바인딩된 값을 숫자형으로 변환하여 동기화합니다.

때문에 숫자형 값을 입력 받아야 할 때 별도로 형변환 코드를 추가해주지 않아도 된다는 장점이 있습니다.

만약 유효하지 않은 숫자값이 입력되면 빈문자열이 할당됩니다.

### .trim

```tsx
<input v-model.trim="message" />
```

`.trim` 수식어를 사용하면 자동으로 `trim`(문자열 양 끝 공백 제거) 을 수행하여 값을 바인딩합니다.

## 컴포넌트에 v-model 사용하기

사용자가 정의한 컴포넌트에 `v-model` 을 사용하기 위해서는 

`v-model` 의 동작 방식에 대해서 살펴볼 필요가 있습니다.

`v-model` 은 기본적으로 `input` 이벤트와 `value` 속성값을 이용해서 구현됩니다.

따라서 다음과 같은 `v-model` 선언은 사실..

```tsx
<input v-model="message" />
```

다음과 동일한 코드입니다. 

```tsx
<input v-bind:value="message" v-on:input="value = $event.target.value">
```

따라서 컴포넌트에 `v-model` 을 사용하기 위해서는 값의 동기화에 사용될 `event` 와 

값을 동기화할 `value` 를 지정하면 됩니다.

`Vue` 에서는 이를 위해 `model` 속성을 제공하며 `vue-property-decorator` 를 사용할 경우

`@Model` 데코레이터를 사용하면 됩니다.

### @Model 데코레이터 사용 예시

`List` 컴포넌트를 생성하고 각각의 리스트 항목에 이벤트를 부여하여

현재 선택된 이벤트를 `v-model` 로 추적할 수 있도록 하는 간단한 예제입니다.

```tsx
// List.vue

<template>
  <ul>
    <li @click="onClick(0)">0</li>
    <li @click="onClick(1)">1</li>
    <li @click="onClick(2)">2</li>
  </ul>
</template>

<script lang="ts">
import { Component, Vue, Model, Emit } from 'vue-property-decorator'

@Component({
  name: 'List'
})
export default class List extends Vue {
  @Model('select', { type: Number }) readonly value!: number;

  @Emit('select')
  public onClick(idx: number) {
    return idx
  }
}
</script>
```

```tsx
// Index.vue

<template>
  <list v-model="selectedIndex" />
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'

import List from '../components/List.vue'

@Component({
  name: 'Index',
  components: { List }
})
export default class Index extends Vue {
  private selectedIndex = 0
}
</script>
```

## 참고 자료

[v-model의 동작 원리와 활용 방법](https://joshua1988.github.io/web-development/vuejs/v-model-usage/)

[Everything You Need to Know About Vue v-model](https://learnvue.co/2021/01/everything-you-need-to-know-about-vue-v-model/)

[Using v-model for Two-Way Binding in Vue.js | DigitalOcean](https://www.digitalocean.com/community/tutorials/vuejs-v-model-two-way-binding)

[컴포넌트 - Vue.js](https://kr.vuejs.org/v2/guide/components.html#%EC%BB%B4%ED%8F%AC%EB%84%8C%ED%8A%B8%EC%9D%98-v-model-%EC%82%AC%EC%9A%A9%EC%9E%90-%EC%A0%95%EC%9D%98)

[Vue.js Tutorial - Custom Components with v-model](https://sodocumentation.net/vue-js/topic/9353/custom-components-with-v-model)
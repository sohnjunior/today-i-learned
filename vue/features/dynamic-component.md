# Vue 동적 컴포넌트

이번에 사내에서 개발하는 앱의 화면 편집 기능을 추가하면서 

`동적 컴포넌트` 에 대해서 찾아보게 되었습니다.

편집 기능을 통해 상품 카드의 순서를 변경해야 하는데, 화면 리프레시가 발생하지 않고

DOM 의 순서를 조작해야하기 때문에 이를 위한 방법이 바로 `동적 컴포넌트` 였습니다.

## 동적 컴포넌트란?

`동적 컴포넌트` 는 말 그대로 렌더링되는 컴포넌트를 동적으로 변경 가능한 것을 의미합니다.

따라서 특정 조건에 따라 서로 다른 컴포넌트를 마운트 하는 것이 가능합니다.

```tsx
<template>
  <div>
    <component :is="currentComponent" />
    <button @click="onClick" >클릭</button>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'

import Car from '../components/Car.vue'
import Finance from '../components/Finance.vue'

@Component({
  name: 'Index',
  components: { Car, Finance }
})
export default class Index extends Vue {
  private isCar = false

  public get currentComponent() {
    return this.isCar ? Car : Finance
  }

  public onClick() {
    this.isCar = !this.isCar
  }
}
</script>

<style>

</style>
```

동작 예시를 위한 간단한 예제입니다.

`component` 의 `is` 속성에 렌더링하고자 하는 컴포넌트를 지정해서

동적으로 컴포넌트를 할당할 수 있습니다.
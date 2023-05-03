# Vue computed 속성 사용 시 주의할 점들

> 💡 본 포스트는 Vue.js 코어 팀 일원인 _Thorsten Lünborg_ 이 기고한 글에 근거합니다.

## computed 속성이란?

```jsx
export default {
  name: "HelloWorld",
  data() {
    return {
      todos: [
        { title: "wash dishes", done: true },
        { title: "remove trash", done: false },
      ],
    };
  },
  computed: {
    needTodos() {
      return this.todos.filter((todo) => !todo.done);
    },
  },
};
```

`Vue` 에서 `computed` 속성은 `data` 의 변화를 감지하여

동적으로 계산된 값을 이용할 때 사용합니다.

또한 `watch` 속성을 사용하면 `computed` 가 변화하는 것을 감지하여

특정 함수를 수행하도록 할 수도 있습니다.

## 📌 computed 속성의 성능상 이점은?

### 캐싱 (Caching)

`computed` 속성의 가장 큰 장점은 캐싱인데, 의존하는 값에 변화가 없다면

다시 계산하지 않고 이전 값을 반환합니다.

위 예제에서는 `todos` 가 변화하지 않는다면 아무리 `needTodos` 를 호출하더라도

이전에 계산되어 캐싱된 값을 반환합니다.

### 지연된 평가 (Lazy Evaluation)

`computed` 속성은 `lazy` 하게 값을 계산해서 반환합니다.

즉, `computed` 속성이 참조가 되었을 때 (초기 혹은 의존하고 있는 값이 변화한 경우) 콜백이 수행됩니다.

따라서 많은 데이터로 비용이 많이 드는 연산을 수행할 때 성능상 이점이 있습니다.

## 📌 지연된 평가의 성능향상 예시

```jsx
<template>
  <div>
    <button type="button" @click="showList = !showList">show todos</button>
    <template v-if="showList">
      <template v-if="hasOpenedTodos">
        <li v-for="(todo, idx) in needTodos" :key="idx">
          {{ todo.title }}
        </li>
      </template>
      <span v-else> nothing to show </span>
    </template>
  </div>
</template>

<script>
export default {
  name: "HelloWorld",
  data() {
    return {
      showList: false,
      todos: [
        { title: "wash dishes", done: true },
        { title: "remove trash", done: false },
      ],
    };
  },
  computed: {
    needTodos() {
      return this.todos.filter((todo) => !todo.done);
    },
    hasOpenedTodos() {
      return this.needTodos.length > 0;
    },
  },
};
</script>
```

위 예제에서 `showList` 가 `true` 가 되기 전까지 `needTodos` 는 참조되지 않기 때문에

의존하고 있는 `todos` 에 변화가 생기더라도 값을 계산하지 않습니다.

간단한 예제이지만 만약 `needTodos` 에서 비용이 큰 계산을 할 경우에는

지연된 평가로 인한 성능 향상을 기대할 수도 있습니다.

## 📌 지연된 평가가 성능저하를 불러오는 경우

반대로 지연된 평가로 인해 성능저하를 일으키는 경우도 있습니다.

`computed` 속성이 해당 값이 참조되었을 때 계산을 시작한다는 것은 사실

해당 값이 읽히지 않으면 그전까지 반응형 시스템이 이를 인지하지 못한다는 것과 같습니다.

그 때문에 의존하고 있는 값이 변화했을 때 실제로 `computed` 속성이 반환하는 값이

다른지는 콜백을 수행하기 전까지 모르는 것입니다.

### 이게 왜 문제가 될까요?

해당 `computed` 속성에 의존하고 있는 `watch()` 혹은 다른 `computed` 속성이 있는 경우 문제가 됩니다.

기준이 되는 computed 속성이 실제로 다른 값을 반환하지 않더라도

Vue 는 `혹시 모를 상황에 대비해` 연관된 다른 모든 속성들에 대해

업데이트가 필요하다는 표시(`dirty`)를 남겨놓습니다.

이 때문에 불필요한 재연산이 발생할 수도 있는 것입니다.

### 예시코드

```jsx
<template>
  <div>
    <button type="button" @click="increase">click me!</button>
    <ul>
      <li v-for="(item, idx) in someExpensiveLogic" :key="idx">
        {{ item }}
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: "HelloWorld",
  data() {
    return {
      count: 0,
    };
  },
  computed: {
    isOver10() {
      return this.count > 10;
    },
    someExpensiveLogic() {
      /** 계산하는데 많은 비용이 필요한 computed 라고 가정합니다. */
      return this.isOver10 ? [1, 2, 3] : [4, 5, 6];
    },
  },
  methods: {
    increase() {
      this.count += 1;
    },
  },
  updated() {
    console.log("component updated");
  },
};
</script>
```

위 예시에서 버튼을 11번 누를때까지 `HelloWorld` 컴포넌트는 몇번이나 `re-render` 할까요?

정답은 `11번 모두` 입니다.

버튼을 클릭할 때마다 발생하는 과정은 다음과 같습니다.

1. 버튼을 클릭했을 때 `count` 값이 증가합니다.
2. `isOver10` 은 `count` 에 의존하고 있기 때문에 `dirty` 처리됩니다.
3. `someExpensiveLogic` 도 `isOver10` 에 의존하고 있기 때문에 `dirty` 처리됩니다.
4. 컴포넌트 템플릿이 `someExpensiveLogic` 를 참조하고 있기 때문에
   `dirty` 처리된 속성들의 재연산이 수행됩니다.
   하지만 반환되는 결과값은 모두 동일합니다.
5. 이로인해 새로운 가상 DOM 과 template 을 이용해서
   동일한 화면을 그리는 불필요한 렌더링이 발생합니다.

이 문제의 원인을 요약하면 다음과 같습니다.

**_동일한 값을 자주 반환하는 `computed` 속성을 참조하고 있는_**

**_연산 비용이 비싼 다른 `computed` 속성 혹은 `watcher` , `template 요소` 등이 존재한다._**

## 📌 이러한 경우 절대 `computed` 속성을 사용하면 안되나요?

그렇다고 이러한 경우를 모두 고려해서 `computed` 속성 사용을 피할 필요는 없습니다.

`Vue` 의 반응형 시스템은 효율적으로 동작하도록 최적화되어있기 때문에

대부분의 경우 최상의 성능을 보장합니다. (특히 `Vue 3` 에서는!)

때문에 `computed` 속성을 사용할 때 이러한 특성이 있다는 것을 알아두고

정말 규모가 크고 연산 비용이 큰 경우에만 조심해서 사용하면 될 것 같습니다.

## 📌 참고 자료

[Vue: When a computed property can be the wrong tool](https://dev.to/linusborg/vue-when-a-computed-property-can-be-the-wrong-tool-195j)

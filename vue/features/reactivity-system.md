# Vue 의 반응형 시스템은 어떻게 동작할까?

<aside>
💡 본 포스트는 Vue 2.x 를 기준으로 작성되었습니다.

</aside>

[이전 포스트](<(https://handhand.tistory.com/30?category=935601)>)에서 제가 사이드 프로젝트를 진행하며 실제 마주했던 이슈와 함께

`Vue` 의 반응형 시스템에 대해서 간단하게 알아봤다면

이번 포스트에서는 내부 동작에 대해 좀 더 깊이있는 내용들을 알아보려고 합니다.

## 📌 Vue 는 어떻게 상태 변화를 감지할까?

다음은 `data` 를 화면에 보여주는 간단한 `Vue` 컴포넌트 예시입니다.

```jsx
<template>
	<div>
	  <h1 class="hello">
	    {{ name }}
	  </h1>
		<input v-model="name" />
	<div>
</template>

<script>
export default {
  name: "HelloWorld",
  data() {
    return {
      name: "HandHand",
    };
  },
};
</script>
```

여기서 `name` 값이 변경되면 이 값이 화면에 그대로 반영됩니다.

`Vue` 내부적으로는 이 과정이 어떻게 진행되는 것일까요?

다음은 `Vue` 공식 문서에 소개되어있는 반응형의 동작 원리에 대한 그림입니다.

![1](https://user-images.githubusercontent.com/37819666/156924975-3d4a8272-8f5e-4da6-be32-a3743fafb58f.png)

### data 속성의 할당 방식

`Vue` 는 `data` 로 JavaScript 객체를 할당하게 되면 `Object.defineProperty` 를 활용해서

해당 객체에 `getter / setter` 를 정의합니다.

이 덕분에 데이터의 변화 및 참조를 감지할 수 있는 것이죠.

### 컴포넌트 watcher 할당

모든 Vue 컴포넌트는 `watcher` 인스턴스를 가지게 됩니다.

이는 컴포넌트가 렌더링에 필요한 모든 의존성을 추적하는 역할을 담당합니다.

`watcher` 가 렌더링에 의존하고있는 데이터의 `setter` 가 업데이트되면 이를 감지하고

컴포넌트의 리렌더링을 발생시키는 것입니다.

### 예시를 통해 알아봅시다

방금 설명한 내용을 앞선 예시를 통해 살펴보겠습니다.

1. `data` 인 `name` 은 `h1` 과 `input` 요소에서 참조되고있습니다.
2. `Vue` 가 렌더링을 수행할 때 `h1` 과 `input` 에 참조되어있는 `name` 을 읽으면서 (`touch`)
   `getter` 가 수행되고 이 둘의 의존성 정보를 `watcher` 에게 알립니다.
3. 이후 데이터가 수정되었을 때 `setter` 가 수행되면서 컴포넌트가 의존하고 있는
   데이터 변화를 `watcher` 가 감지하면서 리렌더링을 지시합니다.

## 📌 Vue 는 비동기로 DOM을 업데이트 합니다.

### 비동기 DOM 업데이트 Queue

이전 포스트에서 언급했듯이 `Vue` 는 비동기로 DOM 업데이트를 진행합니다.

`data` 의 변화가 감지되면 큐를 생성한 뒤 이를 `push` 합니다.

이때 같은 이벤트 루프에서 발생된 모든 데이터 변화를 버퍼링하여

동일한 `watcher` 가 여러번 호출되는 것을 한번의 호출로 최적화한 뒤 `push` 하게 됩니다.

이후 다음 이벤트 루프가 `tick` 된다면, `Vue` 는 `queue` 에서 작업을 꺼내

필요한 DOM 업데이트를 수행합니다.

### Vue.nextTick

`Vue` 는 직접적인 DOM 접근을 통한 처리를 지양하고 `data-driven` 방식으로

로직을 세우는 것을 권장하고 있지만, 가끔 직접 DOM 에 접근해서 값을 가져와야 할 때가 있습니다.

앞서 말했듯이 DOM 업데이트는 이벤트 루프를 통해 비동기적으로 수행되기 때문에

만약 DOM 에서 새로 업데이트된 값을 참조해야한다면 `Vue.nextTick` 을 통해서

DOM이 업데이트를 완전히 마치기를 기다려야합니다.

```jsx
methods: {
  async updateName() {
    this.name = "JH";
    console.log(this.$el.textContent); // HandHand
    await this.$nextTick();
    console.log(this.$el.textContent); // JH
  },
}
```

## 📌 Vue 내부 구현 들여다보기

이번에는 실제 `Vue` 의 구현 코드에서 위 방식이 어떻게 구성되어있는지 살펴보겠습니다.

### defineReactive

`reactive` 한 속성을 정의하는 함수입니다.

해당 함수 내부 구현을 보시면 다음과 같이 되어있습니다.

이해도를 높이기 위해 중요한 부분만 명시했습니다.

```jsx
export function defineReactive(/** */) {
  const dep = new Dep();

  // ...

  let childOb = !shallow && observe(val);
  Object.defineProperty(obj, key, {
    // ...
    get: function reactiveGetter() {
      // ...
      dep.depend();
      if (childOb) {
        childOb.dep.depend();
        if (Array.isArray(value)) {
          dependArray(value);
        }
      }
      // ...
    },
    set: function reactiveSetter(newVal) {
      // ...
      childOb = !shallow && observe(newVal);
      dep.notify();
    },
  });
}
```

보시다시피 `defineReactive` 는 인스턴스 `data` 의 각 키들에 대해 `getter` 와 `setter` 를 설정합니다.

**1️⃣  getter**

`Dep` 에 해당 속성을 의존성으로 추가합니다.

이때 배열의 경우 재귀적으로 의존성을 추가하는 `dependArray` 를 호출합니다.

2️⃣  **setter**

새로운 값에 대한 Observer 를 생성한 뒤 `Dep` 에 의존하는 값에 변화가 생겼다는 것을 `notify` 합니다.

### Observer (Dep & Watcher)

`Observer` 는 `observable` 한 각각의 객체에 할당됩니다.

이를 통해 의존성 변화를 감지하고 업데이트를 수행합니다.

```jsx
class Observer {
  constructor(value: any) {
    this.dep = new Dep();

    def(value, "__ob__", this);

    if (Array.isArray(value)) {
      this.observeArray(value);
    } else {
      this.walk(value);
    }
  }

  walk(obj: Object) {
    /**
     * defineReactive 를 통해 객체의 모든 속성을 반응형으로 만듭니다.
     */
  }

  observeArray(items: Array<any>) {
    /**
     * 배열의 각 요소에 observer 를 할당합니다.
     */
  }
}
```

`Observer` 는 객체 내부에 `__ob__` 속성을 할당합니다.

또한 배열에 대한 종속성 검사를 위해 재귀적으로 `Observer` 를 생성하며

그 외 객체의 경우 각 속성들을 `defineReactive` 를 통해 반응형으로 만듭니다.

**⭐️ Dep**

```jsx
class Dep {
  static target: ?Watcher;
  id: number;
  subs: Array<Watcher>;

  constructor() {
    this.subs = [];
  }

  addSub(sub: Watcher) {
    this.subs.push(sub);
  }

  removeSub(sub: Watcher) {
    remove(this.subs, sub);
  }

  depend() {
    if (Dep.target) {
      Dep.target.addDep(this);
    }
  }

  notify() {
    const subs = this.subs.slice();
    for (let i = 0, l = subs.length; i < l; i++) {
      subs[i].update();
    }
  }
}
```

`Dep` 은 내부적으로 `Watcher` 배열을 유지합니다.

구독 - 발행 모델로 의존성의 변화를 `notify` 받게 되면 `update` 를 통해 `Watcher` 에게 알립니다.

**⭐️ Watcher**

```jsx
class Watcher {
  // ...

  update() {
    if (this.lazy) {
      this.dirty = true;
    } else if (this.sync) {
      this.run();
    } else {
      queueWatcher(this);
    }
  }
}
```

## 📌 참고 자료

[Reactivity in Depth - Vue.js](https://v2.vuejs.org/v2/guide/reactivity.html)

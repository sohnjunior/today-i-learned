# Vue 에서 Unit Testing 하기 - 3편

## 조금 더 복잡한 컴포넌트 테스트하기

이번에는 이전 포스트에서 작성한 컴포넌트 보다 좀 더 복잡한 컴포넌트들을 테스트하며

테스트 코드 작성 방법을 익혀보도록 하겠습니다.

### 테스트할 RandomNumber 컴포넌트

```jsx
<template>
  <div>
    <span class="number">{{ randomNumber }}</span>
    <button class="btn" @click="getRandomNumber">Generate Random Number</button>
  </div>
</template>

<script>
export default {
  props: {
    min: {
      type: Number,
      default: 1
    },
    max: {
      type: Number,
      default: 10
    }
  },
  data() {
    return {
      randomNumber: 0
    }
  },
  methods: {
    getRandomNumber() {
      this.randomNumber = Math.floor(Math.random() * (this.max - this.min + 1) ) + this.min;
    }
  }
}
</script>
```

위 컴포넌트의 입력값과 출력값을 나타내면 다음과 같습니다.

- 입력값

    `random number` , `min & max` , `난수 생성 버튼을 클릭하는 사용자 상호작용`

- 출력값

    `렌더링된 난수 값`

해당 컴포넌트를 테스트 할 수 있는 몇가지 케이스는 다음과 같습니다.

1. 기본적으로 `randomNumber` 는 0 이어야 한다.
2. 버튼을 클릭하면 `0 ~ 10` 사이의 난수를 생성해야한다.
3. 만약 `min, max` 값을 변경한다면, 변경된 범위 내의 난수를 생성해서 출력해야 한다.

이제 각각의 경우에 대한 테스트 코드를 작성해보겠습니다. 😀

## 첫 번째 테스트 코드 작성하기

```jsx
import { shallowMount } from "@vue/test-utils";
import RandomNumber from "@/components/RandomNumber";

describe("RandomNumber", () => {
		test("by default the random number should be 0", () => {
        const wrapper = shallowMount(RandomNumber);
        expect(wrapper.vm.$data.randomNumber).toEqual(0);
    });
});
```

`기본적으로 randomNumber는 0이어야 한다` 라는 조건을 만족하는지 테스트하기 위해서

위와 같은 코드를 작성할 수 있습니다.

`shallowMount` 를 통해서 `wrapper` 를 생성하고 `vm` 프로퍼티를 통해서 

모든 인스턴스 메서드와 프로퍼티에 접근하게 됩니다.

그 중 `$data` 프로퍼티는 Vue 인스턴스의 `data` 속성에 접근이 가능하기 때문에 해당 컴포넌트가

가지고 있는 데이터 값을 확인하는 용도로 활용하게 됩니다.

또한 `toEqual` 을 통해서 우리가 원하는 값과 일치하는 값인지 확인이 가능합니다.

## 두 번째 테스트 코드 작성하기

```jsx
test("if we click the generate button, we should get a random number between 1 and 10", () => {
    const wrapper = shallowMount(RandomNumber);
    wrapper.find('.btn').trigger('click');

    const randomNumber = wrapper.vm.$data.randomNumber;
    expect(randomNumber).toBeGreaterThanOrEqual(1);
    expect(randomNumber).toBeLessThan(11);
});
```

이번에는 두번째 조건을 만족하는지 테스트 하기 위해서 `click` 이벤트를 활용해보겠습니다.

먼저 앞선 테스트와 같이 `shallowMount` 를 통해서 `wrapper` 를 생성하고

해당 `wrapper` 내부의 버튼 컴포넌트를 찾습니다.

그리고 `trigger` 를 이용해서 `click` 이벤트를 발생시킵니다.

이후 값이 올바르게 변경되었는지 확인하기 위해서 `toBeGreaterThanOrEqual` 와 

`toBeLessThan` 를 사용하여 범위내에 값이 존재하는지 확인합니다.

## 세 번째 테스트 코드 작성하기

```jsx
test("if we click the generate button, we should get a random number between 100 and 200", () => {
    const wrapper = shallowMount(RandomNumber, {
        propsData: {
            min: 100,
            max: 200,
        }
    });

    wrapper.find('.btn').trigger('click');

    const randomNumber = wrapper.vm.$data.randomNumber
    expect(randomNumber).toBeGreaterThanOrEqual(100);
    expect(randomNumber).toBeLessThan(201);
});
```

마지막으로 `prop` 을 통해 `min, max` 값을 설정하는 경우에 대해서 다뤄보겠습니다.

마찬가지로 `randomNumber` 값이 해당 범위내에 존재하는지는 

앞선 두 번째 경우와 동일한 방법으로 검증할 수 있습니다.

다만 이번에는 `prop` 을 설정하기 위해 `propsData` 를 `shallowMount` 호출 시 

인자로 함께 넘겨준 것을 확인할 수 있습니다.

## 참고 자료

[Unit Testing in Vue: More complex components | Vue Mastery](https://www.vuemastery.com/blog/unit-testing-in-vue-more-complex-components)
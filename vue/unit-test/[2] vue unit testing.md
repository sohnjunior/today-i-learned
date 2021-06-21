# Vue 에서 Unit Testing 하기 - 2편

이번 포스팅에서는 원문에서와 같이 데모 프로젝트를 생성한 뒤 

직접 몇 가지 유닛 테스트를 작성해보며 필요한 지식들을 학습하게 됩니다.

먼저 원문에서와 동일하게 프로젝트를 설정하도록 합니다.

## Jest 와 Vue Test Utils

### Jest 란?

`Jest` 는 Javascript 테스팅을 위한 프레임워크 입니다.

이를 사용하면 `Jest` 가 우리가 작성한 유닛 테스트를 자동으로 실행해주고 결과를 알려주게 됩니다.

`Jest` 는 규모가 큰 라이브러리이지만 간단한 유닛 테스트를 위해서는 몇가지 기능만 알면 됩니다.

### Vue Test Utils 란?

`Vue Test Utils` 는 Vue.js 를 위한 공식 유닛 테스트 유틸리티 라이브러리입니다.

해당 라이브러리를 통해 컴포넌트를 렌더링할 수 있으며 렌더링된 컴포넌트를 조작해서

실제 결과값을 검증할 수 있습니다.

## 유닛 테스트 작성해보기

테스팅을 학습하기 위해 가장 좋은 방법은 직접 테스트 코드를 작성해보는 것입니다.

```jsx
<template>
  <div>
    <button class="btn" v-show="loggedIn">Logout</button>
  </div>
</template>
  
<script>
export default {
  name: 'app-header',
  data() {
    return {
      loggedIn: false
    }
  }
}
</script>
```

먼저 위와 같은 `AppHeader` 컴포넌트를 작성합니다.

해당 컴포넌트의 `input` 과 `output` 은 각각 다음과 같습니다.

- Input : `loggedIn`
- Output : `button` 컴포넌트 랜더링 유무

위와 같은 조건이 주어졌을 때 생각할 수 있는 테스트는 무엇이 있을까요?

`loggedIn` 유무에 따른 `button` 렌더링 유무 (true, false) 가 있을 수 있겠습니다.

```jsx
// AppHeader.spec.js

import { mount } from '@vue/test-utils';
import AppHeader from '@/components/AppHeader';

describe('AppHeader', () => {
    test('if a user is not logged in, do not show the logout button', () => {
        const wrapper = mount(AppHeader);
        expect(wrapper.find('button').isVisible()).toBe(false);
    });

    test('if a user is logged in, show the logout button', () => {
        const wrapper = mount(AppHeader);
        wrapper.setData({ loggedIn: true });
        expect(wrapper.find('button').isVisible()).toBe(true);
    });
});
```

`Wrapper` 컴포넌트는 마운트이후 렌더링된 Vue 컴포넌트를 포함하며 테스트를 위한

여러가지 메서드를 제공합니다.

그 중 `find` 를 사용하면 렌더링된 템플릿에서 주어진 선택자에 해당하는 DOM 을 찾을 수 있습니다.

또한 `isVisible` 을 이용하면 해당 컴포넌트가 실제로 화면에서 보이는지 유무를 알 수 있습니다.

## 참고 자료

[Unit Testing in Vue: Your First Test | Vue Mastery](https://www.vuemastery.com/blog/Unit-Testing-in-Vue-Your-First-Test)
# Vue mixin 의 효과적인 사용을 위한 영리한 방법

## 시작하며

회사의 기존 소스코드를 분석하며 가장 힘들었던 부분이 바로 `mixin` 사용과 관련된 것이었습니다.

어떻게 하면 `mixin` 을 사용하면서 코드 분석이 용이하도록 할 수 있을지에 대한 고민이 필요했습니다.

## Vue 스타일 가이드에서 제시하는 방법

```jsx
const myAwesomeMixin = {
	methods: {
		$_myAwsomeMixin_update: function () { /** ... */ }
	}
}
```

`Vue 스타일 가이드` 에서는 위와 같이 `mixin` 의 사용자 정의 프로퍼티는 `$_` 라는 접두사를

이용하는 것을 추천합니다.

`_` 접두사는 사용하면 안될까?

`Vue` 에서는 이미 `private` 속성을 위해 `_` 접두사를 사용하고 있습니다.
따라서 `_update` 와 같이 정의할 경우 기존에 있는 속성과 충돌할 수 있으며
운 좋게 지금은 충돌하지 않더라도 나중에 버전이 업데이트 되며 
새롭게 추가되거나 변경된 속성들과 충돌이 발생할 가능성이 있습니다.
따라서 `$_` 접두사 사용을 추천합니다.

## 참고자료

[What does the dollar prefix ($) mean in Vue.js?](https://stackoverflow.com/questions/56881724/what-does-the-dollar-prefix-mean-in-vue-js)

[Style Guide - Vue.js](https://vuejs.org/v2/style-guide/#Private-property-names-essential)
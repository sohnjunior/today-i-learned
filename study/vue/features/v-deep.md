# vue 에서 v-deep 이란?

## 컴포넌트의 scoped 선언

사내에서 `vuetify` 로 구성된 화면을 다루는 일이 있는데,

이때 `vuetify` 에서 구현되어 제공되는 컴포넌트의 스타일 변경이 마음대로 되지 않을 때가 있습니다.

이럴 때 다음과 같이 `scoped` 선언 없이 스타일을 덮어 씌우면 해결되는 경우도 있지만

이 경우 전역적으로 해당 스타일이 영향을 주기 때문에 좋지 않은 방법입니다.

```tsx
// BAD !

<style>
	.some-style { /** */ }
<style>
```

그렇다면 어떻게 `scoped` 를 해치지 않고 자식 컴포넌트의 스타일을 지정할 수 있을까요?

개발자가 구현한 자식 컴포넌트라면 해당 컴포넌트가 선언된 부분에서 수정을 하면 되겠지만,

`vuetify` 와 같이 번들링된 라이브러리 소스 코드를 수정하는 것은 쉽지 않은 일입니다.

이럴 때 `vue` 에서 제공하는 `딥 셀렉터` 인 `v-deep` 을 활용하면 됩니다.

## v-deep 을 통해 자식 컴포넌트 스타일 변경하기

Vue 에서 제공하는 `딥 셀렉터` 는 총 3가지 방식으로 사용이 가능합니다.

```tsx
// #1
<style scoped>
.a >>> .b { /* ... */ }
</style>

// #2
<style scoped>
.a::v-deep .b { /* ... */ }
</style>

// #3
<style scoped>
.a /deep/ .b { /* ... */ }
</style>
```

`sass` 와 같은 일부 CSS 전처리 환경에서는 `>>>` 가 올바르게 동작하지 않을 수 있습니다.

이 경우에는 두번째나 세번째 방법을 사용하면 됩니다.

## v-deep 을 이용해서 v-html 스타일 다루기

`v-html` 로 선언된 HTML 마크업은 `scoped` 스타일 적용이 안됩니다.

이때 `v-deep` 을 이용하면 스타일을 적용할 수 있습니다.

```tsx
<template>
  <div>
    <div v-html="htmlData" />
  </div>
</template>

<script lang="ts">
// ...

export default class Index extends Vue {
  private htmlData = '<p class="red">Hello World!</p>'
}
</script>

<style lang="scss" scoped>
div::v-deep .red {
  color: red;
}
</style>
```

## 참고 자료

[Scoped CSS | Vue Loader](https://vue-loader.vuejs.org/guide/scoped-css.html#deep-selectors)

[자식 컴포넌트의 CSS(SCSS)를 정의할 수 있는 딥셀렉터(v-deep) 설정하는 방법](https://uxgjs.tistory.com/261)
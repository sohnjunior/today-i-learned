# [You Don’t Know JS] Chapter 1. 타입

## JS 의 신기한 타입들

`Javascript` 에는 버그처럼 보이는 몇가지 신기한 타입들이 있습니다.

우선 기본적으로 Javascript 는 `원시 타입` 이라고 부르는 7가지 내장 타입이 있습니다.

```
null, undefined, number, string, boolean, object, symbol
```

하지만 타입을 조사해보면 정확히 `1:1` 로 매칭되는 것은 아닙니다.

대표적으로 `null` 이 있죠.

```jsx
> typeof null
<- 'object'
```

따라서 특정 값이 `null` 인지 정확히 체크하기 위해서는 다음과 같은 조건문이 필요합니다.

```jsx
const a = null;
(!a && typeof a === 'object') // true
```

그리고 `함수` 도 `function` 이라는 타입을 가지고 있으며

`function` 은 `object` 의 하위타입입니다.

```jsx
> typeof function() {}
<- 'function'
```

## undefined 와 undeclared 는 다르다

흔히 `undefined` 의 의미를 `undeclared` 와 혼동하는 경우가 있습니다.

하지만 JS 에서는 이 둘을 전혀 다른 의미로 사용하고 있습니다.

```jsx
let m
typeof m // undefined
n; // Reference Error!
```

`undefined(값이 없는)` 과 `undeclared(값이 선언되지 않은)` 은 확실히 다른 의미입니다.

한가지 이상한 점은 다음과 같이 `undeclared` 된 값에 `typeof` 연산자를 사용했을 때입니다.

```jsx
typeof mn // undefined
```

이것은 `typeof` 만의 독특한 안전 가드입니다.

## typeof 안전 가드 활용 사례

### 전역 변수 참조

`typeof 안전가드` 는 전역 변수 참조나 특정 설계 방식에서 유용하게 사용될 수 있습니다.

우선 전역 변수 참조는 다음과 같이 활용됩니다.

```jsx
if (typeof DEBUG !== 'undefined') { /** */ }
```

안전가드를 사용하지 않고도 전역 변수 존재 유무를 체크할 수 있습니다.

```jsx
if (window.DEBUG) { /** */ }
```

전역 변수는 번역 객체(브라우저의 경우 `window`) 의 프로퍼티라는 점을 이용한 것이지만

Javascript 환경이 저마다 다르기 때문에 전역 객체가 꼭 `window` 라는 보장이 없기 때문에

주의가 필요합니다.

### 함수 참조방식 설계

특정 함수에서 다른 함수를 참조하고 있고, 만약 다른 개발자가 이 함수를

그대로 복사해서 사용하는 경우가 있다고 가정하겠습니다.

```jsx
function someAwesomeFunc() {
	const helper = (typeof FeatureFn !== 'undefined')
									? FeatureFn
									: function() { /** 기본 기능 구현 */ } 
}
```

이러한 설계 방식을 따른다면 `FeatureFn` 의 존재 유무를 확실히 체크할 수 있습니다.

다만 일부 개발자들은 이러한 방식 대신 `의존성 주입` 을 통해 

명시적으로 의존 관계를 표현하는게 더 좋은 설계라고 주장하기도 합니다.

```jsx
function someAwesomeFunc(FeatureFn) {
	const helper = FeatureFn || function() { /** 기본 기능 구현 */ } 
}
```
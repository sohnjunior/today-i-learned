# 익명함수와 기명함수 언제 써야할까?

## 익명함수와 기명함수

`Javascript` 에서 함수를 정의할 때 함수의 이름을 지정하지 않는 `익명함수` 와

그 반대인 `기명함수` 방식으로 정의를 할 수 있습니다.

```jsx
function getUserName() { /** 기명함수 */ }

const getUserName = function() { /** 익명함수 */ }
```

위 예시코드에서 `기명함수` 는 `함수 선언문` 이고 `익명함수` 는 `함수 표현식` 방식입니다.

## 이 둘의 차이점은?

위 선언 방식은 각 함수가 `호출되는 시점`에 차이가 발생합니다.

간단한 예시를 통해 각 함수들의 호출 방식을 살펴보겠습니다.

### 익명함수와 호이스팅

```jsx
func(); // TypeError: func is not a function

var func = function() {
  console.log("익명함수");
};
```

익명함수는 `호이스팅에 영향을 받지 않는다` 는 특징을 가지고 있습니다.

실제로 `func` 가 호이스팅이 되지 않는 것은 아닙니다.

다만 `undefined` 로 초기화되어있기 때문에 

함수 선언 이전에 예상치 못하게 호출이 되는 것을 방지할 수 있습니다.

### 기명함수와 호이스팅

```jsx
func() // 기명함수

function func() {
	console.log("기명함수")
}
```

반면 `기명함수` 는 `호이스팅에 영향을 받아` 함수 선언부가 끌어올려져서

실제 함수 선언 위치보다 이전에 함수를 호출해도 문제가 발생하지 않습니다.

이는 함수 선언 및 호출방식에서 유연성을 부여해줄 수도 있지만

의도하지 않은 함수 호출을 허용할수도 있습니다.

### 그렇다면 언제 무엇을 써야할까?

그렇다면 위 두 함수 선언 방식은 언제 사용하는 것이 좋을까요?

사용하는 사람마다 의견이 다를 수 있지만 저는 `함수 재사용성` 과 `기능` 에 초점을 두고 정의합니다.

만약 해당 함수가 재사용될 가능성이 있거나 분명한 목적으로 정의될 필요가 있는 함수라면

`함수 선언문` 을 이용해서 `기명 함수` 로 정의합니다.

반대로 재사용될 필요가 없는 함수들의 경우에는 `익명 함수` 를 사용하는 것입니다.

이 경우 `IIFE` (즉시 실행 함수) 나 `콜백 함수` , 혹은 `클로저 생성` 을 위한 목적으로 사용합니다.

## 참고자료

[[JavaScript] 함수선언식(Function Declaration)과 함수표현식(Function Expression)](https://jae04099.tistory.com/entry/%ED%95%A8%EC%88%98%EC%84%A0%EC%96%B8%EC%8B%9DFunction-Declaration%EA%B3%BC-%ED%95%A8%EC%88%98%ED%91%9C%ED%98%84%EC%8B%9DFunction-Expression)

[javascript 함수와 호이스팅](https://velog.io/@swhan9404/javascript-%ED%95%A8%EC%88%98%EC%84%A0%EC%96%B8%EB%AC%B8%EA%B3%BC-%ED%98%B8%EC%9D%B4%EC%8A%A4%ED%8C%85)

[Anonymous Functions vs Named Functions vs Arrow Functions](https://dev.to/mathlete/anonymous-functions-vs-named-functions-vs-arrow-functions-57pm)

[익명 함수(Anonymous Function)에 대하여](https://daklee.tistory.com/entry/%EC%9D%B5%EB%AA%85-%ED%95%A8%EC%88%98Anonymouse-Function%EC%97%90-%EB%8C%80%ED%95%98%EC%97%AC)
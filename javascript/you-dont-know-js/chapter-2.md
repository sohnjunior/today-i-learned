# [You Don’t Know JS] Chapter 2. 값

## 배열

Javascript 의 배열은 다른 엄격한 언어와 달리 서로 다른 타입의 값들을 넣을 수 있습니다.

```jsx
const arr = ['1', true, 200]
```

또한 다음과 같이 슬롯에 구멍이 존재하는 배열도 생성할 수 있습니다.

```jsx
const arr = []

arr[2] = 0
arr[0] // undefined
```

배열의 인덱스 값은 `숫자` 인데, 다음과 같이 숫자 문자열을 할당하면 예상치 못한 동작을 일으킵니다.

```jsx
const arr = []
arr["13"] = 1
arr.length // 14
```

따라서 배열의 인덱스는 `숫자 타입` 만 사용하는 것이 좋습니다. 😀

## 문자열

흔히 문자열을 `문자의 배열` 이라고 생각하는 경우가 많습니다.

하지만 Javascript 에서는 생김새만 비슷하고 전혀 다른 것에 주의해야합니다.

다음 두 값은 같은 값일까요?

```jsx
const a = "foo"
const b = ["f", "o", "o"]
```

기본적으로 문자열은 `불변값` 이고 배열은 `가변값` 입니다.

`불변값` 이기 때문에 다음과 같이 특정 인덱스의 값을 변경하는 것을 허용하지 않습니다.

```jsx
a[1] = 'a'
a // foo
```

이 때문에 문자열의 메서드는 항상 기존의 값을 변경하지 않고 새로운 값을 반환합니다.

```jsx
const F = FISH"
const f = F.toLowerCase()

console.log(f)
```

또한 문자열에 대해서 기존 배열의 불변 메서드는 빌려서 사용할 수 있습니다.

```jsx
Array.prototype.join.call(a, "-") // a-p-p-l-e
Array.prototype.map.call(a, (c) => console.log(c)
```

## 숫자

Javascript 는 `number` 라는 숫자 타입을 가지고 있으며 

정수 및 부동 소수점 숫자를 모두 포함합니다.

Javascript 는 다른 언어와 마찬가지로 `IEEE754` 표준을 따르고 있으며

이 때문에 `IEEE754` 의 공통적인 부동 소수점 계산 문제를 가지고 있습니다.

```jsx
0.1 + 0.2 === 0.3 // false
```

### 부동 소수점 일치 비교 문제 해결법

일반적으로 `반올림 오차` 를 `허용 공차` 로 처리하는 방법을 사용합니다.

이렇게 아주 미세한 오차를 `머신 입실론` 이라고 하며 Javascript 의 머신 입실론은 `2^-52` 입니다.

ES6 이후에는 해당 값이 `Number.EPSILON` 으로 정의가 되어있습니다.

```jsx
function isCloseEnoughToEqual(n1, n2) {
    return Math.abs(n1 - n2) < Number.EPSILON
}

isCloseEnoughToEqual(0.1 + 0.2, 0.3) // true
```

### 안전 정수 범위

Javascript 부동 소수점의 최댓값은 `Number.MAX_VALUE` , 최솟값은 `Number.MIN_VALUE` 로 

정의되어 있으며, 정수는 이 보다 작은 범위에서 안전한 범위가 정해져 있습니다.

안전한 정수 범위는 최대 `2^53 - 1` (대략 9000조) 입니다.

이 값은 `Number.MAX_SAFE_INTEGER` 으로 정의되어 있고 

최솟값은 `Number.MIN_SAFE_INTEGER` 로 정의되어 있습니다.

## 특수 값

### void 연산자

`void` 연산자는 어떤 값이든 무효로 만들어 항상 결과값을 `undefined` 로 만듭니다.

이는 어떤 표현식의 결괏값이 없다는 것을 명시적으로 나타낼 때 유용합니다.

```jsx
const a = 42

console.log(void a, a) // undefined, 42
```

### NaN

`NaN` 은 `Not a Number` 라고 풀어쓸 수 있지만 사실 오해의 소지가 다분한 명칭입니다.

`숫자가 아니다` 라는 표현보다는 `유효하지 않은 숫자` 혹은 `실패한 숫자` 라는 표현이 더 부합하기 때문입니다.

```jsx
const a = 2 / "foo" // NaN
typeof a === 'number' // true
```

즉, `NaN` 은 숫자 집합 내에서 에러 상황을 나타내기 위한 `경계 값` 의 성격을 가집니다.

`NaN` 은 신기하게도 어떤 `NaN` 과도 동등하지 않다는 특징을 가지고 있습니다.

```jsx
NaN === NaN // false
```

때문에 `Number` 객체의 내장 함수인 `isNaN` 을 이용해서 비교를 해줘야 합니다.

```jsx
const a = 2 / 'foo'
Number.isNaN(a) // true
```

### 무한대

Javascript 에서는 `0으로 나누기` 와 같은 연산을 수행하면 `무한대` 를 반환합니다.

또한 `양의 무한대` 와 `음의 무한대` 가 나뉘어서 존재합니다.

```jsx
const a = 1 / 0  // Infinity
const b = -1 / 0 // -Infinity
```

### 0, -0

Javascript 에는 `+0` 과 `-0` 이 구분되어 있습니다.

하지만 실제로 비교 연산자를 사용해보면 예상하지 못한 결과값을 내놓습니다.

```jsx
0 === -0 // true
0 > -0 // false
```

왜 `-0` 이 구분되어서 존재하는 것일까요?

이는 값의 크기로 어떤 정보와 그 값의 부호로 또 다른 정보를 동시에 사용해야하는 앱이 있기 때문입니다.

(저자는 애니메이션 프레임당 넘김 속도와 방향을 사용하는 앱을 예시로 들었습니다)

만약 `+0` 과 `-0` 이 구분되지 않는다면 부호가 바뀌는 순간, 그 직전까지의 정보를 알 수 없게 되는 것이죠.

### 특이값의 동등 비교

`NaN` 과 `-0` 의 동등 비교는 까다롭습니다.

다행히도 `ES6` 부터는 `[Object.is](http://Object.is)` 를 통해서 두 값이 절대적으로 동등한지 확인하는 방법을 제공합니다.

```jsx
Object.is(0, -0) // false
Object.is(NaN, NaN) // true
```
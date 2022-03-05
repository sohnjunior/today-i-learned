# [You Don’t Know JS] Chapter 4. 강제변환

## 📌 Javascript 의 값 변환

어떤 값을 다른 값으로 바꾸는 과정이 명시적이라면 `타입 캐스팅` 이라고 하고

암시적이라면 `강제변환` 이라고 합니다.

```jsx
const a = 42;
const b = a + ""; // 암시적 강제변환
const c = String(a); // 명시적 강제변환
```

## 📌 추상 연산

Javascript 에는 타입간 변환에 사용되는 `추상 연산` 이 정의되어 있습니다.

### toString

`문자열이 아닌 값` 에서 `문자열` 으로의 변환 작업은 해당 추상 연산이 담당합니다.

내장 원시 값은 정해진 문자열화 방법이 있습니다.

일반 객체의 경우에는 `toString` 메서드를 구현해서 문자열화 방법을 지정할 수 있습니다.

만약 `toString` 이 구현되어 있지 않다면 내부 `[[Class]]` 를 반환합니다.

### toNumber

`숫자가 아닌 값` 에서 `수식 연산이 가능한 숫자` 로의 변환은 해당 추산 연산이 담당합니다.

변환이 실패하면 `NaN` 을 반환합니다.

객체의 경우, 우선 원시값으로 변환 후 그 값을 이용해서 강제변환합니다.

이때 동등한 원시값으로 변환하기 위해 `valueOf -> toString` 순으로 메서드를 확인합니다.

만약 원시값으로 변환에 실패하면 TypeError 오류를 발생시킵니다.

```jsx
const a = {
  valueOf: function () {
    return "42";
  },
};

const b = {
  toString: function () {
    return "42";
  },
};

const c = [4, 2];
c.toString = function () {
  return this.join("");
};

console.log(Number(a)); // 42
console.log(Number(b)); // 42
console.log(Number(c)); // 42
```

### toBoolean

Javascript 명세에 정의된 `falsy` 한 값들은 다음과 같습니다.

다음 값 이외에는 모두 `truthy` 한 값들입니다.

- undefined
- null
- false
- “”
- +0, -0, NaN

⭐️ **Falsy 객체**

객체는 `truthy` 한 값입니다.

그러면 `Falsy 객체` 란 무엇일까요?

사실 이는 브라우저 환경에서 적용되는 비표준 기능입니다.

`falsy 객체` 란 겉보기엔 일반적인 객체이지만 Boolean 으로 강제변환하면 `false` 값을 가집니다.

대표적인 예시로 `document.all` 이 있습니다.

```jsx
document.all || 'apple'

-> 'apple'
```

이는 `if (document.all) { /** it is IE */ }` 와 같은 레거시 코드와의

호환성을 위해서 Javascript 타입 체계를 수정한 사례입니다.

이를 통해 `document.all` 이 `falsy` 인 것 처럼 작동하게 한 것이었습니다.

## 📌 명시적 강제변환

다른 개발자가 내 코드를 보고 의도를 파악하는 과정을 줄이기 위해서는

명시적인 코드를 작성하는 습관이 중요합니다.

이는 타입을 다룰 때도 마찬가지인데, 이번에는 명시적으로 타입을 변환해서

사용하는 몇가지 방법들에 대해서 살펴보겠습니다.

### 문자열과 숫자 사이의 명시적 강제변환

두 타입간 변환을 위해선 `String()` 과 `Number()` 메서드를 사용할 수 있습니다.

이 경우 각각 `ToString` 과 `ToNumber` 추상 연산이 적용됩니다.

```jsx
const a = 42;
const b = "1.2";

const c = Number(a);
const d = String(b);

console.log(c); // 42
console.log(d); // "1.2"
```

이외에도 두 타입간 명시적인 변환 방법에는 다음과 같은 것들이 있습니다.

⭐️  **toString()**

`toString` 메서드는 `String()` 과 달리 래퍼 객체를 생성합니다.

이름 그대로 숫자를 문자열로 변경합니다.

**⭐️ 단항 연산자(+)**

단항 연산자 `+` 를 사용해서 문자열로된 숫자를 숫자형으로 변경할 수 있습니다.

```jsx
const b = "1.2";

console.log(+b); // 1.2
```

또 다른 활용 방법으로 `Date 객체 -> 숫자` 로의 변환에도 사용할 수 있습니다.

이 단항 연산자를 `Date` 객체에 사용하면 타임스탬프 값을 알아낼 수 있습니다.

```jsx
const a = new Date();

console.log(a); // 2022-02-22T14:54:26.218Z
console.log(+a); // 1645541671911
```

**⭐️ 틸드 연산자 (~)**

`~` 연산자는 32비트 숫자로 강제변환한 다음 `NOT` 연산을 수행합니다.

즉, 2의 보수를 구하는 것인데 이는 `~x = -(x + 1)` 과 같다는 것을 의미합니다.

여기서 `x` 가 `-1` 일 때 `~x` 의 값이 0이 되는 것을 알 수 있는데,

프로그래미에서 `-1` 은 흔히 `경계값` 으로 자주 사용됩니다.

한가지 예시로, Javascript 의 `findIndex` 메서드는 조건에 맞는 요소를 찾지 못하면 `-1` 을 반환합니다.

이를 활용하면 다음과 같은 코드를 명시적으로 나타낼 수 있습니다.

```jsx
const a = ["a", "b", "c", "d"];

// 아래와 같은 코드가
if (a.findIndex((e) => e === "c") !== -1) {
  console.log("존재함");
}

// 다음과 같이 변경됩니다.
if (~a.findIndex((e) => e === "c")) {
  console.log("존재함");
}
```

### 숫자 형태의 문자열 파싱

`Number()` 와 `parseInt()` 를 사용하면 숫자 형태의 문자열을 숫자형으로 바꿀 수 있습니다.

```jsx
const a = "42";
const b = "42px";

console.log(Number(a)); // 42
console.log(parseInt(a)); // 42

console.log(Number(b)); // NaN
console.log(parseInt(b)); // 42
```

위 예시에서 알 수 있듯이 `Number()` 는 유효한 숫자 형태가 아니라면 `NaN` 을 반환합니다.

하지만 `parseInt()` 는 비 숫자형 문자를 허용하며, 왼쪽에서 오른쪽으로 파싱을하다가

가장 처음 만나는 비 숫자형 문자에서 파싱을 멈춥니다.

<aside>
💡 `parseInt()` 는 문자열 함수입니다

`parseInt()` 은 인자가 비 문자열이라면 먼저 문자열로 강제변환합니다.
따라서 꼭 목적에 맞게 `parseInt()` 에는 문자열 인자만 넘기도록 합니다.

</aside>

### 불리언 강제변환

비 불리언에서 불리언 타입으로 변환하려면 `Boolean()` 이나 `!!` 연산자를 사용하면 됩니다.

```jsx
const a = "0";

console.log(Boolean(a)); // true
console.log(!!a); // true
```

## 📌 암시적 강제변환

암시적 강제변환이 무조건 나쁜 것일까요?

좋은 면이 있으면 나쁜 면도 있는 법입니다.

저자는 암시적 강제변환을 `무조건` 나쁘다고만 볼 필요는 없다는 점을 말하고 있습니다.

### 문자열과 숫자 사이의 암시적 강제변환

```jsx
const a = 42;
const b = a + "";

console.log(b); // "42"

const c = "42";
const d = c + 0;

console.log(d); // 42
```

숫자형에서 문자열로 바꾸고 싶다면 위와 같이 `+` 연산자를 사용하면 됩니다.

명세에 따르면 `+` 연산자는 한쪽 피연산자가 문자열이거나

타입 변환 과정을 통해 문자열로 바꿀 수 있으면 문자열 붙이기를 수행합니다.

```jsx
const a = [1, 2];
const b = [3, 4];

console.log(a + b); // '1,23,4'
```

⭐️ `**+` 연산자의 피연산자 변환 과정\*\*

1. `valueOf` 에 배열을 넘기면 단순 원시 값으로 반환이 불가능하기 때문에 `toString` 으로 넘어갑니다.
2. `toString` 메서드를 통해 배열의 `ToString` 추상 연산이 수행되며 각각 `'1,2'` 와 `'1,3'` 이 됩니다.
3. `'1,2'` 와 `'1,3'` 이 더해져서 `'1,23,4'` 가 됩니다.

### 불리언 → 숫자 암시적 강제변환

불리언에서 숫자형으로 암시적 강제변환이 유용한 경우도 있습니다.

다음과 같이 세 인자중 정확히 하나만 참/거짓 인지 판단하는 함수가 있다고 하겠습니다.

```jsx
function onlyOne(...args) {
  const sum = args.reduce((acc, arg) => acc + arg);
  return sum === 1;
}

console.log(onlyOne(true, false, true)); // false
console.log(onlyOne(false, false, true)); // true
```

위와 같이 강제변환을 통해 `true -> 1` , `false -> 0` 으로 변환하여

인자의 참거짓 개수를 판단할 수 있습니다.

다만 이 함수는 `truhty` 혹은 `falsy` 한 값까지 다룰 수는 없기 때문에

이 경우에는 명시적인 타입 변환이 필요합니다.

### && 와 || 연산자

`||` 연산자는 결과가 `true` 면 첫 번째 피연산자를, `false` 라면 두 번째 피연산자를 `반환`합니다.

또한 `&&` 연산자는 결과가 `true` 면 두 번째 피연산자를, `false` 라면 첫 번째 피연산자를 `반환`합니다.

중요한 점은 두 연산자 모두 값을 `반환` 한다는 것입니다.

이러한 특징을 활용해서 다음과 같은 코드를 자주 사용할 수 있습니다.

```jsx
// || 연산자를 활용한 기본값 지정

function someFunction(a, b) {
  a = a || "hello";
  b = b || "world";
}

// && 연산자를 활용한 조건부 로직 수행
const isAllowed = false;

isAllowed && someFunction(); // someFunction 은 호출되지 않습니다.
```

## 📌 느슨한 / 엄격한 동등 비교

많은 JS 책들이 `==` 와 `===` 의 차이는 `값과 타입이 모두 일치하는지` 에 따라서 구분된다고 합니다.

그런데 사실 이는 정확한 표현이 아니고 `강제 변환을 허용하는냐 마느냐` 가 더 적합한 표현입니다.

### `==` 연산자 로직 (암시적 강제변환)

`==` 연산자의 비교 알고리즘은 명세의 `추상적 동등 비교 알고리즘` 에 서술되어 있습니다.

이 알고리즘은 비교할 두 값이 같은 타입이라면 그냥 비교를 수행하고 한쪽의 타입이 다를 경우

한쪽 또는 양쪽의 피연산자에서 암시적 강제변환을 수행합니다.

**1️⃣  문자열과 숫자의 비교**

```jsx
42 == "42"; // true
```

```markdown
x == y 를 수행할 때,

- Type(x) = Number 이고 Type(y) = String 이면, x == ToNumber(y) 수행
- Type(x) = String 이고 Type(y) = Number 이면, ToNumber(x) == y 수행
```

**2️⃣  불리언값 비교**

```jsx
42 == true; // false
false == 42; // false
```

```markdown
x == y 를 수행할 때,

- Type(x) = Boolean 이면 ToNumber(x) == y 수행
- Type(y) = Boolean 이면 x == ToNumber(y) 수행
```

불리언 값은 `ToNumber` 추상 연산을 통해 형변환이 이루어집니다.

**따라서 절대 `== true, == false` 와 같은 비교 연산을 수행해서는 안됩니다.**

**3️⃣  null 과 undefined 비교**

```jsx
undefined == null; // true
null == undefined; // true
```

```markdown
x == y 를 수행할 때,

- x 가 null 이고 y 가 undefined 면 true
- x 가 undefined 이고 y 가 null 면 true
```

즉 `null` 과 `undefined` 는 서로에게 타입을 맞춥니다.

이 둘 사이의 강제 변환은 안전하고 예측가능하기 때문에

다음과 같이 `null 혹은 undefined` 를 구분하는 곳에서 유용하게 사용할 수 있습니다.

```jsx
/**
 * ✅ null 과 undefined 유무를 한번에 체크합니다.
 */
if (x == null) {
  // ...
}

/**
 * ❌ 다음과 같은 코드는 지양합니다.
 */
if (x === null || x === undefined) {
  // ...
}
```

**4️⃣  객체와 비객체의 비교**

```jsx
42 == [42]; // true
```

```markdown
x == y 를 수행할 때,

- Type(x) 가 String 또는 Number 이고 Type(y) 가 객체라면 x == ToPrimitive(y) 수행
- Type(x) 가 객체이고 Type(y) 가 String 또는 Number 라면 ToPrimitive(x) == Y 수행
```

### 암시적 강제 변환 안전하게 사용하기

그러면 `==` 연산자를 안전하게 사용할 수 있는 방법은 없을까요?

저자는 다음 2가지 규칙을 적용하면 안전하게 `==` 연산자를 사용할 수 있다고 제안하고 있습니다.

```markdown
1. 피연산자중 하나가 true / false 일 가능성이 있다면 절대 사용하지 말기
2. 피연산자중 하나가 [], " ", 0 일 가능성이 있다면 가급적 사용하지 말기
```

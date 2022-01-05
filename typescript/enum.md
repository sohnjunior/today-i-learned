# enum 과 const enum 차이점

### enum 과 const enum

`Typescript` 를 사용하다 보면 상수를 응집도 있게 관리하기 위해 

`enum` 으로 연관된 상수들을 함께 정의할 경우가 생깁니다.

이때 `enum` 으로 정의하거나 `const enum` 으로 정의할 때 

JS 로 트랜스파일 되는 결과물이 달라지기 때문에 사용 시 이 둘의 차이점을 아는 것이 중요합니다.

먼저 `enum` 으로 정의된 상수들은 실제 JS 로 트랜스파일 시 다음과 같이 변형됩니다.

```tsx
enum FRUITS {
    APPLE,
    ORANGE,
    BANANA
}
```

```tsx
"use strict";
var FRUITS;
(function (FRUITS) {
    FRUITS[FRUITS["APPLE"] = 0] = "APPLE";
    FRUITS[FRUITS["ORANGE"] = 1] = "ORANGE";
    FRUITS[FRUITS["BANANA"] = 2] = "BANANA";
})(FRUITS || (FRUITS = {}));
```

`const enum` 으로 정의된 상수들은 트랜스파일 결과 구현체는 사라지고 다음과 같이

해당 `enum` 을 사용한 곳에 값으로 치환됩니다.

```tsx
const enum FRUITS {
    APPLE,
    ORANGE,
    BANANA
}

console.log(FRUITS.APPLE)
```

```tsx
"use strict";
console.log(0 /* APPLE */);
```

## enum 을 사용해야 하는 경우는?

`enum` 은 `reverse mapping` 이 필요한 경우에만 사용하는 것이 좋습니다.

그 외의 경우에는 `const enum` 으로 대부분의 상황을 대응할 수 있습니다.

불필요한 코드가 추가되는 것을 막을 수 있고 무엇보다 `reverse mapping` 을 사용할 경우는

흔하지 않기 때문입니다.

```tsx
enum FRUITS {
    APPLE = 'APPLE',
    BANANA = 'BANANA'
}

const key = FRUITS.APPLE
const value = FRUITS[key]

console.log(value)
```

## 참고 자료

[const enum vs enum - HTML DOM](https://thisthat.dev/const-enum-vs-enum/)

[[TS] 8. enum vs const enum](https://jaeyeophan.github.io/2018/06/16/TS-8-enum-vs-const-enum/)

[Enum vs as const](https://velog.io/@logqwerty/Enum-vs-as-const)
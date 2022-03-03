# Object.defineProperty 에 대해서 알아보자

## 📌 Object.defineProperty?

`Vue 2.x` 라이브러리 소스를 보다보면 `Object.definePrototype` 으로

객체에 새로운 속성을 할당하는 것을 확인할 수 있습니다.

### Object.defineProperty() 의 특징

- 객체의 속성을 세밀하게 추가하거나 수정할 수 있습니다.
- 객체에 `getter / setter` 를 지정할 수 있습니다.
- `IE 9` 버전부터 지원합니다. (따라서 `Vue 2.x` 도 이 부분에 제약을 받습니다.)

## 📌 속성 서술자 (Property descriptor)

속성 서술자는 `데이터 서술자` 와 `접근자 서술자` 로 구성됩니다.

`Object.defineProperty` 에 사용하는 서술자는 두 유형중 하나여야합니다.

이 둘은 모두 객체로 다음의 선택적 키를 공유합니다.

- configurable : 객체 속성의 값 변경 및 삭제 가능 여부
- enumerable : 객체 속성 열거 시 노출 여부

### 데이터 서술자

데이터 서술자는 값을 가지는 속성을 정의할 때 사용합니다.

이는 다음 키를 선택적으로 포함합니다.

- value : 속성에 연관된 값
- writable : 할당 연산자 (`=`) 로 값을 바꿀 수 있는지 여부

### 접근자 서술자

접근자 서술자는 `getter, setter` 를 정의할 때 사용합니다.

이는 다음 키를 선택적으로 포함합니다.

- get : 접근자로 사용할 함수이며 이 속성에 접근 시 접근할 때 사용한 객체를 `this` 로 지정해서 매개변수 없이 호출합니다.
- set : 설정자로 사용할 함수이며 속성에 값을 할당할 때 사용한 객체를 `this` 로 지정해서 한 개의 매개변수와 함께 호출합니다.

## 📌 속성 생성 예시

### writable

해당 속성이 `false` 라면 값의 갱신이 불가차

만약 값을 갱신하려고 하면 무시됩니다.

```jsx
const ob = {};

Object.defineProperty(ob, "a", {
  value: 30,
  writable: false,
});

console.log(ob.a); // 30
ob.a = 50;
console.log(ob.a); // 30
```

### enumerable

`enumerable` 은 `Object.assign` 과 전개 연산자가 해당 속성을 열거할 수 있는지 결정합니다.

또한 `Symbol` 이 아닌 속성들에 대해서 `for in` 과 `Object.keys` 에서 추출 가능한지도 결정합니다.

```jsx
const ob = {};

Object.defineProperty(ob, "a", {
  value: 30,
  enumerable: false,
});
Object.defineProperty(ob, "b", {
  value: 50,
  enumerable: true,
});

console.log(Object.keys(ob)); // ['b']
```

### configurable

해당 특성을 사용하면 객체에서 해당 속성을 삭제 혹은 그 속성의 지정자를 변경할 수 있는지 결정합니다.

```jsx
const ob = {};

Object.defineProperty(ob, "a", {
  value: 30,
  configurable: false,
});

delete ob.a;
console.log(ob.a); // 30
```

### getter / setter

객체의 속성에 `getter / setter` 를 지정하면 각각 속성에서

값을 읽을 때와 쓸때 호출시킬 함수를 정의할 수 있습니다.해

```jsx
function AboutMe() {
  Object.defineProperty(this, "name", {
    get() {
      console.log("get name");
      return this.stored_name;
    },
    set(name) {
      console.log("set name");
      this.stored_name = name;
    },
  });
}

const info = new AboutMe();
info.name = "HandHand";
console.log(info.name);

/** 다음 실행 결과를 가집니다 */
set name
get name
HandHand
```

## 📌 참고 자료

[Object.defineProperty() - JavaScript | MDN](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty)

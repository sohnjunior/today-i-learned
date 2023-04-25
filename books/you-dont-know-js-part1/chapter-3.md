# [You Don’t Know JS] Chapter 3. 네이티브

## Native 객체

Javascript 에는 `native 객체` 라고 하는 내장 객체가 존재합니다.

이는 Javascript 환경에 영향을 받지 않는 ECMAScript 명세의 내장 객체입니다.

흔히 다음과 같은 것들이 native 객체입니다.

```jsx
String()
Number()
Boolean()
Array()
Object()
Function()
RegExp()
Date()
Error()
Symbol()
```

## 래퍼 박싱하기

Javascript 의 원시값에는 `.length` 나 `.toString()` 같은 프로퍼티나 메서드가 없습니다.

사실 우리가 이러한 속성 혹은 메서드에 접근할때는 엔진이 암묵적으로 래핑객체를 생성하는 것입니다.

```jsx
const a = 'abc'

a.length // 3
```

엔진이 효율적으로 래핑객체를 생성하기 때문에 굳이 직접 다음과 같이 선언하면서 사용할 필요는 없습니다.

```jsx
new String('abc')
```

## 래퍼 언박싱하기

박싱된 원시값은 `valueOf` 메서드로 추출할 수 있습니다.

이때 암묵적으로 언박싱이 일어납니다.

```jsx
const a = new String('abc')

a.valueOf() // 'abc'
```

## 네이티브 생성자

확실히 필요해서 사용하는 것이 아니라면, 생성자는 가급적 사용하지 않는 것이 좋습니다.

어떤 오류와 함정에 빠질지 모르는 일이기 때문입니다.

여러가지 네이티브 생성자 중에서 `Array` 에 대해서 살펴보겠습니다.

### Array

배열은 다음과 같이 `Array` 생성자를 이용해서 생성할 수 있습니다.

```jsx
const a = new Array(1, 2, 3)
```

Array 에는 특별한 형식이 있는데, 바로 인자로 숫자를 할당하는 것입니다.

```jsx
const a = new Array(3)
a // [비어 있음 x 3]
```

주의할 점은 `비어 있다` 는 것은 `undefined` 가 할당된 것과는 차이가 있다는 것입니다.

해당 배열로 `map` 이나 `join` 과 같은 연산을 수행할 때 예상치 못한 결과가 발생할 수 있습니다.

```jsx
const a = new Array(3)
const b = [undefined, undefined, undefined]

a.map((v, i) => i) // [비어 있음 x3]
b.map((v, i) => i) // [0, 1, 2]
```

📌 **undefined 로 채워진 배열 만드는 법**

빈 슬롯 말고 진짜 `undefined` 로 채워진 배열을 만들기 위해서는 다음과 같이 코드를 작성하면 됩니다.

```jsx
const a = Array.apply(null, { length: 3 })
```

### 네이티브의 프로토타입은 훌륭한 기본값이다?

변수에 적절한 값이 할당되지 않은 경우 기본값을 지정해주는 다음과 같은 코드를 자주 접하게 됩니다.

```jsx
function someFunc(val) {
	const a = val || []

	// ...
}
```

이때 저자는 `Function.prototype` 은 빈 함수, `RegExp.prototype` 은 빈 정규식, 

`Array.prototype` 은 빈 배열로써 훌륭한 기본 값으로 사용할 수 있다고 제안합니다.

```jsx
function someFunc(val) {
	const a = val || Array.protoype
	
	// ...
}
```

이를 통해 불필요하게 메모리를 사용하는 것을 최적화 할 수 있다고 하는데..

사실 여기에는 저 `Array.prototype` 을 수정하지 않는다는 전제가 따라야 합니다.

현업에서 위와 같은 방식으로 코드를 작성했을 경우 예상치 못한 결과로 이어질 수 있을 것 같아서

개인적으로는 극단적인 상황이 아니라면 활용하지는 않을 것 같습니다.
# [React] Hook API 가 무엇이고 왜 써야할까?

## 📌 React Hook!

`Vue` 만 사용하다가 `React` 를 처음 공부하다보니 대부분의 컴포넌트가 

`class` 기반이 아닌 `hook` 을 이용한 함수형 컴포넌트로 만들어지고 있는 것을 알게 되었습니다.

`React` 는 왜 이러한 방식을 선택하게 되었는지 궁금하여 

이와 관련된 몇가지 자료들을 찾아보고 정리해봤습니다 😄

## 📌 왜 Hook 을 사용해야 할까?

### 함수 단위의 독립된 재사용 가능한 로직 구현

`Component` 는 공통된 로직을 공유하는 좋은 방법이 될 수도 있지만 UI 요소를 렌더링 할 필요가 있습니다.

반면에 `Hook` 을 이용하면 재사용가능한 독립된 단위의 로직을 구성할 수 있게 됩니다.

### 재사용성을 위한 불필요한 컴포넌트 래핑 제거

`HOC` 나 `Render Props` 와 같은 복잡한 패턴으로 재사용 가능한 로직을 만들 경우 

컴포넌트 depth 가 깊어지며 불필요한 래핑이 발생할 수 있습니다.

`React Hook` 은 이러한 문제점들을 해결하기 위해 `state` 값과 같은 `React` 기능들을 

함수 내에서도 접근 가능하도록 하며 재사용 가능한 로직을 함수 단위로 구현 가능하도록 합니다.

또한 `Hook` 은 `함수` 이기 때문에 `React` 에서 기본적으로 제공하는 여러가지 `Hook` 들을 이용해서

개발자 자신만의 `Custom Hook` 들을 만들어 사용할 수 있습니다.

### 번들링 사이즈 최적화

또한 `Hook` 은 `Class` 로 작성된 컴포넌트보다 최적화에 용이하여 

번들링 사이즈를 보다 효과적으로 줄일 수 있습니다.

### 명확하고 읽기 좋은 컴포넌트

```jsx
function MyResponsiveComponent() {
	const width = useWindowWidth();
	return (
		<p>Window widht is {width}</p>
	)
}
```

`Hook` 을 사용한 컴포넌트는 보다 명확하게 해당 컴포넌트가 어떤 데이터를 활용하는지 알 수 있습니다.

위 컴포넌트의 경우 `window size` 값을 이용해서 화면을 다시 렌더링한다는 것을 쉽게 알 수 있습니다.

만약 재사용을 위해 `HOC` 나 `render props` 와 같은 패턴을 이용하거나 

라이프사이클 훅을 이용해서 해당 로직을 구현한다면 이보다 복잡한 형태로 구성될 것입니다.

## 📌 Hook 은 어떤식으로 동작할까?

### React Hook API 사용 시 규칙

`React` 공식 가이드를 살펴보면 `Hook` 사용 시 다음과 같은 규칙이 있다는 것을 알 수 있습니다.

- 최상위에서만 `Hook` 을 호출하세요 (반복문, 조건문 혹은 중첩된 함수 내에서는 ❌ )
- 오직 `React` 함수 내에서만 `Hook` 을 호출하세요

이중 첫번째 규칙을 지켜야 하는 이유가 무엇일까요?

이는 `Hook API` 가 내부적으로 구현된 방식에 따른 결과입니다.

### useState Hook 의 동작 방식

`useState` 는 다음과 같은 방법으로 사용됩니다.

```jsx
function RenderFunctionComponent() {
  const [firstName, setFirstName] = useState("Rudi");
  const [lastName, setLastName] = useState("Yardley");

  return (
    <Button onClick={() => setFirstName("Fred")}>Fred</Button>
  );
}
```

그렇다면 `React` 는 어떻게 각 컴포넌트의 상태값을 관리하는 `useState` Hook 을 제공할 수 있을까요?

이는 실제 `data` 와 이를 설정하는 `setter` 함수가 컴포넌트의 외부에서 관리되기 때문에 가능합니다.

위 코드를 기반으로 동작되는 순서는 다음과 같습니다.

**1️⃣  초기화 단계**

초기화 단계에서는 상태값과 변경 함수를 관리할 `state` 와 `setter` 배열을 생성합니다.

![1](https://user-images.githubusercontent.com/37819666/161369482-e0dac00c-629e-4afd-abc9-2be5fad71ad5.png)

**2️⃣  첫번째 렌더링**

이후 첫번째 렌더링 시 `cursor` 가 1씩 증가하며 각각의 `상태값` 과 `setter 함수` 를 생성합니다.

각각의 `setter 함수` 는 자신이 가리키고 있는 `state` 를 기억합니다.

![2](https://user-images.githubusercontent.com/37819666/161369485-f2a992f1-f02d-4626-bc00-b39be514b955.png)

**3️⃣  그 이후의 렌더링**

`cursor` 가 하나씩 증가하며 각각의 상태값과 setter 함수에 접근해 데이터를 가져옵니다.

![3](https://user-images.githubusercontent.com/37819666/161369487-0755b840-bfc2-4aa4-80ea-19111f07daa6.png)

**4️⃣  데이터 변경 시**

각각의 `setter` 함수는 자신이 가리키고 있는 `state` 를 기억하기 때문에

해당하는 데이터를 올바르게 수정할 수 있습니다.

![4](https://user-images.githubusercontent.com/37819666/161369488-95177133-b58e-4c1a-aeb1-e2f35b59daa9.png)

### useState 의 내부 구현 방식

```jsx
let state = [];
let setters = [];
let firstRun = true;
let cursor = 0;

function createSetter(cursor) {
  return function setterWithCursor(newVal) {
    state[cursor] = newVal;
  };
}

// This is the pseudocode for the useState helper
export function useState(initVal) {
  if (firstRun) {
    state.push(initVal);
    setters.push(createSetter(cursor));
    firstRun = false;
  }

  const setter = setters[cursor];
  const value = state[cursor];

  cursor++;
  return [value, setter];
}

// Our component code that uses hooks
function RenderFunctionComponent() {
  const [firstName, setFirstName] = useState("Rudi"); // cursor: 0
  const [lastName, setLastName] = useState("Yardley"); // cursor: 1

  return (
    <div>
      <Button onClick={() => setFirstName("Richard")}>Richard</Button>
      <Button onClick={() => setFirstName("Fred")}>Fred</Button>
    </div>
  );
}
```

### Hook 호출 순서가 중요한 이유

이러한 `Hook` 동작 방식때문에 만약 다음과 같이 특정 조건에서만 `Hook` 을 호출할 경우 문제가 됩니다.

```jsx
let firstRender = true;

function RenderFunctionComponent() {
  let initName;
  
  if(firstRender){
    [initName] = useState("Rudi");
    firstRender = false;
  }
  const [firstName, setFirstName] = useState(initName);
  const [lastName, setLastName] = useState("Yardley");

  return (
    <Button onClick={() => setFirstName("Fred")}>Fred</Button>
  );
}
```

이 경우 첫번째 렌더링 단계에서는 3개의 `useState` 가 사용되어 

각각 `state` 와 `setter` 배열에 설정되기때문에 이후 렌더링에서 호출 순서가 바뀌게 되면

엉뚱한 데이터에 접근해 설정을 하는 버그가 발생할 수 있습니다.

## 📌 참고자료

[Making Sense of React Hooks](https://medium.com/@dan_abramov/making-sense-of-react-hooks-fdbde8803889)

[React hooks: not magic, just arrays](https://medium.com/@ryardley/react-hooks-not-magic-just-arrays-cd4f1857236e)

[Hook의 규칙 - React](https://ko.reactjs.org/docs/hooks-rules.html)
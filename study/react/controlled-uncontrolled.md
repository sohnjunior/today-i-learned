# [React] controlled vs uncontrolled component

## 📌 비제어 컴포넌트 (uncontrolled component)

`비제어 컴포넌트` 에서 폼 데이터는 DOM 자체에 저장됩니다.

만약 해당 폼 데이터를 읽어오고 싶다면 `ref` 를 이용해서 **값을 `PULL` 해와서** 사용합니다.

```jsx
import React, { useRef } from 'react'

const UnControlledComponent = () => {
  const inputRef = useRef(null)

  const handleClick = () => {
    /** input 값으로 특정 로직을 수행합니다. */
    console.log(inputRef.current.value)
  }

  return (
    <div>
      <input type="text" ref={inputRef} />
      <button onClick={handleClick} >확인</button>
    </div>
  )
}

export default UnControlledComponent
```

## 📌 제어 컴포넌트 (controlled component)

`제어 컴포넌트` 는 보다 `React스러운 방법` 으로 값을 제어합니다.

`React` 컴포넌트의 상태값을 `신뢰 가능한 단일 출처 (single source of truth)` 로 만들어 사용합니다.

폼 입력 컴포넌트의 `value` 가 해당 컴포넌트의 `state` 에서 관리되며 동기화되는 방식입니다.

```jsx
import React, { useState } from 'react'

const ControlledComponent = () => {
  const [ name, setName ] = useState('')

  const handleChange = (event) => {
    setName(event.target.value )
  }

  return (
    <div>
      <input type="text" value={name} onChange={handleChange} />
    </div>
  )
}

export default ControlledComponent
```

입력값에 변화가 생길때마다 `handleChange` 함수가 호출되어 상태값이 변화하고

이때문에 리렌더링이 발생해 새로운 상태값이 `input` 요소에 바인딩 되는 것입니다.

이렇게 **새로운 값을 `PUSH` 하는 방식**으로 구현하는 폼 엘리먼트를 `제어 컴포넌트` 라고 하며 

주로 입력값의 즉각적인 변화에 대응하는 로직을 수행해야 하는 경우에 사용됩니다.

```markdown
*  입력값 검증 (형식 및 값 유효성 검사)
*  유효한 값인지 검증 후 버튼 활성화 등의 상황
```

## 📌 둘 중 어느것을 사용해야할까?

`useRef` 를 통해 비제어 컴포넌트를 만들어 사용하는 것이 무조건 나쁜 것은 아닙니다.

때에 따라서는 가볍고 간단한 폼 엘리먼트를 만들기 위해 비제어 컴포넌트를 사용하는 것이 유용할 수도 있습니다.

이와 관련해서 다음과 같이 어떤 경우에 `제어 혹은 비제어 컴포넌트` 를 사용해야할지 

지표가 될 수 있는 자료가 있어서 참고하여 활용하면 될 것 같습니다.

![1](https://user-images.githubusercontent.com/37819666/161369274-c8070f92-c05f-4978-ad31-83a4b0b6e022.png)


## 📌 참고자료

[폼 - React](https://ko.reactjs.org/docs/forms.html#controlled-components)

[Controlled and uncontrolled form inputs in React don't have to be complicated - Gosha Arinich](https://goshacmd.com/controlled-vs-uncontrolled-inputs-react/)
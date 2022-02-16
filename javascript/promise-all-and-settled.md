# Promise.all vs Promise.allSettled

## Promise.all 을 사용해야 하는 경우는?

회사에서 API 호출 로직을 작성하다가 비동기 병렬 처리를 위해 다음과 같이 코드를 작성했었습니다.

```jsx
try {

	await Promise.all([
		fetchMySomeDataAsync(),
		fetchMyAnotherDataAsync(),
	])

	// ...
} 
```

두 비동기 함수를 병렬로 실행하고 싶을 때 위 처럼 작성하는 것이 맞을까요?

문제는 다음과 같은 상황에서 발생했습니다.

`***A` 라는 함수와 `B` 라는 함수를 병렬로 실행하지만,*** 

***두 함수가 각각의 성공 및 실패 유무가 연관이 없을 경우***

`Promise.all` 은 병렬로 실행한 함수 중 어느 하나라도 실패한다면 `error` 로 처리됩니다.

```jsx
try {
    const promise1 = Promise.resolve(1);
    const promise2 = new Promise((resolve, reject) => {
      setTimeout(() => resolve("resolve"), 7000);
    });
    const promise3 = new Promise((resolve, reject) => {
      setTimeout(() => reject("reject"), 3000);
    });
    
    const response = await Promise.all([promise1, promise2, promise3]);
    console.log('성공', response)
  } catch (err) {
    console.error('에러', err)
  }
```

때문에 실제로 병렬 처리되는 함수들끼리 서로 연관이 없다면, `Promise.all` 로 묶는 것은

개발자가 기대한 것과는 다른 방식으로 동작하게 됩니다.

따라서 `Promise.all` 은 다음과 같은 경우에 사용하는 것이 좋습니다.

***다음 코드를 실행하기 전에 서로 연관된 비동기 작업을 모두 이행되어야 함을 보장해야하는 경우***

## Promise.allSettled 에 대해서

실제로 제가 기대했던 동작은 `Promise.allSettled` 를 통해 구현할 수 있었습니다.

`ES2020` 에서 새롭게 추가된 이 비동기 처리 방식은 주로 

`서로의 성공 여부와 관련이 없는 비동기 작업들을 병렬로 수행` 할 때 사용합니다.

```jsx
try {
    const promise1 = Promise.resolve(1);
    const promise2 = new Promise((resolve, reject) => {
      setTimeout(() => resolve("resolve"), 7000);
    });
    const promise3 = new Promise((resolve, reject) => {
      setTimeout(() => reject("reject"), 3000);
    });
    
    const response = await Promise.allSettled([promise1, promise2, promise3]);
    console.log('성공', response)
  } catch (err) {
    console.error('에러', err)
  }
```

`allSettled` 는 각 비동기 호출별로 응답결과를 배열에 담아 반환받습니다.

위 코드를 실행하면 `response` 로 다음과 같은 응답 결과를 얻을 수 있습니다.

```jsx
[
  { status: 'fulfilled', value: 1 },
  { status: 'fulfilled', value: 'resolve' },
  { status: 'rejected', reason: 'reject' }
]
```

`status` 를 통해 호출의 성공 유무를 판단할 수 있고

성공시에는 `value` , 실패시에는 `reason` 으로 어떻게 이행 또는 거부되었는지 확인이 가능합니다.

## 참고 자료
[Promise.all() - JavaScript | MDN](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Promise/all)  
[Promise.allSettled() - JavaScript | MDN](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Promise/allSettled)

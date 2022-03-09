# JavaScript 의 sort 함수는 안정 정렬일까?

## 📌 안정 정렬이란?

`안정 정렬(stable sort)` 은 동일한 키 값에 대해 입력 순서를 보장하는 정렬 알고리즘입니다.

그 반대인 `불안정 정렬(unstable sort)` 은 정렬 후 입력 순서를 보장해주지 않습니다.

대표적인 `안정 정렬` 알고리즘은 다음과 같이 3가지가 있습니다.

### 버블 정렬 (Bubble Sort)

![1](https://user-images.githubusercontent.com/37819666/157436339-8c9b8241-b256-4ef5-8a26-29bc941392e3.gif)

### 삽입 정렬 (Insertion Sort)

![2](https://user-images.githubusercontent.com/37819666/157436351-12a0ce1d-fdf9-4428-b2dc-6cddc1160a1d.gif)

### 병합 정렬 (Merge Sort)

![3](https://user-images.githubusercontent.com/37819666/157436362-f937177a-dbaf-40af-91a1-dc39e6198cca.gif)

**그 외 `퀵 정렬` 과 `선택 정렬` 은 `불안정 정렬` 의 대표적인 알고리즘입니다.**

## 📌 JavaScript 의 sort 함수

### JavaScript 의 sort 함수는 안정 정렬일까?

`JavaScript` 의 `sort` 함수는 그렇다면 `안정 정렬` 일까요?

Chrome 70 버전 이전에서는 사실 `JavaScript` 의 구현 스펙상 안정 정렬을 강요하지 않았다고 합니다.

때문에 각각의 엔진 구현체마다 정렬 방식이 다르게 되어있으며 `chrome` 의 경우에는 배열의 길이에 따라

안정 정렬일 수도 있고 불안정 정렬일 수도 있었다고 합니다.

하지만 `chrome 70` 이후 버전부터는 `Array.sort` 를 안정 정렬로 구현하도록 스펙이 지정되었고

그에 따라 모든 브라우저에서 안정 정렬임을 보장할 수 있게 되었다고 합니다.

### Chrome 70 이전 시절 정렬 알고리즘

다음은 `chrome 70` 이전의 V8 엔진 정렬 알고리즘 소스코드입니다.

```jsx
// v8/array.js

/**
 * ✅ Array.prototype.sort 를 정의합니다.
 */
DEFINE_METHOD(
  GlobalArray.prototype,
  sort(comparefn) {
    if (!IS_UNDEFINED(comparefn) && !IS_CALLABLE(comparefn)) {
      throw %make_type_error(kBadSortComparisonFunction, comparefn);
    }

    var array = TO_OBJECT(this);
    var length = TO_LENGTH(array.length);
    return InnerArraySort(array, length, comparefn);
  }
);

/**
 * ✅ 실제 정렬을 수행하는 함수입니다.
 */
function InnerArraySort(array, length, comparefn) {
  // In-place QuickSort algorithm.
  // For short (length <= 10) arrays, insertion sort is used for efficiency.

  if (!IS_CALLABLE(comparefn)) {
    comparefn = /** 기본 비교 함수 할당 */
  }

  function InsertionSort(a, from, to) {/** */};

  function QuickSort(a, from, to) {
		// ...

		while (true) {
      // Insertion sort is faster for short arrays.
      if (to - from <= 10) {
        InsertionSort(a, from, to);
        return;
      }

		// ...
  };

  if (length < 2) return array;

  QuickSort(array, 0, num_non_undefined);

  return array;
}
```

코드를 보면 `Array.prototype.sort` 는 엔진 내부적으로 `InnerArraySort` 함수를 호출하고

해당 함수 내에서 배열의 길이가 `10` 보다 작을 경우에는 `Insertion Sort` 를 사용하고

그 외에는 `Quick Sort` 를 사용하는 것을 알 수 있습니다.

### 이후의 v8 엔진은 `Timsort` 알고리즘을 사용해서 정렬합니다

`stable` 함을 보장하기 위해서 현재 `v8` 엔진은 `TimSort` 알고리즘을 이용해 정렬을 수행합니다.

다음은 현재 `v8` 엔진 소스의 정렬 알고리즘 코드입니다.

`ArrayTimSort` 를 호출해서 `stable` 한 정렬 결과를 반환하는 것을 확인할 수 있습니다.

```jsx
// third_party/v8/builtins/array-sort.tq

ArrayPrototypeSort(
    js-implicit context: NativeContext, receiver: JSAny)(...arguments): JSAny {
  // ...

  if (len < 2) return obj;

  const sortState: SortState = NewSortState(obj, comparefn, len);
  ArrayTimSort(context, sortState);

  return obj;
}
```

## 📌 Chrome 70 이전에 안정정렬을 구현했던 방법

안정 정렬을 구하는 가장 쉬운 방법은 각 배열 요소에 `key` 값을 오름차순으로 지정하는 것입니다.

```jsx
const stableSort = (arr, compare) =>
  arr
    .map((item, index) => ({ item, index }))
    .sort((a, b) => compare(a.item, b.item) || a.index - b.index)
    .map(({ item }) => item)
```

이렇게 하면 두 배열 요소의 비교 키값이 동일한 경우에는 인덱스로 비교하기 때문에 순서를 보장할 수 있습니다.

위 함수를 이용해서 정렬을 수행하면 다음과 같은 결과를 얻을 수 있습니다.

```jsx
/** ✅ rating 을 기준으로 정렬을 수행합니다. */
console.log(
  stableSort(
    [
      { name: "Abby", rating: 12 },
      { name: "Bandit", rating: 13 },
      { name: "Choco", rating: 14 },
      { name: "Daisy", rating: 12 },
      { name: "Elmo", rating: 12 },
      { name: "Falco", rating: 13 },
      { name: "Ghost", rating: 14 },
    ],
    (a, b) => a.rating - b.rating
  )
)[
  /** 그러면 다음과 같은 정렬 결과를 얻을 수 있습니다. */
  ({ name: "Abby", rating: 12 },
  { name: "Daisy", rating: 12 },
  { name: "Elmo", rating: 12 },
  { name: "Bandit", rating: 13 },
  { name: "Falco", rating: 13 },
  { name: "Choco", rating: 14 },
  { name: "Ghost", rating: 14 })
]
```

## 📌 참고 자료

[Stable Array.prototype.sort](https://v8.dev/features/stable-sort)

[Fast stable sorting algorithm implementation in javascript](https://stackoverflow.com/questions/1427608/fast-stable-sorting-algorithm-implementation-in-javascript)

# Typescript의 유틸리티 타입에 대해서

## Typescript 유틸리티 타입

`Typescript` 에서는 공통 타입 변환을 용이하게 하기 위해서 `유틸리티 타입` 을 제공합니다.

이 유틸리티 타입들은 전역으로 사용이 가능합니다.

## Typescript 에서 제공하는 유틸리티 타입들

### Partial<T>

`T` 의 모든 프로퍼티를 선택적으로 가지는 타입을 생성합니다.

```tsx
interface ICoffee {
    name: string;
    isDeCaffein: boolean;
    roasting: string;
    taste: string;
}

type SpecialCoffee = Partial<ICoffee>

/**
type SpecialCoffee = {
    name?: string | undefined;
    isDeCaffein?: boolean | undefined;
    roasting?: string | undefined;
    taste?: string | undefined;
}
 **/
```

### Readonly<T>

`T` 의 모든 프로퍼티를 `읽기 전용` 으로 설정한 타입을 구성합니다.

이를 통해 이미 생성된 프로퍼티에 재할당이 불가능하도록 할 수 있습니다.

```tsx
interface IDinnerMenu {
    name: string;
}

const myDinnerMenu: Readonly<IDinnerMenu> = { name: 'sandwich' }

myDinnerMenu.name = 'chicken' // Cannot assign to 'name' because it is a read-only property.
```

### Required<T>

타입 `T` 의 모든 프로퍼티를 필수값으로 바꿉니다.

```tsx
interface Props {
    a?: number;
    b?: string;
};

const obj: Required<Props> = { a: 5 }; // 오류: 프로퍼티 'b'가 없습니다
```

### Record<K, T>

타입 `T` 의 프로퍼티의 집합 `K` 로 타입을 구성합니다.

해당 유틸리티 타입은 매핑된 타입을 만들 때 유용합니다.

```tsx
interface IContents {
    name: string
}

type Program = 'movie' | 'drama' | 'music'

const x: Record<Program, IContents> = {
    movie: { name: 'a' },
    drama: { name: 'b' },
    music: { name: 'c' },
}
```

### Pick<T, K>

타입 `T` 에서 타입 `K` 의 집합으로 구성된 타입을 생성합니다.

```tsx
interface ITodo {
    title: string;
    description: string;
    completed: boolean;
}

type TodoPreview = Pick<ITodo, 'title' | 'completed'>;

const todo: TodoPreview = {
    title: 'Clean room',
    completed: false,
};
```

### Omit<T, K>

타입 `T` 중에서 타입 `K` 를 제거한 타입을 생성합니다.

```tsx
interface ITodo {
    title: string;
    description: string;
    completed: boolean;
}

type TodoPreview = Omit<ITodo, 'title' | 'completed'>;

const todo: TodoPreview = {
    description: 'laundry'
};
```

### Exclude<T, U>

`Omit` 과 유사한 기능을 하지만 `Exclude` 의 경우 

유니온 타입 `T` 에서 타입 `U` 에 할당 가능한 모든 타입을 제외한 타입을 생성합니다.

```tsx
interface ITodo {
    title: string;
    description: string;
    completed: boolean;
}

interface IWishList {
    description: string;
}

type TodoPreview = Exclude<ITodo | IWishList, ITodo>; // IWishList
```

[TIL: Difference between Omit and Exclude in TypeScript](https://iamshadmirza.com/difference-between-omit-and-exclude-in-typescript)

[Typescript: What's the Difference between Omit and Exclude?](https://medium.com/@nlemast/typescript-whats-the-difference-between-omit-and-exclude-6d0559ac7c5c)

### Extract<T, U>

타입 `T` 에서 타입 `U` 에 할당 할 수 있는 모든 속성들을 추출해서 타입을 구성합니다.

```tsx
type T0 = Extract<"a" | "b" | "c", "a" | "f">;  // "a"
type T1 = Extract<string | number | (() => void), Function>;  // () => void
```

### NonNullable<T>

타입 `T` 에서 `null` 과 `undefined` 를 제외한 타입을 구성합니다.

```tsx
type T0 = NonNullable<string | number | undefined>;  // "a"
type T1 = NonNullable<(() => void) | undefined>;  // () => void
```

### Parameters<T>

함수 타입 `T` 에서 매개변수들을 추출해서 튜플타입을 구성합니다.

```tsx
declare function f1(arg: { a: number, b: string }): void

type T0 = Parameters<() => string>;  // []
type T1 = Parameters<(s: string) => void>;  // [string]
type T2 = Parameters<(<T>(arg: T) => T)>;  // [unknown]
type T3 = Parameters<typeof f1>;  // [{ a: number, b: string }]
```

`ConstructorParameters<T>` 타입도 있는데 

이는 생성자 함수 타입의 모든 매개변수들의 튜플 타입을 반환합니다.

### ReturnType<T>

함수 `T` 의 리턴 타입으로 구성된 타입을 생성합니다.

```tsx
declare function f1(): { a: number, b: string }

type T0 = ReturnType<() => string>;  // string
type T1 = ReturnType<(s: string) => void>;  // void
type T2 = ReturnType<typeof f1>;  // { a: number, b: string }
```

 

### InstanceType<T>

생성자 함수 타입인 `T` 의 인스턴스 타입으로 구성된 타입을 생성합니다.

```tsx
class C {
    private x = 0;
    private y = 0; 

    constructor(a: number, b: number) {
        this.x = a;
        this.y = b;
    }

    public sample() {
        console.log('aa')
    }
}

type T0 = InstanceType<typeof C>;  // C
```
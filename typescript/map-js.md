# TypeScript 컴파일 시 생성되는 js.map 파일

## 📌 [js.map](http://js.map) 파일?

타입스크립트로 작성된 파일을 실행시키기 위해서는 먼저 `tsc` 로 컴파일을 해야하는데

이때 `tsconfig.json` 에 `source-map` 설정을 했다면 `[js.map](http://js.map)` 이라는 파일도 함께 생성됩니다.

먼저 `tsconfig.json` 에 다음과 같이 `source map` 설정을 합니다.

```json
"compilerOptions": {
	"sourceMap": true,
},
```

그리고 다음과 같은 타입스크립트 예시 코드를 작성합니다.

```tsx
interface Animal {
  name: string;
}

function callAnimal(animal: Animal) {
  console.log(animal);
}

const animal: Animal = { name: "aa" };
debugger;
callAnimal(animal);
```

마지막으로 `tsc` 로 컴파일 하면 다음과 같이

`index.js` 와 `[index.js.map](http://index.js.map)` 두 개의 파일이 생성되는 것을 확인할 수 있습니다.

```markdown
/dist
ㄴ index.js
ㄴ index.js.map
```

그럼 여기서 `[js.map](http://js.map)` 파일의 용도는 무엇일까요?

## 📌 [js.map](http://js.map) 파일의 구성 및 용도

### 어떻게 구성된 파일인가요?

먼저 `[js.map](http://js.map)` 파일이 어떻게 구성되어있는지 확인해보겠습니다.

```jsx
{
  "version": 3,
  "file": "index.js",
  "sourceRoot": "",
  "sources": [
    "../src/index.ts"
  ],
  "names": [],
  "mappings": ";AAIA,SAAS,UAAU,CAAC,MAAc;IAChC,OAAO,CAAC,GAAG,CAAC,MAAM,CAAC,CAAC;AACtB,CAAC;AAED,MAAM,MAAM,GAAW,EAAE,IAAI,EAAE,IAAI,EAAE,CAAC;AACtC,QAAQ,CAAC;AACT,UAAU,CAAC,MAAM,CAAC,CAAC"
}
```

`JSON` 형식으로 작성된 `[js.map](http://js.map)` 파일의 각 속성별 용도는 다음과 같습니다.

- version : 사용된 `source map` 의 스펙 버전입니다.
- file : 해당 `map` 파일이 참조하고 있는 `JS` 파일입니다.
- sourceRoot : 컴파일한 `TS` 파일들의 루트 디렉토리를 지정합니다.
- sources : 컴파일한 `TS` 파일들의 목록입니다.
- names : 컴파일 후 `output` 에서 제거되거나 변경된 식별자에 대한 정보를 담고 있습니다.
- mappings : `base64` 인코딩된 문자열로 `TS` 파일과 `JS` 파일 사이의 매핑 정보를 담고 있습니다.

### 그럼 이 파일이 왜 필요한 것인가요?

![1](https://user-images.githubusercontent.com/37819666/156924836-1d3e4a9c-665e-41a1-872b-1cfa726e21ab.png)

컴파일된 자바스크립트 코드는 `minify` 와 `uglify` 등의 과정을 거쳐 읽기 힘든 형태로 존재합니다.

이 경우 디버깅을 할 시 해석 불가능한 코드 때문에 어려움이 존재하기 때문에 개발 시 편의성을 위해

컴파일 되기 전의 타입스크립트 코드와의 매핑 파일이 존재하는 것입니다.

## 📌 참고 자료

[What is a TypeScript Map file?](https://stackoverflow.com/questions/17493738/what-is-a-typescript-map-file)

[Emitting TypeScript Source Maps](https://www.carlrippon.com/emitting-typescript-source-maps/)

[An Introduction to Source Maps [Article] | Treehouse Blog](https://blog.teamtreehouse.com/introduction-source-maps)

[What is TypeScript Map file ? - GeeksforGeeks](https://www.geeksforgeeks.org/what-is-typescript-map-file/)

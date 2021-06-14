# Javascript 최적화

## Javascript 최적화의 필요성

### 최근 웹앱의 흐름

최근의 웹앱은 그 규모가 커짐에 따라 스크립트의 비중이 점점 커지고 있습니다.

현재 날짜를 기준 데스크탑과 모바일 기기에서 사용되는 Javascript 의 크기는 각각

475KB, 449KB 입니다.

[HTTP Archive: State of JavaScript](https://httparchive.org/reports/state-of-javascript#bytesJs)

비록 네트워크 통신 과정에서 압축 과정을 거치기 때문에 전송에 필요한 비용은 줄일 수 있지만

사실 `Parser` 와 `Compiler` 는 압축을 해제한 상태의 스크립트 파일을 사용하기 때문에

실행에 드는 비용을 절약할 수는 없습니다.

### Javascript 의 실행 비용

![1](https://user-images.githubusercontent.com/37819666/121900292-3da96c00-cd60-11eb-8d04-3346b477e250.png)


`자바스크립트는 실행 비용이 비쌉니다.` 

이는 단순히 다운로드를 하는 이미지와는 다르게 스크립트 소스를 네트워크를 통해 다운도르 받고

파싱을 한뒤 컴파일을 해서 실행하기 때문입니다.

### Javascript 성능 개선을 위한 방안

`Javascript` 성능 개선을 위해 몇가지 방안이 존재하는데 그 중 하나는 `code splitting` 입니다.

큰 번들 사이즈를 가지는 스크립트를 `chunk` 로 나누어서 불러와 사용하는 것입니다.

하지만 이 방법은 문제의 근원인 `번들 사이즈` 자체를 줄여주지는 않습니다.

이때 사용할 수 있는 방법이 바로 `tree shaking` 으로 사용하지 않는 스크립트를 

최종 번들에서 제거하는 것입니다.

## Tree Shaking 이란?

ES6 이후부터 `import export` 문을 통해서 JS 모듈의 의존성을 부여할 수 있게 되었습니다.

여기서 각각의 모듈의 의존성이 마치 각 모듈을 노드로 하는 트리 형태를 띄어 

사용하지 않는 모듈을 제거하는 것을 `tree shaking` 이라고 부르게 되었습니다.

```jsx
import { some, unique, items } from 'utils' 
```

만약 위와 같이 모듈에서 필요한 함수들만 불러와서 사용할 경우 `dev` 모드로 빌드할 경우에는

`utils` 의 모든 함수들을 불러와 빌드하지만 `production` 모드에서는 `webpack` 을 이용해서 

불필요한 함수는 제거하여 빌드 사이즈를 최적화 할 수 있습니다.

### Babel 과 Tree Shaking

`Babel` 을 사용하면 ES6 모듈을 CommonJS 모듈로 트랜스파일 할 수 있습니다.

`Tree Shaking` 을 적용하기 위해서는 `ES6` 모듈을 사용해야하기 때문에

만약 `babel-preset-env` 를 사용할 경우 다음과 같은 설정을 통해 트랜스파일을 막을 수 있습니다.

```jsx
{
  "presets": [
    ["env", {
      "modules": false
    }]
  ]
}
```

### Side Effect

사용하지 않는 코드라도 `Tree Shaking` 이 적용되지 않는 경우가 있습니다.

이는 해당 모듈에서 `Side Effect` 가 예상되기 때문인데, 다음 블로그를 참고합니다.

[webpack에서 Tree Shaking 적용하기](https://medium.com/naver-fe-platform/webpack%EC%97%90%EC%84%9C-tree-shaking-%EC%A0%81%EC%9A%A9%ED%95%98%EA%B8%B0-1748e0e0c365)

모듈이 `Side Effect` 를 발생시키지 않는다고 명시할 수도 있는데 이는 `package.json` 에

`sideEffects` 를 `false` 로 설정하면 됩니다.

```jsx
{
	"name": "example-module",
	"version": "0.0.1",
	"sideEffects": false
}
```

## 참고 자료

[Reduce JavaScript Payloads with Tree Shaking | Web Fundamentals](https://developers.google.com/web/fundamentals/performance/optimizing-javascript/tree-shaking)

[Webpack 4의 Tree Shaking에 대한 이해](https://huns.me/development/2265)
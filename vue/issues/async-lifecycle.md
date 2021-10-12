# 비동기 요청으로 상태를 초기화할때 어떤 라이프사이클을 사용할까?

## 비동기 요청을 위한 최적의 라이프사이클은?

Vue 를 사용하면서 항상 고민했었습니다.

비동기로 데이터를 가져올 때 어떤 라이프사이클 훅에서 이를 처리해야 할까?

많은 Vue 사용자들이 `created` 에서 이를 처리하여서 저 또한 막연히 이를 따랐는데

Vue 의 라이프사이클을 정리하면서 이에 대한 구체적인 근거를 찾고 싶었습니다.

찾아보니 이게 정답이다! 하는 건 없었지만 그중 가장 납득이 될만한 근거를 가지는 자료를 찾았습니다.

## Vue 사용자들의 보편적인 의견

해외의 다른 개발자분도 저와 같은 고민을 하셨고 다음과 같은 근거로 `created` 훅을 사용했습니다.

1. 비동기 요청을 `beforeCreate, created, beforeMount` 어디에서 호출하더라도 
    
    `mounted` 이후에 실제로 비동기 요청이 처리된다.
    
    ```tsx
    new Vue({
      el: '#app',
      beforeCreate() {
        setTimeout(() => { console.log('fastest asynchronous code ever') }, 0);
        console.log('beforeCreate hook done');
      },
      created() {
        console.log('created hook done');
      },
      beforeMount() {
        console.log('beforeMount hook done');
      },
      mounted() {
        console.log('mounted hook done');
      }
    })
    
    // 위 컴포넌트를 테스트해보면 다음과 같이 콘솔에 찍힙니다.
    beforeCreate hook done
    created hook done
    beforeMount hook done
    mounted hook done
    fastest asynchronous code ever
    ```
    
    이는 결국 어느 라이프사이클 훅에서 호출하던 값을 받아오게되는 시점이 
    
    `mounted` 훅이 호출된 이후라는 것을 의미합니다.
    

1. 상태값은 `beforeCreate` 와 `created` 사이에서 초기화된다.
    
    위에서 살펴봤듯이 컴포넌트의 상태값은 이 두 라이프사이클 사이에서 초기화되기 때문에
    
    비동기로 값을 가져와 상태에 설정해야 한다면 `created` 훅이 가장 빠른 라이프사이클이 됩니다.
    

이외에도 작성자는 단순히 가장 빠르게 호출하기만 하면 될 경우에는 

`beforeCreate` 를 사용하도록 권장합니다.

[Which VueJS lifecycle hook must Asynchronous HTTP requests be called in?](https://stackoverflow.com/questions/49577394/which-vuejs-lifecycle-hook-must-asynchronous-http-requests-be-called-in)
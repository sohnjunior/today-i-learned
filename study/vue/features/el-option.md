# Vue 의 el 옵션은 무엇일까?

## Vue 의 el 옵션이란

Vue 라이프 사이클 공부하다가 생소한 `el` 옵션이 튀어나와서 한번 찾아봤습니다.

`el` 옵션은 Vue 컴포넌트에서 제공하는 옵션으로 `마운팅 포인트를 결정` 할 수 있습니다.

단 `el` 옵션은 `new` 를 통한 Vue 인스턴스 생성시에만 유효합니다.

## el 옵션 사용 예시

```tsx
<html>
  <head>
    <title>vue el example</title>
    <script src="https://unpkg.com/vue/dist/vue.min.js"></script>
  </head>
  <body>
	  <p id="mess">{{message}}</p>
	  
		<script>
	  
		  new Vue({
		    el:'#mess',
		    data: {
		      message:'an element can be selected by id with the # symbol'
		    }
		  });
	  
	  </script>
  </body>
</html>
```

`el` 에는 `querySelector` 와 같이 지정할 수 있으며 지정된 요소에 Vue 컴포넌트가 대체됩니다.

만약 `template` 옵션이나 `render` 함수가 없다면 지정된 DOM 요소 내부 내용이 렌더링 됩니다.

위 예시의 경우 `message` 내용이 `p` 태그에 둘러싸여 렌더링 되겠네요.

## $mount 메서드란?

`el` 옵션을 사용하는 대신 `$mount` 옵션을 사용할 수도 있습니다.

```tsx
<html>
  <head>
    <title>vue el example</title>
    <script src="https://unpkg.com/vue/dist/vue.min.js"></script>
  </head>
  <body>
	  <div id="foo">
	  
		<script>
	  
			new Vue({
			     template:'<p>bar</p>',
			     beforeCreate: function() {
             console.log('beforeCreate')
           },
           
           created: function(){
             console.log('created')
             setTimeout(() => {
               this.$mount('#foo')
             }, 5000)
			     },

           beforeMount: function() {
             console.log('beforeMount')
           },

           mounted: function() {
             console.log('mounted')
           }
			  })
	  
	  </script>
  </body>
</html>
```

만약 특정한 목적으로 마운트 시점을 늦출경우 `$mount` 메서드를 사용할 수 있습니다.

컴포넌트에 `el` 옵션을 명시하지 않으면 컴파일이 중단되기 때문에 `$mount` 메서드를 통해서

직접 마운트 포인트를 지정해주어 컴파일이 진행될 수 있도록 해야합니다.

위 예제에서는 5초후에 마운트 포인트가 지정되고, 라이프사이클에 따라 `$mount` 가 호출된 이후

`beforeMount` 와 `mounted` 가 호출됩니다.

## 참고자료

[vue el option for selecting a vuejs DOM mount point](https://dustinpfister.github.io/2019/05/06/vuejs-el/)

[API - Vue.js](https://vuejs.org/v2/api/#el)
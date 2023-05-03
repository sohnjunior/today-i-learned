# Vue 의 라이프 사이클

Vue 2.x 를 이용한 사내 프로젝트 진행 중 Vue 라이프 사이클에 대한 내용을 찾아볼 기회가 있었는데

이번 기회에 찾아서 공부한 내용을 정리해놓으면 좋을 것 같아서 글을 작성하게 되었습니다.

이번 Vue 라이프사이클은 2.x 버전을 기준으로 합니다.

## Vue 의 라이프사이클 한눈에 보기

Vue 공식 홈페이지에 들어가면 다음과 같은 다이어그램이 존재합니다.

![lifecycle](https://user-images.githubusercontent.com/37819666/136973994-81062ab8-a7c5-40de-b39f-ad7de7924898.png)

Vue 에서는 개발자가 라이프사이클을 활용할 수 있도록 몇가지 `라이프사이클 훅` 을 제공합니다.

위 다이어그램에 명시된 훅들을 하나씩 살펴보겠습니다.

## Vue 의 라이프사이클 훅

### beforeCreate

가장 먼저 실행되는 훅으로 Vue 인스턴스의 이벤트 및 라이프 사이클이 초기화된 직후 호출됩니다.

```tsx
// src/core/instance/init.js

export function initMixin (Vue: Class<Component>) {
  Vue.prototype._init = function (options?: Object) {
    const vm: Component = this
    // a uid
    vm._uid = uid++

		// ...

		// expose real self
    vm._self = vm
    initLifecycle(vm)
    initEvents(vm)
    initRender(vm)
    callHook(vm, 'beforeCreate')
    initInjections(vm) // resolve injections before data/props
    initState(vm)
    initProvide(vm) // resolve provide after data/props
    callHook(vm, 'created')
		
		/* istanbul ignore if */
    if (process.env.NODE_ENV !== 'production' && config.performance && mark) {
      vm._name = formatComponentName(vm, false)
      mark(endTag)
      measure(`vue ${vm._name} init`, startTag, endTag)
    }

    if (vm.$options.el) {
      vm.$mount(vm.$options.el)
    }
}
```

컴포넌트가 `DOM` 에 추가되기 전이기 때문에  `this.$el` 에 접근할 수 없습니다.

또한 `state` 도 초기화 된 상태가 아니기 때문에 `data` 속성에도 접근할 수 없습니다.

`beforeCreate` 가 호출된 이후에는 화면에 반응성이 주입되게 됩니다.

여기서 `initState` 라는 함수에서 `props, methods, data` 등의 속성들의 초기화가 이루어집니다.

```tsx
// src/core/isntance/state.js
export function initState (vm: Component) {
  vm._watchers = []
  const opts = vm.$options
  if (opts.props) initProps(vm, opts.props)
  if (opts.methods) initMethods(vm, opts.methods)
  if (opts.data) {
    initData(vm)
  } else {
    observe(vm._data = {}, true /* asRootData */)
  }
  if (opts.computed) initComputed(vm, opts.computed)
  if (opts.watch && opts.watch !== nativeWatch) {
    initWatch(vm, opts.watch)
  }
}
```

### created

해당 훅에서는 `data` 속성에 접근 가능하지만 아직 `DOM` 에 추가된 상태는 아닙니다.

`data` 에 직접 접근이 가능하기 때문에 데이터 초기화를 위한 작업을 주로 수행합니다.

### beforeMount

```tsx
// src/platforms/web/runtime/index.js

Vue.prototype.$mount = function (
  el?: string | Element,
  hydrating?: boolean
): Component {
  el = el && inBrowser ? query(el) : undefined
  return mountComponent(this, el, hydrating)
}
```

```tsx
// src/core/instance/lifecycle.js

export function mountComponent (
  vm: Component,
  el: ?Element,
  hydrating?: boolean
): Component {
  vm.$el = el
  if (!vm.$options.render) {
    vm.$options.render = createEmptyVNode
		// ...
```

DOM 에 추가되기 전에 호출되는 훅이며 `가상 DOM` 은 생성이 되어 있지만 

아직 실제로 렌더링이 되지는 않은 상황입니다.

### mounted

이 단계부터는 실제 DOM 에 렌더링 된 상태이기 때문에 `this.$el` 에 접근이 가능합니다.

다만 해당 훅이 호출되었다고 해서 모든 자식 컴포넌트가 렌더링 되었다고 보장할 수는 없습니다.

따라서 이 경우 `this.$nextTick` 을 이용하면 됩니다. 

(모든 화면이 렌더링 된 이후 실행되는 것을 보장합니다.)

### beforeUpdate

컴포넌트의 상태값(`data`)이 변경되어 DOM 에도 그 변화 결과가 반영되기 직전에 호출됩니다.

가상 DOM 을 렌더링하기 전이지만 이 값을 이용하여 작업할 수는 있습니다.

이 훅에서 상태를 추가적으로 변경하더라도 렌더링이 추가적으로 발생하지는 않습니다.

### updated

```tsx
// src/core/instance/lifecycle.js

export function mountComponnent(
	vm: Component,
	el: ?Element,
	hydrating?: boolean
) {
	// ...
	updateComponent = () => {
    vm._update(vm._render(), hydrating)
  }

	new Watcher(vm, updateComponent, noop, {
    before () {
      if (vm._isMounted && !vm._isDestroyed) {
        callHook(vm, 'beforeUpdate')
      }
    }
  }, true /* isRenderWatcher */)

	// ...
}

```

변경된 `data` 가 실제 DOM 에 반영된 이후 호출되는 훅입니다.

여기서 `data` 를 바꿀 경우 무한 루프가 발생할 수 있기 때문에 직접 데이터를 바꾸면 안됩니다.

Vue 소스를 찾아보니 `updateComponent` 를 통해 컴포넌트 상태 업데이트 하는 것으로 보입니다.

`updateComponent` 는 `beforeMount` 와 `mounted` 사이에서 초기화됩니다.

### beforeDestroy

대상 인스턴스가 삭제되기 직전에 `beforeDestroy` 훅이 실행됩니다.

아직 삭제되기 이전이기 때문에 인스턴스의 모든 속성에는 접근이 가능합니다.

이 단계에서 컴포넌트에 할당했던 이벤트 리스너를 해제하는 등의 작업을 수행합니다.

### destroyed

인스턴스가 삭제된 이후 호출됩니다.

따라서 삭제된 인스턴스의 속성들에 접근할 수 없습니다.

## 부모와 자식의 라이프사이클 관계

![34](https://user-images.githubusercontent.com/37819666/140364601-fa187593-a388-45b1-8ed2-fd6d35abdc75.png)


부모와 자식의 관계에서는 라이프 사이클 훅이 약간 다르게 동작합니다.

- 먼저 부모의 `beforeCreate` 와 `created` 훅이 호출됩니다.
- 부모의 template 이 렌더링되기 시작하고 이는 자식 컴포넌트들이 생성된다는 의미입니다.
- 자식 컴포넌트들의 `beforeCreate` 와 `created` 훅이 각각 호출됩니다.
- 자식 컴포넌트들이 DOM 에 마운트되며, `beforeMount` 와 `mounted` 가 호출됩니다.
- 자식 컴포넌트들이 모두 마운트되면, 부모 컴포넌트의 `beforeMount` 와 `mounted` 가 호출됩니다.


## 참고자료

[Vue 인스턴스 - Vue.js](https://kr.vuejs.org/v2/guide/instance.html)

[Vue.js instance lifecycle은 어떻게 초기화 될까?](https://velog.io/@gtah2yk/Vue.js-instance-lifecycle%EC%9D%80-%EC%96%B4%EB%96%BB%EA%B2%8C-%EC%9E%91%EB%8F%99%EB%90%A0%EA%B9%8C-axk54t34f1)

[Vue 라이프사이클 이해하기 - 재그지그의 개발 블로그](https://wormwlrm.github.io/2018/12/29/Understanding-Vue-Lifecycle-hooks.html)

[Instance Lifecycle | Cracking Vue.js](https://joshua1988.github.io/vue-camp/vue/life-cycle.html#%EB%9D%BC%EC%9D%B4%ED%94%84-%EC%82%AC%EC%9D%B4%ED%81%B4-%EB%8B%A4%EC%9D%B4%EC%96%B4%EA%B7%B8%EB%9E%A8)

[Order of lifecycle hooks for parent and child](https://forum.vuejs.org/t/order-of-lifecycle-hooks-for-parent-and-child/6681)

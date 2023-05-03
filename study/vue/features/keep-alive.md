# Vue keep-alive 에 대해서

## keep-alive 란?

`Vue` 에서는 재렌더링을 피하거나 상태를 유지하기 위해서 `keep-alive` 라는 기능을 제공하고 있습니다.

동적 컴포넌트를 감싸는 경우 비활성 컴포넌트를 파괴하지 않고 캐싱합니다.

주의할 점은 `keep-alive` 는 한 개의 자식 컴포넌트가 토글되는 경우를 위해 설계된 것이기 때문에

`keep-alive` 내부에 `v-for` 가 있으면 동작하지 않습니다.

## keep-alive 사용 방법

### 동적 컴포넌트 캐싱하기

캐싱을 원하는 동적 컴포넌트를 `keep-alive` 로 감싸면 됩니다.

캐싱된 컴포넌트는 `keep-alive` 내에서 토글될 때 `activated` 와 `deactivated` 가 호출됩니다.

```tsx
<keep-alive>
	<component :is="view" />
<keep-alive>
```

### 조건부 캐싱하기 (include, exclude)

`include` 와 `exclude` 속성을 사용해서 조건에 맞는 컴포넌트만 캐싱하거나 제외할 수 있습니다.

```tsx
<keep-alive :include="a,b">
	<component :is="view" />
</keep-alive>

<keep-alive :include="/a|b/">
	<component :is="view" />
</keep-alive>

<keep-alive :include="['a', 'b']">
	<component :is="view" />
</keep-alive>
```

### 최대 캐싱 개수 지정하기 (max)

`keep-alive` 를 통해서 캐싱할 최대 인스턴스 개수를 지정합니다.

만약 `max` 에 도달하면 가장 오래된 컴포넌트를 캐싱 목록에서 제거합니다.

```tsx
<keep-alive :max="10">
	<component :is="view" />
</keep-alive>
```

## keep-alive 내부 동작 방식

지금부터는 `vue` 저장소에 구현되어있는 실제 `keep-alive` 컴포넌트 코드를 보며

내부 동작 방식을 살펴보도록 하겠습니다.

### keep-alive 컴포넌트 정의

`keep-alive` 컴포넌트의 속성값들을 정의합니다.

`include` , `exclude` , 그리고 `max` 가 사용 가능한 것을 확인할 수 있습니다.

```tsx
const patternTypes: Array<Function> = [String, RegExp, Array]

export default {
  name: 'keep-alive',
  abstract: true,

  props: {
    include: patternTypes,
    exclude: patternTypes,
    max: [String, Number]
  },
	// 
}
```

### keep-alive 의 라이프사이클 (created, mounted)

`cache` 객체는 캐싱된 인스턴스를 유지하며 `keys` 는 ??

이후 `mounted` 가 호출되면 가장 먼저 `cacheVNode` 메서드를 호출하고

```tsx
created () {
  this.cache = Object.create(null)
  this.keys = []
},

mounted () {
  this.cacheVNode()
  this.$watch('include', val => {
    pruneCache(this, name => matches(val, name))
  })
  this.$watch('exclude', val => {
    pruneCache(this, name => !matches(val, name))
  })
},
```

```tsx
insert (vnode: MountedComponentVNode) {
  const { context, componentInstance } = vnode
  if (!componentInstance._isMounted) {
    componentInstance._isMounted = true
    callHook(componentInstance, 'mounted')
  }
  if (vnode.data.keepAlive) {
    if (context._isMounted) {
      queueActivatedComponent(componentInstance)
    } else {
      activateChildComponent(componentInstance, true /* direct */)
    }
  }
},

destroy (vnode: MountedComponentVNode) {
  const { componentInstance } = vnode
  if (!componentInstance._isDestroyed) {
    if (!vnode.data.keepAlive) {
      componentInstance.$destroy()
    } else {
      deactivateChildComponent(componentInstance, true /* direct */)
    }
  }
}
```

`insert` 에서는 `VNode` 가 `keep-alive` 인지 유무에 따라서 큐에 모든 노드 패치 이후에 

라이프사이클 (`activated` 와 `deactivated`) 이 호출될 수 있도록 쌓고 있습니다.

내부적으로는 좀 더 복잡하지만 간단히 말해서 모든 자식 노드들의 패치가 끝난 뒤 

의존성에 변화가 생길때마다 지정된 라이프사이클이 호출되는 구조입니다.

## 참고 자료

[API - Vue.js](https://kr.vuejs.org/v2/api/#keep-alive)

[[Vue] keep-alive 요약](https://velog.io/@kyusung/VUE-keep-alive)

[[Vue.js] keep-alive로 캐시된 컴포넌트(페이지)를 reload 처리 하는 방법](https://ddolcat.tistory.com/1655)
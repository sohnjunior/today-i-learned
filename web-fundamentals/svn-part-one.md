# SVN 을 이용한 형상 관리

## svn? git?

비교적 최근에 개발을 접한 개발자들에게는 생소한 `SVN` 에 대해서 알아보는 포스트입니다.

현재 일하고 있는 회사에서는 보안성 이슈로 한동안 `Git` 을 사용하지 못하기 때문에

이를 대신해서 `SVN` 으로 프로젝트 버전관리를 진행하고 있습니다.

처음 접해보는 버전관리 시스템에 대해서 알아보고 이를 잘 활용할 수 있는 방법을 정하기 위해서

찾아보고 정리한 내용들을 공유하도록 하겠습니다. 😄

## 그렇다면 SVN은 무엇인가요?

`아파치 서브버전(Subversion)` 은 프로젝트 버전 관리를 위해 사용하는 형상관리 툴입니다.

또 다른 형상관리 툴이었던 `CVS` 의 다음과 같은 한계점을 극복하기 위해 개발되었습니다.

<aside>
💡 `CVS` 의 한계점은?

1. CVS 저장소의 파일들은 이름을 변경할 수 없습니다.
2. CVS 에서는 디렉토리의 이동이나 이름 변경을 허용하지 않습니다.
3. 유니코드로 된 파일이름을 제한적으로 지원합니다.

</aside>

`SVN` 은 `클라이언트 서버 모델` 을 따르도록 구현되어있으며, 

서버는 작업하는 컴퓨터 혹은 별도의 컴퓨터에 할당하여 사용할 수 있습니다.

## SVN 은 중앙집중식 버전관리 시스템입니다.

![1](https://user-images.githubusercontent.com/37819666/152681626-b35e0c8c-5cff-4c30-84dd-41d3fce783e1.png)

`SVN` 은 `Git` 과 달리 중앙집중식 버전관리 시스템(**Centralized version control**)입니다.

이 방식에서는 각각의 개발자들이 본인의 코드 변경 사항을 하나의 중앙 `repository` 에 

`commit` 하는 방식으로 운영됩니다.

이해가 직관적이라는 장점이 있지만 중앙 서버에 문제가 생길 경우에는 

서비스 자체가 중단되는 현상이 발생할 수 있다는 점이 단점입니다.

![2](https://user-images.githubusercontent.com/37819666/152681628-9de30444-7a63-4b34-8d8e-5e03f5a55eb2.png)

반면 `Git` 에서는 위와 같이 중앙 `repository` 를 통째로 복사한 별도의 `repository` 를

각 개발자들이 가지고 있으며, 개발자는 변경 사항을 해당 로컬 `repository` 에 반영하고,

최종적으로 이 변경사항을 중앙 `repository` 에 반영하기 위해 `pull request` 를 요청합니다.

## SVN 에서 사용하는 용어 정리

### Repository

`server` 의 역할을 하며 개발자의 코드 및 히스토리가 관리되는 곳입니다.

개발자는 `repository` 로부터 다른 개발자가 반영한 코드를 업데이트 할 수 있고

자신이 수정한 내역을 반영하여 다른 개발자와 공유할 수 있습니다.

### Trunk

`Trunk` 는 개발자가 주로 개발을 진행하는 곳입니다.

### Tags

`Tags` 는 진행중인 프로젝트의 특정 버전 스냅샷에 의미가 있는 이름을 붙인 것입니다.

이를 위해서는 해당 버전이 다른 버전과 구분되는 명확한 이름을 붙이는 것이 좋습니다.

### Branches

`Branches` 는 개발 도중 프로젝트 코드에 새로운 가지를 치는 것입니다.

배포된 버전에서 버그를 수정하거나, 새로운 기능을 추가할 때 활용합니다.

### Working Copy

`Working Copy` 는 `repository` 의 스냅샷입니다.

`repository` 는 모든 개발자가 공유하지만 직접적으로 수정하지는 않습니다.

대신 개발자는 각자의 `working copy` 에 `checkout` 하고 본인의 작업을 진행합니다.

### Commit

`Commit` 은 개발자가 작성한 코드의 변경사항을 본인의 `working copy` 에서 

중앙 `repository` 로 반영하는 것을 의미합니다.

`Commit` 작업은 `atomic` 하기 때문에 전부 성공하거나 실패하여 일부만 반영되는 일은 없습니다.

반영된 내용은 다른 개발자가 본인의 `working copy` 로 업데이트할 수 있습니다.

## SVN 을 활용한 버전관리 튜토리얼

### svn repository 생성하기

우선 예제를 위한 디렉토리를 생성하기위해 다음 명령어를 입력합니다. 

```bash
> svnadmin create --fs-type fsfs svn-example
```

**svn repository 접근방식 설정하기**

`repository` 에 접근하기 위한 여러가지 방법이 있는데 이번 예제에서는 가장 기본적으로

제공해주는 `svnserve` 라는 서버 프로그램을 활용하겠습니다.

우선 인증에 사용할 방법을 설정하기 위해 `svn-example/conf/svnserve.conf` 를 수정합니다.

```bash
[general]
## ...
## ...
password-db = passwd # 이 부분 주석을 제거합니다.
```

이제 유저계정정보를 입력하기 위해 `passwd` 파일을 수정합니다.

```bash
[users]
# harry = harryssecret
# sally = sallyssecret
handhand = password
```

**SVN 서버 실행하기**

다음 명령어를 통해 svn 서버를 데몬으로 실행합니다.

```bash
> svnserve -d -r svn-example
```

`netstat` 명령어로 현재 데몬모드에서 서버가 열려있다는 것을 확인할 수 있습니다.

```bash
> netstat -na | grep 3690
tcp4    0   0  *.3690       *.*            LISTEN
```

**trunk, branches, tags 디렉토리 생성하기**

마지막으로 `svn mkdir` 명령어로 `trunk, branches, tags` 디렉토리를 생성합니다.

```bash
> svn mkdir svn://localhost/svn-example/trunk --username handhand
> svn mkdir svn://localhost/svn-example/branches --username handhand
> svn mkdir svn://localhost/svn-example/tags --username handhand
```

💡 **만약 이 과정에서 만약 다음과 같은 오류가 발생한다면...**

`svn mkdir` 명령어 수행 시 다음과 같은 오류가 발생할 수도 있습니다.

```bash
svn: E205007: 로그 메시지를 구하기 위해 외부 프로그램을 사용할 수 없습니다. SVN_EDITOR 환경변수를 설정하시거나 --message (-m) 또는 --file (-F) 옵션을 사용하세요
svn: E205007: 환경변수 SVN_EDITOR, VISUAL, EDITOR 중 하나는 설정하거나, 'editor-cmd' 를 구성화일에 명시해야합니다
```

이 경우 본인이 사용하고 있는 쉘의 설정 파일의 맨 하단에 다음과 같이 설정을 추가해줍니다.

저의 경우 `zsh` 을 사용하고 있기 때문에 `zshrc` 를 열어서 다음 코드를 추가해줬습니다.

```bash
SVN_EDITOR=/usr/bin/vim
export SVN_EDITOR
```

이후 변경된 설정을 적용하기 위해 다음 명령어를 수행해줍니다.

```bash
> soruce ~/.zshrc
```

**디렉토리가 올바르게 생성되었는지 확인하기**

`svn list` 명령어를 통해서 위 디렉토리들이 문제없이 생성되었는지 확인합니다.

```bash
> svn list svn://localhost/svn-example                              
branches/
tags/
trunk/
```

### SVN 프로젝트 생성하기

생성된 repository 로 이동한 뒤 프로젝트 작업을 위한 공간을 생성합니다.

```bash
> cd svn-example
> mkdir workspace
```

그리고 프로젝트 진행을 위한 위 프로젝트를 svn repository 에 올리는데,

이 작업을 `import` 라고 합니다.

```bash
> svn import workspace svn://localhost/svn-example/trunk --username handhand
```

### SVN 프로젝트 가져오기

repository 에 등록을 마친 프로젝트를 이제 다른 개발자들이 가져와 작업을 할 수 있습니다.

이 과정을 `checkout` 이라고 하며 다음과 같은 명령어로 수행 가능합니다.

```bash
> svn co svn://localhost/svn-example --username handhand workspace
A    workspace/branches
A    workspace/tags
A    workspace/trunk
A    workspace/trunk/example.js
```

### SVN 변경사항 반영하기

이제 서로 다른 사람이 변경 사항을 가져오는 방법을 가정하기 위해서

`sam` 과 `david` 라는 가상의 개발자들의 작업 공간을 생성해보겠습니다.

이 두 개발자 모두 동일한 repository 에서 작업하기 때문에 위 저장소를 `checkout` 합니다.

```bash
> mkdir sam
> svn co svn://localhost/svn-example --username handhand workspace

> mkdir david
> svn co svn://localhost/svn-example --username handhand workspace
```

이후 `sam` 은 다음과 같이 `test.js` 에 새로운 코드를 추가합니다.

```jsx
// test.js

console.log('hello svn!')
```

그리고 `svn status` 명령어로 현재 버전관리 상태를 확인할 수 있습니다.

```bash
> cd sam/workspace
> svn status
M       trunk/test.js
```

수정된 파일 내용을 반영하기 위해서 다시 `commit` 을 수행합니다.

```bash
> svn commit -m "modify test.js"
전송중         trunk/test.js
파일 데이터 전송중 .done
Committing transaction...
커밋된 리비전 7.
```

이제 `david` 의 작업 공간에서 수정된 내용을 가져옵니다.

이는 `update` 혹은 `up` 명령어를 통해서 수행 가능합니다.

```bash
> svn up
Updating '.':
U    trunk/test.js
업데이트 된 리비전 7.
```

## 그렇다면 효율적인 SVN 버전 관리 방법은?

`SVN` 으로 버전관리 시스템을 사용할 경우 어떤 방식으로 저장소를 관리할 지 선택이 필요합니다.

큰 틀에서 다음과 같이 두 가지 방법이 있을 수 있습니다.

### trunk, branches, tags 를 최상위 디렉토리로 하기

![3](https://user-images.githubusercontent.com/37819666/152681631-d43d93ac-6ca1-4030-8b2c-eb8ba1c53e59.png)

### 각 프로젝트를 최상위 디렉토리로 하기

![4](https://user-images.githubusercontent.com/37819666/152681634-23731999-8645-4a97-831c-f1010b0c9987.png)

프로젝트 성격에 따라 다르겠지만 적은 인원과 규모가 크지 않은 프로젝트에서는

위와 같은 구조로 진행하더라도 큰 문제가 없을 것 같다고 생각합니다.

하지만 현재 제가 회사에서 진행하고 있는 프로젝트의 규모에서는 위와 같은 구조만으로는

관리가 어렵다고 판단이 들어 좀더 구체적인 전략이 필요했습니다.

이를 위한 고민과 최종적으로 결정된 관리 방법은 다음 포스트에서 만나보도록 하겠습니다. 😁

## 참고 자료

[아파치 서브버전 - 위키백과, 우리 모두의 백과사전](https://ko.wikipedia.org/wiki/%EC%95%84%ED%8C%8C%EC%B9%98_%EC%84%9C%EB%B8%8C%EB%B2%84%EC%A0%84)

[SVN 이란](https://treeroad.tistory.com/entry/SVN-%EC%9D%B4%EB%9E%80)

[Centralized vs Distributed Version Control Systems](https://faun.pub/centralized-vs-distributed-version-control-systems-a135091299f0)

[SVN Tutorial](https://www.tutorialspoint.com/svn/index.htm)

[svn trunk, tags, branches 기본 디렉토리 만들기](https://okkks.tistory.com/985)

[SVN Tutorial 문서](https://www.joinc.co.kr/w/Site/SVN/Tutorial)
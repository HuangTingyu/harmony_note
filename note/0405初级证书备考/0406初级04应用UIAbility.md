习题

https://developer.huawei.com/consumer/cn/training/course/slightMooc/C101717497122909477



### APP包结构

https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ide-project-overview

```
应用/元服务发布形态为APP Pack，它是由一个或多个HAP包，及描述App Pack属性的pack.info组成
```



```
一个HAP在工程目录中对应一个Module，它是由代码、资源、三方库及应用/元服务配置文件组成，HAP可以分为Entry和Feature两种类型。

Entry：应用的主模块，作为应用的入口，提供了应用的基础功能。

Feature：应用的动态特性模块，作为应用能力的扩展，可以根据用户的需求和设备类型进行选择性安装。
```



### HAP

```
Ability类型的Module： 用于实现应用的功能和特性

每一个Ability类型的Module编译后,称其为HAP（Harmony Ability Package）包

每个HAP包可以独立运行，是应用安装的基本单位
```



题目

```
一个应用是由一个或多个HAP组成

✔
```



```
每个HAP在工程目录中都对应一个Module

✔
```



### HSP/HAR

https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/application-package-structure-stage

```
Library类型的Module： 用于实现代码和资源的共享。
同一个Library类型的Module可以被其他的Module多次引用

Library类型的Module分为Static和Shared两种类型
Static Library：静态共享库HAR（Harmony Archive Package）
Shared Library：动态共享库HSP（Harmony Shared Package）。
```



```
HAR和HSP区别

HAR中的代码和资源跟随使用方编译，如果有多个使用方，它们的编译产物中会存在多份相同拷贝

HAR除了支持应用内引用，还可以独立打包发布，供其他应用引用。

HSP中的代码和资源可以独立编译，运行时在一个进程中代码也只会存在一份。

HSP一般随应用进行打包，当前支持应用内和集成态HSP
```



### 开发态-编译态

```
ets目录：ArkTS源码生成.abc文件

resources目录：AppScope目录中的resources合入Module中的resources，如存在同名，只保留AppScope

module配置文件：AppScope中的app.json5合入Module中的module.json5
```



```
在编译HAP和HSP时，会把他们所依赖的HAR直接编译到HAP和HSP中。
```



### `ExtensionAbility`

基于特定场景提供的组件（如服务卡片、输入法等），每一个场景对应一个`ExtensionAbilityType`，只能使用系统已定义的类型

同一应用所有的`ExtensionAbility`处于同一独立进程，跟UIAbility不在同一进程

```
HAP,HAR,HSP都支持在配置文件中声明UIAbility

只有HAP支持声明ExtensionAbility，HAR和HSP不支持
```



### 进程模型

https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V14/process-model-stage-V14

```
通常情况下，应用中（同一Bundle名称）的所有UIAbility均是运行在同一个独立进程（主进程）中，如下图中绿色部分的“Main Process”。
仅系统应用支持构建ServiceExtensionAbility和DataShareExtensionAbility。

应用中（同一Bundle名称）的所有同一类型ExtensionAbility均是运行在一个独立进程中，如下图中蓝色部分的“FormExtensionAbility Process”、“InputMethodExtensionAbility Process”、其他ExtensionAbility Process。

WebView拥有独立的渲染进程，如下图中黄色部分的“Render Process”
```



### Stage线程

https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V14/thread-model-stage-V14



```
线程主要有3类

主线程、TaskPool Worker线程、Worker线程

TaskPool Worker用于执行耗时操作，支持设置调度优先级，负载均衡等能力

Worker线程用于执行耗时操作，支持线程间通信
```



### Stage模型设计思想

为复杂应用设计 

- 不同组件实例共享
- 面向对象开发



支持跨端迁移_多端协同

- UIAbility与UI分离
- UIAbility UI展示与服务能力合一



支持多设备多窗口

- UIAbility生命周期
- 组件管理和窗口管理解耦



平衡应用能力与系统管控

- 严格后台管理
- 严格进程模型



### 工程文件说明

#### 配置文件

`app.json5`全局唯一，声明应用的全局配置信息

`module.json5` 每个模块下都有，声明模块信息

```
"pages": "$profile:main_pages", //路由配置
```



`oh-package.json5` 配置依赖包信息

`src/main/resources/base/profile` 自定义配置文件，如路由配置，页面配置，卡片配置等



#### ArkTS源码文件

`EntryAbility`继承`UIAbility`

在这个文件里写生命周期，如标识需加载的页面

```
onWindowStageCreate(windowStage: window.WindowStage): void {

    windowStage.loadContent('pages/Index', (err) => {
      ......
    });
  }
```



### UIAbility

UIAbility组件是一种包含UI的应用组件，主要用于和用户交互。

UIAbility的生命周期包括Create、Foreground、Background、Destroy四个状态

为使应用能够正常使用UIAbility，需要在`module.json5`中`abilities`声明UIAbility的名称、入口、标签等相关信息。



#### 生命周期

```typescript
onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    //应用初始化
  }
```

```js
onWindowStageCreate(windowStage: window.WindowStage): void {
    // 设置WindowStage的事件订阅（获焦/失焦、切到前台/切到后台、前台可交互/前台不可交互）
    // 指定页面入口文件
    windowStage.loadContent('pages/Index', (err) => {}
}
onForeground(): void {
	// 应用前台状态
    // 申请系统需要的资源，或者重新申请在onBackground释放的资源
    // 例如，定位，可以在这里开启获取定位信息
  }
```



```js
onWindowStageWillDestroy(windowStage: window.WindowStage) {
    // 释放通过windowStage对象获取的资源
    // 在onWindowStageWillDestroy()中注销WindowStage事件订阅（获焦/失焦、切到前台/切到后台、前台可交互/前台不可交互）
  }

  onBackground(): void {
    // 释放UI页面不可见时无用的资源，或回调执行耗时的操作，如状态保存
    // 例如，定位，在这里停止定位
  }
```



```js
onDestroy(): void {
    //资源释放或数据保存
  }
```



#### 启动模式

`module.json5`中`abilities`配置

```
"abilities": [
      {
        "launchType": "singleton",
        // ...
      }
    ]
```

一共有3种模式`singleton`, `multiton`, `specified`



`singleton`

```
任务列表中只存在一个该类型的UIAbility
调用startAbility，不会进入oncreate和onWindowStageCreate，直接返回已有的，触发回调函数onNewWant
```



`multiton`

```
调用startAbility，创建新的UIAbility
```



`specified`

```
调用startAbility，传入唯一的Key值，触发回调函数onAcceptWant，可以获取UIAbility的Key值
```

下一次调用`startAbility`，根据传入的Key值进行判断

```
如果该Key已存在，直接启动，触发回调函数onNewWant

如果不存在，创建新的UIAbility
```

示例代码

```js
let want: Want = {
               deviceId: '', // deviceId为空表示本设备
               bundleName: 'com.samples.stagemodelabilitydevelop',
               abilityName: 'SpecifiedFirstAbility',
               moduleName: 'entry', // moduleName非必选
               parameters: {
                 // Key值标识位
                 instanceKey: this.KEY_NEW
               }
             };
context.startAbility(want).then(() => {}
```



### 中止

```
let context = getContext(this) as common.UIAbilityContext;

context.terminateSelf
```



### `UIAbility`和UI通信

`EntryAbility.ets` 注册事件

```js
onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 获取eventHub
    let eventhub = this.context.eventHub;
    // 执行订阅操作
    eventhub.on('event1', this.eventFunc);
    eventhub.on('event1', (data: string) => {
      // 触发事件，完成相应的业务操作
    });
  }
```



`Index.ets`触发事件

```js
eventHubFunc(): void {
    // 不带参数触发自定义“event1”事件
    this.context.eventHub.emit('event1');
    // 带1个参数触发自定义“event1”事件
    this.context.eventHub.emit('event1', 1);
    // 带2个参数触发自定义“event1”事件
    this.context.eventHub.emit('event1', 2, 'test');
    // 开发者可以根据实际的业务场景设计事件传递的参数
  }
```



### abilityName

```
表示待启动的Ability名称。如果在Want中该字段同时指定了BundleName和AbilityName，则Want可以直接匹配到指定的Ability。AbilityName需要在一个应用的范围内保证唯一。
```



### 多个`UIAbility`互相通信

#### 启动应用内`UIAbility`

传参，`want`中的`parameters`

```js
let wantInfo: Want = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.samples.stagemodelabilitydevelop',
              moduleName: 'entry', // moduleName非必选
              abilityName: 'FuncAbilityA',
              parameters: {
                // 自定义信息
                info: '来自EntryAbility Page_UIAbilityComponentsInteractive页面'
              },
            };
            // context为调用方UIAbility的UIAbilityContext
            this.context.startAbility(wantInfo).then(() => {})
```



新`UIAbility`接收参数`onCreate`或者`onNewWant`

冷启动走`onCreate`，热启动走`onNewWant`

```js
export default class FuncAbilityA extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 接收调用方UIAbility传过来的参数
    let funcAbilityWant = want;
    let info = funcAbilityWant?.parameters?.info;
  }
  //...
}
```



新`UIAbility`应用关闭

```
context.terminateSelf((err) => {})
```



#### `UIAbility`返回结果

`startAbilityForResult`异步等待，这里写了个异步函数

```js
let want: Want = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.samples.stagemodelabilitydevelop',
              moduleName: 'entry', // moduleName非必选
              abilityName: 'FuncAbilityA',
              parameters: {
                // 自定义信息
                info: '来自EntryAbility UIAbilityComponentsInteractive页面'
              }
            };
            context.startAbilityForResult(want).then((data) => {
              if (data?.resultCode === RESULT_CODE) {
                // 解析被调用方UIAbility返回的信息
                let info = data.want?.parameters?.info;
```



新`UIAbility`触发异步函数

`terminateSelfWithResult`传参

```
let abilityResult: common.AbilityResult = {
              resultCode: RESULT_CODE,
              want: {
                bundleName: 'com.samples.stagemodelabilitydevelop',
                moduleName: 'entry', // moduleName非必选
                abilityName: 'FuncAbilityB',
                parameters: {
                  info: '来自FuncAbility Index页面'
                },
              },
            };
            context.terminateSelfWithResult(abilityResult, (err) => {})
```




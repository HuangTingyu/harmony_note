习题

https://developer.huawei.com/consumer/cn/training/course/slightMooc/C101717497122909477



#### HAP/HSP/HAR

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


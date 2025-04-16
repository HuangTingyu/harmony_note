习题

https://developer.huawei.com/consumer/cn/training/course/slightMooc/C101705071657237039



### `AbilityStage`组件容器

https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/abilitystage

```
Module级别的组件容器，HAP首次加载，会创建一个AbilityStage实例

AbilityStage与Module一一对应
```



生命周期

```
onCreate: AbilityStage的oncreate在UIAbility前面，在此进行Module初始化，资源预加载，线程创建等

onAcceptWant: UIAbility实例为specified启动时触发

onConfigurationUpdated: 系统配置发生更改时触发，系统语言，深色等

onMemoryLevel: 系统调整内存时触发
```



```
当被调用方UIAbility组件启动模式设置为multiton启动模式时，每次启动都会创建一个新的实例，那么onNewWant()回调就不会被用到。
```



### 停止`UIAbility`

```
context.terminateSelf
```



### HAR/HSP

```
HAR不支持在配置文件中声明pages，但可以包含pages页面，并通过路由跳转

如果HAR依赖了HSP，那么HAR仅支持应用内共享，不能发到三方仓库

HAR和HSP均不支持循环依赖，也不支持依赖传递
```



### HSP

```
HSP（Harmony Shared Package）动态共享包，可以包含代码，C++库，资源和配置文件

应用内HSP: 
编译过程与包名（bundleName）强耦合，只能给特定应用

集成态HSP: 
不与特定应用包耦合，使用时工具链会根据宿主生成新的HSP包，也属于应用内的HSP
```



```
HSP不支持在设备上单独安装/运行，版本号必须与HAP版本号一致！
```



路由跳转

```
 router.pushUrl({
            url: '@bundle:com.samples.hspsample/library/ets/pages/Menu'
          })
```

```
'@bundle:包名（bundleName）/模块名（moduleName）/路径/页面所在的文件名(不加.ets后缀)'
```



### HAR

```
Harmony Archive静态共享包

HAR不支持引用AppScore目录中的资源

HAR不支持配置文件中声明ExtensionAbility，但支持UIAbility
```



#### 编译覆盖优先级

如果`resoures`中的资源重名，会按照下面的优先级进行覆盖

```
AppScope

HAP包自身模块

依赖的HAR包模块
```



### 混淆能力

混淆能力开启后，DevEco Studio在构建HAR时，会对代码进行编译、混淆及压缩处理，保护代码资产。

```
build-profile.json5配置


"ruleOptions": {
            "enable": true,
            "files": [
              "./obfuscation-rules.txt"
            ]
}
```



### 隐式Want与显式Want

隐式Want最大区别，不需要传`abilityName`

核心机制：

通过`action`（操作类型）、`entities`（能力类别）、`uri`（数据标识）等字段定义需求，系统根据目标组件的`skills`配置（在`module.json5`中声明）筛选匹配的应用

隐式Want使用场景：

（1）跨应用调用

```
例如启动浏览器打开特定网页时，系统匹配所有支持entity.system.browsable能力的应用
```

（2）动态匹配服务

```
如导航功能中，通过uri字段传递高德地图的特定参数（如经纬度），系统自动启动支持该协议的应用。
```



隐式Want使用前提

在目标应用的`module.json5`文件中，需通过`skills`字段声明其支持的能力

```
{
  "skills": [
    {
      "actions": ["ohos.want.action.search"],
      "entities": ["entity.system.browsable"],
      "uris": [
        {
          "scheme": "https",
          "host": "www.test.com"
        }
      ]
    }
  ]
}
```



### `AppStartup`

支持任务异步启动，加快启动速度

设置多个启动任务的执行顺序，及依赖关系

启动框架支持自动模式/手动模式，默认自动模式



```
1 resource/base/profile下，新建文件startup_config.json
2 ets/startup文件下创建启动文件StartupTask_001.ets
3 创建启动任务参数配置文件StartupConfig.ets
4 module.json5里面配置
```



`StartupConfig.ets`

```
{
	"startupTasks": [
		{
			name: 'StartupTask_001.ets'
		}
	],
	"configEntry": "./ets/startup/StartupConfig.ets"
}
```



`module.json5`

```
{
  "module": {
    "name": "entry",
    "type": "entry",
    // ...
    "appStartup": "$profile:startup_config", // 启动框架的配置文件
    // ...
  }
}
```



### 判断/单选

```
一个应用是由一个或多个HAP组成

✔
```



```
UIAbility组件多实例启动是默认启动模式

✖
默认启动模式是单实例
```



```
关于指定实例正确的是

支持拉起指定标识的实例
```



```
关于Want的说法

Want是对象间信息传递的载体，用于在应用组件之间传递信息
Want使用场景之一是作为startAbility()的参数
使用Want 启动UIAbility组件有显示Want启动和隐式Want启动两种形式
```



```
使用隐式Want启动UIAbility组件时，以下说法正确的是

可以在创建的Want中设置想要启动的UIAbility组件的能力字段，如“entities”

想要在启动浏览器类型应用内时默认打开网页，可以在创建的Want中设置“uri”字段

在module.json5配置文件中，“skills”表示应用组件支持的能力
```


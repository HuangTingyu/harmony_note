### ArkUI文档

https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-basic-components-text



### 解决上下白条

扩展安全区域

https://developer.huawei.com/consumer/cn/doc/harmonyos-faqs/faqs-previewer-operating-6-V5

```
@Entry
@Component
struct TaskList {

  build() {
  	Column(){
  		// ......
  	}.width('100%')
    .height('100%').expandSafeArea([SafeAreaType.SYSTEM])
  
  }

.expandSafeArea([SafeAreaType.SYSTEM])
```



### resource类型

```
lineHeight(value: number | string | Resource)
```

`Resource`解释，通过$r引入的变量，就是Resource类型

```
$r('app.string.placeholder')
```



### 布局单位

https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-pixel-units

| 名称 | 描述                                                         |
| :--- | :----------------------------------------------------------- |
| px   | 屏幕物理像素单位。                                           |
| vp   | 屏幕密度相关像素，根据屏幕像素密度转换为屏幕物理像素，当数值不带单位时，默认单位vp。**说明：**vp与px的比例与屏幕像素密度有关。 |
| fp   | 字体像素，与vp类似适用屏幕密度变化，随系统字体大小设置变化。 |
| lpx  | 视窗逻辑像素单位，lpx单位为实际屏幕宽度与逻辑宽度（通过[designWidth](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/module-configuration-file#pages标签)配置）的比值，designWidth默认值为720。当designWidth为720时，在实际宽度为1440物理像素的屏幕上，1lpx为2px大小。 |

鸿蒙布局的时候，采用vp为基准数据单位，所以直接写数字，不需要加px

不推荐px，因为px不同手机分辨率不同，布局出来不一样

字体一般用`fp`

下面这两种写法是相同的

```
Row().width(100).height(100).backgroundColor('red')

      Row().width('100vp').height('100vp').backgroundColor('blue')
```




习题

https://developer.huawei.com/consumer/cn/training/course/slightMooc/C101705083116217059



参考文档

https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-basic-components-web-V5

```
controller控制器是由@ohos.web.webview提供的web控制能力
```



```
一个WebviewController对象只能控制一个Web组件，且必须在Web组件和WebviewController绑定后，才能调用WebviewController上的方法
```



### 常用API

#### `fileAccess`

是否开启对应用中文件系统的访问，`$rawfile`不受影响

```
Web({ src: $rawfile('index.html'), controller: this.controller })
```



```
Web({ src: 'www.example.com', controller: this.controller })
.fileAccess(true)
```



### `zoomAccess`

是否支持手势缩放

```
Web({ src: 'www.example.com', controller: this.controller })
.zoomAccess(true)
```



### `zoom`

调整网页缩放比例

注意`zoomAccess`需设置为true

```

adjustWeb: ()=>{
	this.controller.zoom(1)
}

build(){
	Web({ src: 'www.example.com', controller: this.controller })
        .zoomAccess(true)

}
```



### 事件`onConfirm`

```
Column() {
      Web({ src: $rawfile("index.html"), controller: this.controller })
        .onConfirm((event) => {}
}
```



`index.html` 里面调用`confirm()`就可以触发

```
<button onclick="myFunction()">Click here</button>

<script>
    function myFunction() {
    	confirm()
    }
</script>
```



### `runJavaScript`

可以调用`JS`脚本中的方法

```
Web({ src: $rawfile('index.html'), controller: this.controller })
.onPageEnd(e => {
          try {
            this.controller.runJavaScript(
            'test()'
            )
        } catch(err){}
}
```



### `javaScriptAccess`

是否允许执行`JS`代码，默认true



### `javaScriptProxy`

往`JS`中插入代码，只能插入一个`Object`



### `registerJavaScriptProxy`

可以往`JS`中插入代码

```typescript
registerJavaScriptProxy(
  object: object, 
  name: string, //插入的object名称
  methodList: Array<string>, // 同步自定义方法
  asyncMethodList?: Array<string>, // 异步自定义方法
  permission?: string
)
```



```typescript
Button('Register JavaScript To Window')
        .onClick(() => {
          try {
            // 同时注册同步和异步函数
            this.controller.registerJavaScriptProxy(
            this.testObjtest, 
            "objName", 
            ["test", "toString", "testNumber"],
            ["asyncTestBool"]
);
```



`html`调用

```typescript
let str=objName.test("webtest data");
objName.testNumber(1);
```



### `deleteJavaScriptRegister`

注销`registerJavaScriptProxy`插入的代码

```
this.controller.deleteJavaScriptRegister("objName");
```



### 判断/单选

```
Web组件提供具有网页显示能力，@ohos.web.webview提供web控制能力

✔
```



```
同一页面多个web组件，必须绑定不同WebviewController

✔
```



```
关于Web组件的属性描述

fileAccess设置是否开启应用中文件系统的访问。$rawfile(filepath/filename)中rawfile路径的文件不受该属性影响而限制访问

imageAccess设置是否允许自动加载图片资源，默认允许

registerJavaScriptProxy设置注入JavaScript对象

zoomAccess设置是否支持手势缩放，默认允许执行缩放
```



```
关于Webview描述

访问在线网页时需添加网络权限

@ohos.web.webview提供web控制能力，web组件提供网页显示能力

一个WebviewController对象只能控制一个Web组件

WebviewController可以控制Web组件各种行为
```



### 多选

```
Web组件支持下列哪些属性或事件

fileAccess(fileAccess: boolean)
javaScriptAccess(javaScriptAccess: boolean)
onConfirm(callback: (event?: { url: string; message: string; result: JsResult }) => boolean)
```


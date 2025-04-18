习题

https://developer.huawei.com/consumer/cn/training/course/slightMooc/C101705084078534051



`hilog.info`调试技巧

```
DevEco Studio底部的，点击log
```



### 配置

`build-profile.json5`

```json
"buildOption": {
    "externalNativeOptions": {
      "path": "./src/main/cpp/CMakeLists.txt",
      "arguments": "",
      "cppFlags": "",
      "abiFilters": [
        "arm64-v8a",
        "x86_64"
      ]
    }
  },
```



**注意，这个互联只能在模拟器上运行**

`Previewer`会直接报错！



### 交互流程

```
初始化阶段
import Navie模块时，调用ModuleManager加载模块及so依赖
首次加载触发模块注册，将模块定义的方法挂在exports对象上并返回该对象
```



### 实现顺序

#### `napi_module_register`

将模块注册到系统中，并调用模块初始化函数

```typescript
static napi_module demoModule = {
    .nm_register_func = Init, //定义模块初始函数
    .nm_modname = "entry", // 定义模块名称,ArkTS引入相关
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
```



`ArkTS`与`C++`接口绑定

```c++
EXTERN_C_START
// 模块初始化
static napi_value Init(napi_env env, napi_value exports) {
    // ArkTS接口与C++接口的绑定和映射
    napi_property_descriptor desc[] = {
    	// 绑定
    	 {"callNative", nullptr, CallNative,......}
    }
}
EXTERN_C_END
```



导出接口

```typescript
// entry/src/main/cpp/types/libentry/index.d.ts
export const callNative: (a: number, b: number) => number;
```



关联接口导出文件和`cpp`文件

```json
// entry/src/main/cpp/types/libentry/oh-package.json5
{
  "name": "libentry.so",
  "types": "./index.d.ts",
  "version": "",
  "description": "Please describe the basic information."
}
```



`CMakeLists.txt`文件中配置`CMake`打包参数

```
# entry/src/main/cpp/CMakeLists.txt

# 添加名为entry的库
add_library(entry SHARED napi_init.cpp)
# 构建此可执行文件需要链接的库
target_link_libraries(entry PUBLIC libace_napi.z.so)
```



定义`cpp`接口

```c++
static napi_value CallNative(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    // 声明参数数组
    napi_value args[2] = {nullptr};

    // 获取传入的参数并依次放入参数数组中
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 依次获取参数
    double value0;
    napi_get_value_double(env, args[0], &value0);
    double value1;
    napi_get_value_double(env, args[1], &value1);

    // 返回两数相加的结果
    napi_value sum;
    napi_create_double(env, value0 + value1, &sum);
    return sum;
}
```



```c++
// &argc代表argc的内存地址
// 因为napi_get_cb_info要把实际传的参数赋给argc，所以这里传地址
napi_get_cb_info(env, info, &argc, args, nullptr, nullptr)
```



```c++
// 这里是把js的变量转成cpp的double变量
double value0;
napi_get_value_double(env, args[0], &value0);
```



```c++
// 返回两数相加的结果
// napi_value js可识别的变量
// napi_create_double 把cpp的double变量转成js变量
napi_value sum;
napi_create_double(env, value0 + value1, &sum);
```



### 规则约束

so命名规则

```
如果so名字为libentry
napi_module中.nm_modname字段为entry
ArkTS导入 import xxx from 'libentry.so'
```



```
nm_register_func需要加上static,防止与其他so里的符号冲突
```



多线程限制

```
每个引擎对应一个JS线程，不能跨线程操作，否则应用crash
Node-API只能在JS线程使用
Native接口入参env，env与JS线程绑定，只能在创建时的线程使用
```


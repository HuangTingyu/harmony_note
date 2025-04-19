### 0419NodeApi题目

https://developer.huawei.com/consumer/cn/training/course/slightMooc/C101705084078534051



总结归纳

```
同步任务会阻塞UI操作

异步任务和线程安全不会阻塞UI操作，任务执行前先返回临时空值给ArkTS主线程，任务完成后，返回异步结果
```



线程安全相关

```
napi_create_threadsafe_function 创建线程安全函数

napi_get_threadsafe_function_context 获取线程安全函数中的context

napi_call_threadsafe_function 调用线程安全函数

napi_acquire_threadsafe_function 线程安全函数可以开始执行

napi_release_threadsafe_function 线程安全函数停止执行

napi_ref_threadsafe_function 主线程上运行的eventLoop事件循环在线程安全函数被销毁之前不应退出

napi_unref_threadsafe_function xxx在线程安全函数销毁前退出
```



### 判断/单选

```
当ArkTS侧在import一个so库时，ArkTS引擎会调用ModuleManager加载模块对应的so文件及其依赖。每次加载时都会触发模块的注册。

✖
首次加载
```



```
导入使用的模块名和注册时的模块名大小写保持一致，如模块名为entry，则so的名字为libentry.so，napi_module中nm_modname字段应为entry，ArkTS侧使用时写作：import xxx from 'libentry.so'。

✔
```



```
有关线程安全的函数功能说明正确的是

napi_call_threadsafe_function：调用xxx
napi_release_threadsafe_function：停止xxx
napi_ref_threadsafe_function：指示在主线程上运行的事件循环在线程安全函数被销毁之前不应退出

napi_acquire_threadsafe_function：开始执行xxx
```



```
关于napi_create_async_work接口中注册的execute和complete回调，以下哪个说法是正确的

execute回调函数主要用于执行异步业务逻辑，代码运行在work子线程中

complete回调函数主要用于将execute回调函数的处理结果反馈给ArkTS应用侧，代码运行在ArkTS主线程
```



```
关于线程安全函数正确的是

在创建线程安全函数对象时，要注册绑定ArkTS应用侧传入的callback回调和线程安全回调napi_threadsafe_function_call_js

在Native接口实现中，会临时返回空值或者promise对象给ArkTS应用侧，以避免应用侧主线程阻塞

C++子线程将会执行异步业务逻辑，并将处理结果写入上下文数据中。同时，调用napi_call_threadsafe_function将napi_threadsafe_function_call_js抛给EventLoop事件循环
 
在线程安全回调napi_threadsafe_function_call_js执行过程中，将会通过调用napi_call_function或者napi_resolve_deferred把异步处理结果反馈到ArkTS应用侧
```


使用场景

同步任务，异步任务，线程安全



### 同步任务

应用侧主线程阻塞，等待Native侧计算结果

Native接口与`ArkTS`应用侧均运行在`ArkTS`主线程上



### 异步任务

调用Native接口后，收到临时结果，不阻塞应用侧

```
1 Native创建一个异步工作项，置入libuv调度队列中，立即返回临时结果
2 libuv线程池创建并调度work子线程
3 通过Callback回调或Promise延时对象返回处理结果
```



```
NAPI_EXTERN napi_status napi_create_async_work(
napi_env env,
napi_value async_resource,
napi_value async_resource_name,                                   napi_async_execute_callback execute,                             napi_async_complete_callback complete,
void* data,
napi_async_work* result);
```



只需注意execute和complete

#### execute

```
执行业务逻辑，从上下文输入数据，在work子线程中完成，并将结果写入上下文数据

execute不在ArkTS线程中，所以不能调用napi接口，返回值通过complete处理
```



#### complete

```
execute执行完或取消后，通过事件通知EventLoop执行complete
complete从上下文获取结果，转为napi_value类型，返回结果

运行在ArkTS主线程下，可以调用napi接口，将execute封装成ArkTS对象返回
```



Callback异步

```
调用后，返回临时空值

napi_call_function调用ArkTS传过来的回调函数
```



Promise异步





### 线程安全

```
Native侧C++子线程不可跨线程访问ArkTS对象
线程安全函数 —— 保障线程异步执行与通信安全
不会阻塞应用侧
```








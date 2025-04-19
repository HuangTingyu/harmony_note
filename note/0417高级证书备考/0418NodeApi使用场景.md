https://developer.huawei.com/consumer/cn/training/course/slightMooc/C101705084078534051

`NodeApi`使用场景

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



这里`join()`是为了等待producer线程完成，等待consumer线程完成，确保两者的执行顺序

```c++
static void ExecuteFunc([[maybe_unused]] napi_env env, void *data) {
    // create producer thread
    thread producer(ProductElement, data);
    producer.join();
    
    // create consumer thread
    thread consumer(ConsumeElement, data);
    consumer.join();
}
```



#### complete

```
execute执行完或取消后，通过事件通知EventLoop执行complete
complete从上下文获取结果，转为napi_value类型，返回结果

运行在ArkTS主线程下，可以调用napi接口，将execute封装成ArkTS对象返回
```



#### 异步通用操作

```
// 结果计算出来以后，要创建异步工作项
napi_create_async_work

// 然后把async_work将异步任务加入队列，等待调度执行
napi_queue_async_work(env, contextData->asyncWork);
```



#### Callback异步回调

```
调用后，临时返回空值

napi_call_function执行ArkTS传过来的回调函数
```



`completeFuncCallBack`

```c++
 (void)napi_call_function(env, undefined, callBack, 1, &callBackArgs, &callBackResult);
 
 // env上下文
 // undefined ArkTS传来的this指针
 // callBack即将被执行
 // 1 代表只有一个参数
 // &callBackArgs 即将传入callBack的参数
 // &callBackResult 即将返回callBack运行结果
```



`ArkTS`侧调用

```js
testNapi.getImagePathAsyncCallBack(
	this.imageName, 
	(result: string) => {
       this.imagePath = Constants.IMAGE_ROOT_PATH + result;
});
```



#### Promise异步回调

```
调用后，临时返回Promise对象

计算结果以参数形式，提供给与Promise相关的deferred对象，通过napi_resolve_deferred将Promise对象返回给ArkTS

operStatus = napi_resolve_deferred(env, contextData->deferred, promiseArgs);
```



ArkTS调用

```
let promiseObj = testNapi.getImagePathAsyncPromise(this.imageName);

promiseObj.then((result: string) => {
   this.imagePath = Constants.IMAGE_ROOT_PATH + result;
})
```



### 线程安全

```
Native侧C++子线程不可跨线程访问ArkTS对象
线程安全函数 —— 保障线程异步执行与通信安全
不会阻塞应用侧
```



使用场景

- **异步计算：**如果需要进行耗时的计算或IO操作，可以创建一个线程安全函数，将计算或IO操作放在另一个线程中执行，避免阻塞主线程，提高程序的响应速度。
- **数据共享：**如果多个线程需要访问同一份数据，可以创建一个线程安全函数，确保数据的读写操作不会发生竞争条件或死锁等问题。
- **多线程开发：**如果需要进行多线程开发，可以创建一个线程安全函数，确保多个线程之间的通信和同步操作正确无误。





实现步骤

```
1 创建线程安全函数napi_create_threadsafe_function，传入call_js_cb

2 子线程执行napi_call_threadsafe_function，将call_js_cb抛给EventLoop事件循环进行调度

3 call_js_cb执行，将计算结果返回给ArkUI
```



对比1：上面异步的做法，定义两个线程Producer和Consumer，Consumer必须等Producer执行完成

这里用的是`detach`，两个线程是独立的

```c++
 // create producer thread
    thread producer(ProductElement, static_cast<void *>(contextData));
    producer.detach(); // must be detached

    // create consumer thread
    thread consumer(ConsumeElementTSF, static_cast<void *>(contextData));
    consumer.detach();
```



对比2：这里省了一个把异步工作加入`libuv`线程池的操作

只需要把结果跟`callBack`通通交给`napi_create_threadsafe_function`

```js
static void CallJsFunction(...){
                           
 (void)napi_call_function(env, undefined, callBack, 1, &callBackArgs, &callBackResult);

}
```



```
napi_create_threadsafe_function(napi_env env,
......
async_resource_name: 返回结果
......
call_js_cb: 子线程需要处理的线程安全回调任务，类似于异步工作项中的complete回调
)
```



```c++
// 最后调用napi_call_threadSafe_function
// 将call_js_cb抛到EventLoop中等待调度
static void ConsumeElementTSF(void *data) {
    
    (void)napi_call_threadsafe_function(tsFun, data, napi_tsfn_blocking);
    
}
```


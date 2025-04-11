### Preferences

用户首选项

提供Key-Value键值型的数据处理能力

Preferences将数据缓存在内存中

持久化，使用flush将内存中的数据写入持久化文件

存放数量越多，应用占用内存越大，不支持存放过多数据，不支持配置加密



#### 存储注意点

Value为string时，使用UTF-8编码，可以为空，长度不超过16M

非UTF-8，使用Uint8Array存储，否则文件会出现格式错误，造成文件损坏

调用removePreferencesFromCache或者deletePreferences后，订阅取消

不允许deletePreferences与其他接口，多线程、多进程并发调用



#### 调用

preferenceTheme用于存`theme.db`相关的preferences

```typescript
import { preferences } from '@kit.ArkData';

const PREFERENCES_NAME = 'theme.db';
let preferenceTheme: preferences.Preferences | null = null;

let context = getContext(this) as Context
preferenceTheme = await preferences.getPreferences(context, PREFERENCES_NAME)
```



拿到之前存储的key值

```typescript
getSync(key: string, defValue: ValueType): ValueType

getSync第二个参数是默认值，当拿不到value时，函数会返回defValue

theme = await preferenceTheme.get('theme', 'default') as string;
// 这里写的是，如果拿不到theme对应的value，则返回'default'
```



换新的value

```
await preferenceTheme.put('theme', data)
await preferenceTheme.flush()
```



### 关系型数据库

关系型数据库对应用提供通用的操作接口，底层使用SQLite作为持久化存储引擎，支持SQLite具有的数据库特性



注意点

关系型数据库不用flush，数据插入即保存在持久化文件。

当应用被卸载完成后，设备上的相关数据库文件及临时文件会被自动清除。

数据库中有4个读连接和1个写连接，线程获取到空闲读连接时，即可进行读取操作。当没有空闲读连接且有空闲写连接时，会将写连接当做读连接来使用。

为保证数据的准确性，数据库同一时间只能支持一个写操作。

为保证插入并读取数据成功，建议一条数据不要超过2M。超出该大小，插入成功，读取失败。

#### 日志方式/落盘方式

系统默认日志方式是WAL（Write Ahead Log）模式，系统默认落盘方式是FULL模式（完全落盘）

WAL（预写日志）要求在对数据进行修改前，先将操作记录写入持久化的日志文件，确保即使系统崩溃也能通过日志恢复数据一致性

FULL模式指每次事务提交时强制将日志和数据同步到磁盘（fsync操作），确保数据完全持久化

WAL负责记录操作顺序和细节，FULL模式确保日志和数据强制落盘，两者结合既优化了写入性能，又保障了崩溃恢复能力



#### 调用

`relationalStore.getRdbStore`拿到要操作的RedStore

`store.executeSql`执行sql语句

```typescript
import { relationalStore } from '@kit.ArkData'; // 导入模块

relationalStore.getRdbStore(context, STORE_CONFIG, 
(err: BusinessError, 
rdbStore: relationalStore.RdbStore) => {
      this.objectiveRDB = rdbStore;
})

this.objectiveRDB?.execute(SQL)
```



#### context

应用创建的数据库与其上下文（Context）有关，即使使用同样的数据库名称，但不同的应用上下文，会产生多个数据库，例如每个UIAbility都有各自的上下文。



#### RedStore

RedStore可以执行的api

```
insert,update,delete,query
```



insert可以直接插入

```typescript
const sportData: relationalStore.ValuesBucket = {}

await this.objectiveRDB?.insert('PLANS', sportData)
```



update和delete有点不一样

这里的PLANS，数据库存储的数据结构

```typescript
const planData: relationalStore.ValuesBucket = {
      'DURATION': duration,
      'STATUS': status ? '已完成' : '未完成'
    };
    
    let predicates = new relationalStore.RdbPredicates('PLANS');
    predicates.equalTo('ID', planID);
    
    await this.objectiveRDB?.update(planData, predicates)
```

delete

```typescript
let predicates = new relationalStore.RdbPredicates('PLANS');

predicates.equalTo('ID', planID);

await this.objectiveRDB?.delete(predicates)
```



query完记得释放`resultSet`

```
let plansSet: Array<number> = [];

await this.objectiveRDB?.query().then((resultSet: relationalStore.ResultSet) => {
	while (resultSet.goToNextRow()) {
        let duration: number = resultSet.getValue(...) as number;
        plansSet.push(duration);
      }
      resultSet.close();

})
```


文档

https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-motion-path-animation



课程

https://developer.huawei.com/consumer/cn/training/course/slightMooc/C101705081897917056



### 设置位移路径动画`motionPath`

```
Button('click me')
.motionPath({
  path: 'Mstart.x start.y L300 200 L300 500 Lend.x end.y',
  from: 0.0,
  to: 1.0,
  rotatable: true
}) // 执行动画：从起点移动到(300,200)，再到(300,500)，再到终点
```



### 属性动画`animation`

属性改变的时候，可以通过`animation`实现渐变过渡效果

```typescript
Column({ space: this.space })
 .width(this.widthSize) // 只有写在animation前面才生效
 .height(this.heightSize) // 只有写在animation前面才生效
 .animation({
   duration: 2000,
   curve: Curve.EaseOut,
   iterations: 3,
   playMode: PlayMode.Normal
 })
 // .width(this.widthSize) // 动画不生效
 // .height(this.heightSize) // 动画不生效
```



### 显性动画`animateTo`

同样是添加过渡效果的，但这是一个函数，可以在`onClick`等事件中直接调用

```
不推荐在aboutToAppear、aboutToDisappear中调用动画
```



```
// 建议使用this.getUIContext()?.animateTo()
            animateTo({
              duration: 2000,
              curve: Curve.EaseOut,
              iterations: 3,
              playMode: PlayMode.Normal,
              onFinish: () => {
                console.info('play end')
              }
```



### 显示动画立即下发`animateToImmediately`

```
不建议开发者采用animateToImmediately接口，而应选择animateTo，以防止干扰框架的显示时序，避免在动画启动时因状态设置不完整而导致的显示错误

当应用的主线程存在耗时操作，且需提前更新部分用户界面时，此接口可有效缩短应用的响应延迟
```





### 关键帧动画`keyframeAnimateTo`

```typescript
// xxx.ets
import { UIContext } from '@kit.ArkUI';

@Entry
@Component
struct KeyframeDemo {
  @State myScale: number = 1.0;
  uiContext: UIContext | undefined = undefined;

  aboutToAppear() {
    this.uiContext = this.getUIContext?.();
  }

  build() {
    Column() {
      Circle()
        .width(100)
        .height(100)
        .fill("#46B1E3")
        .margin(100)
        .scale({ x: this.myScale, y: this.myScale })
        .onClick(() => {
          if (!this.uiContext) {
            console.info("no uiContext, keyframe failed");
            return;
          }
          this.myScale = 1;
          // 设置关键帧动画整体播放3次
          this.uiContext.keyframeAnimateTo({ iterations: 3 }, [
            {
              // 第一段关键帧动画时长为800ms，scale属性做从1到1.5的动画
              duration: 800,
              event: () => {
                this.myScale = 1.5;
              }
            },
            {
              // 第二段关键帧动画时长为500ms，scale属性做从1.5到1的动画
              duration: 500,
              event: () => {
                this.myScale = 1;
              }
            }
          ]);
        })
    }.width('100%').margin({ top: 5 })
  }
}
```



### 页面间转场效果`pageTransition`

这是一个生命周期，写在`build`外面

```
 pageTransition() {
    PageTransitionEnter({ duration: 1200, curve: Curve.Linear })
      .onEnter((type: RouteType, progress: number) => {})
  
  PageTransitionExit({ duration: 1200, curve: Curve.Ease })
      .onExit((type: RouteType, progress: number) => {})
}
```



### 组件内转场`transition`

```
 Image($r('app.media.testImg')).width(200).height(200)
          .transition(
            TransitionEffect.asymmetric(
              TransitionEffect.OPACITY.animation({ duration: 1000 }).combine(
              TransitionEffect.rotate({ z: 1, angle: 180 }).animation({ delay: 1000, duration: 1000 }))
              ,
              TransitionEffect.OPACITY.animation({ delay: 1000, duration: 1000 }).combine(
              TransitionEffect.rotate({ z: 1, angle: 180 }).animation({ duration: 1000 }))

)
```



如果不使用`asymmetric`，直接添加动画，则入场跟出场会产生一样的动画

```
TransitionEffect.asymmetric(appear, disappear)
```



```
.combine合并多个动画

// 透明度合并旋转
TransitionEffect.OPACITY.combine(TransitionEffect.rotate)
```



```
.animation({ duration: 1000 })

//为每个动画单独设置时长
```



### 转场高级模板

导航转场、共享元素转场、模态转场



### 导航转场`Navigation`

https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-navigation-transition-V5

```
Navigation组件
```





### 共享元素转场`geometryTransition`

（1）转场前跟转场后，`geometryTransition`绑定同样的ID

（2）转场前页面

```
animateTo配合this.pageInfos.pushPath
```



```typescript
private showSearchPage(): void {
    this.transitionEffect = TransitionEffect.OPACITY;
    animateTo({
      curve: curves.interpolatingSpring(0, 1, 342, 38)
    }, () => {
      this.pageInfos.pushPath({ name: 'SearchLongTakeTransitionPageTwo' }, false);
    })
  }


build(){
	Search({ placeholder: 'Search' })
	.geometryTransition('SEARCH_ONE_SHOT_DEMO_TRANSITION_ID', { follow: true })
	.onTouch((event: TouchEvent) => {
            if (event.type === TouchType.Up) {
              this.showSearchPage();
            }
}
```



转场后页面

```typescript
Search({ placeholder: 'DevEco Studio' })
 .geometryTransition('SEARCH_ONE_SHOT_DEMO_TRANSITION_ID')
```



### 模态转场

https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-modal-transition-V5

模态转场是新的界面覆盖在旧的界面上，旧的界面不消失的一种转场方式

```
bindContentCover 全屏模态转场
bindSheet 半模态组件
bindMenu 弹出菜单
bindContextMenu 悬浮菜单
bindPopup 气泡弹窗

上面这些都需要绑在组件上使用
如果想独立开发遮罩层，请通过if新增或删除组件
```



`bindSheet`里面把提前定义好的`Builder`传进去

```
bindSheet(isShow: Optional<boolean>, builder: CustomBuilder, options?: SheetOptions)

//第一个参数，是否显示半模态页面
```



```
@Builder
halfModalLogin() {
	//...
}

build() {
  NavDestination() {
    Column() {
      //The Text component is bound for semi-modal display
      Text()
        .bindSheet($$this.isPresent, this.halfModalLogin(), {}
        }
}
```



### 全模态转场

原理同上，只不过把`bindSheet`换成`bindContentCover`

```
Text()
  .bindContentCover($$this.isPresentInLoginView, this.defaultLogin())
```


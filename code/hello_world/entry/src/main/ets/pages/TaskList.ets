import TaskView from '../view/TaskView'
import ListView from '../view/ListView'

@Entry
@Component
struct TaskList {

  build() {

      Column(){
        Text('待办').fontSize(30).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_title'))
        Text('提高每日效率').fontSize(14).fontColor('#888').margin({top: 14})

        Scroll(){
          Column(){
            Text('我的计划').fontSize(30).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_title'))
              .margin({top: 30})

            //------分割线
            TaskView()
            // ListView()
            Column({space: 10}){
              Row(){
                Text("今日任务").fontSize(26).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_title'))
                Text("查看更多").fontSize(14).fontColor($r('app.color.text_title'))

              }.width("100%")
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Bottom)

              ListView()

            }.width("100%").margin({top: 20})

          }.alignItems(HorizontalAlign.Start).padding({bottom:100})
        }.scrollable(ScrollDirection.Vertical)



        // Row().width(100).height(100).backgroundColor('red')
        //
        // Row().width('100vp').height('100vp').backgroundColor('blue')
        //Column
      }.width('100%')
      .height('100%')
      .backgroundColor('#F6F6F7')
      .alignItems(HorizontalAlign.Start)
      .padding({left: 10, right: 10, top:10, bottom: 10}).expandSafeArea([SafeAreaType.SYSTEM])



    }

}
@Entry
@Component
struct TaskList {

  build() {
      Column(){
        Text('待办').fontSize(30).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_title'))
        Text('提高每日效率').fontSize(14).fontColor('#888').margin({top: 14})

        Text('我的计划').fontSize(30).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_title'))
          .margin({top: 30})

        Row(){
          Column({space: 10}){
            Column({space: 10}){
              Text('已完成').fontWeight(FontWeight.Bold).fontSize(18)
              Text('0任务').fontWeight(FontWeight.Bold).fontSize(18)

            }.height(164).width(168).backgroundColor('#DCEBFD').borderRadius(5).padding(10)

            Column(){
              Text('进行中').fontWeight(FontWeight.Bold).fontSize(18)
              Text('0任务').fontWeight(FontWeight.Bold).fontSize(18)
            }.height(128).width(168).backgroundColor('#F26A62').borderRadius(5).padding(10)

          }.width('50%').height('100%')

          // ------分割线
          Column({space: 10}){

            Column({space: 10}){
              Text('未完成').fontWeight(FontWeight.Bold).fontSize(18)
              Text('0任务').fontWeight(FontWeight.Bold).fontSize(18)

            }.height(130).width(168).backgroundColor('#FFEDDE').borderRadius(5).padding(10)

            Column(){
              Text('未来任务').fontWeight(FontWeight.Bold).fontSize(18)
              Text('0任务').fontWeight(FontWeight.Bold).fontSize(18)
            }.height(162).width(168).backgroundColor('#7FDA98').borderRadius(5).padding(10)

          }.width('50%').height('100%')

        }.width('100%')

        // Row().width(100).height(100).backgroundColor('red')
        //
        // Row().width('100vp').height('100vp').backgroundColor('blue')
        //Column
      }.width('100%')
      .height('100%')
      .backgroundColor('#F6F6F7')
      .alignItems(HorizontalAlign.Start)
      .padding({left: 10, right: 10, top:10, bottom: 10})

    }

}
@Entry
@Component
struct NotesPage {
  @State notes: string[] = ['待办1', '待办2', '待办3']
  @State newNote: string = ''

  addNote(){
    if(this.newNote.trim() !== ''){
      this.notes.push(this.newNote.trim())
    }
    this.newNote = ''

  }


  build(){
    Column(){
      Text('待办清单')
        .fontSize(24)
        .fontColor('#267EF0')
        .margin({top:20, bottom:20})

      TextInput({
        text: this.newNote,
        placeholder: '添加'
      }).onChange((value: string)=>{
        this.newNote = value
      }).width('80%').margin({bottom: 10}).padding(10)
        .fontSize(16).borderColor('#CCC').borderWidth(1).borderRadius(5)

      Button('添加')
        .onClick(()=> this.addNote())
        .width('80%').padding(10).fontSize(16).backgroundColor('#267EF0')
        .fontColor('#FFF').borderRadius(5)

      List(){
        ForEach(this.notes, (item: string, index: number)=>{
          ListItem(){
            Row(){
              Text(item).fontColor('#000')
              Button('删除')
                .onClick(()=>{
                  this.notes.splice(index, 1)
                })
                .fontSize(14).height(18).backgroundColor('#267EF0')
                .type(ButtonType.Normal).borderRadius(5)
            }.width('100%').justifyContent(FlexAlign.SpaceBetween).backgroundColor('#F6F6F7').margin({bottom:5}).padding(5)
            // ListItem
          }
          // ForEach
        })
      }.width('80%').margin({ top: 20 })



      // ------Column
    }.width('100%').height('100%')
  // ------build
  }
}
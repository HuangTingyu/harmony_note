import { rcp } from '@kit.RemoteCommunicationKit'
import {connection} from '@kit.NetworkKit'
import { BusinessError } from '@kit.BasicServicesKit'
async function listenNet(){
  const netConnection = connection.createNetConnection()
  netConnection.on('netAvailable',(data:connection.NetHandle)=>{
    console.info('netConnection')
    console.info(JSON.stringify(data))
  })
}


let session = rcp.createSession()
async function useRcp(){
  try{
    const request = await session.get('https://www.example.com')
    console.info(request.statusCode.toString())
  } catch (e){
    console.error(e.code.toString())
  }
}

async function rcpTest(){
  const netConnection = connection.createNetConnection()
  netConnection.on('netAvailable', async(netHandle: connection.NetHandle)=>{
    session.close()
    session = rcp.createSession()
    useRcp()
  })
  try{
    netConnection.register(()=>{})
    useRcp()
  }catch (e){
    console.error(e.code.toString())
  }
}

@Entry
@Component
struct NavigationExample {
  @State TooTmp: ToolbarItem = {
    'value': "func", 'icon': "./image/ic_public_highlights.svg", 'action': () => {
    }
  }
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  private arr: number[] = [1, 2, 3];

  @Builder
  PageMap(name: string) {
    if (name === "NavDestinationTitle1") {
      pageOneTmp()
    } else if (name === "NavDestinationTitle2") {
      pageTwoTmp()
    } else if (name === "NavDestinationTitle3") {
      pageThreeTmp()
    }
  }
  aboutToAppear(): void {
    listenNet()
  }

  build() {
    Column() {
      Navigation(this.pageInfos) {
        TextInput({ placeholder: 'search...' })
          .width("90%")
          .height(40)
          .backgroundColor('#FFFFFF')

        List({ space: 12 }) {
          ForEach(this.arr, (item: number) => {
            ListItem() {
              Text("Page" + item)
                .width("100%")
                .height(72)
                .backgroundColor('#FFFFFF')
                .borderRadius(24)
                .fontSize(16)
                .fontWeight(500)
                .textAlign(TextAlign.Center)
                .onClick(() => {
                  this.pageInfos.pushPath({ name: "NavDestinationTitle" + item })
                })
            }
          }, (item: number) => item.toString())
        }
        .width("90%")
        .margin({ top: 12 })
      }
      .title("主标题")
      .titleMode(NavigationTitleMode.Full)
      .mode(NavigationMode.Stack)
      .navDestination(this.PageMap)
      .menus([
        {
          value: "", icon: "./image/ic_public_search.svg", action: () => {
        }
        },
        {
          value: "", icon: "./image/ic_public_add.svg", action: () => {
        }
        },
        {
          value: "", icon: "./image/ic_public_add.svg", action: () => {
        }
        },
        {
          value: "", icon: "./image/ic_public_add.svg", action: () => {
        }
        },
        {
          value: "", icon: "./image/ic_public_add.svg", action: () => {
        }
        }
      ])
      .toolbarConfiguration([this.TooTmp, this.TooTmp, this.TooTmp])
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F1F3F5')
  }
}

// PageOne.ets
@Component
export struct pageOneTmp {
  @Consume('pageInfos') pageInfos: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        Text("NavDestinationContent1")
      }.width('100%').height('100%')
    }.title("NavDestinationTitle1")
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}

// PageTwo.ets
@Component
export struct pageTwoTmp {
  @Consume('pageInfos') pageInfos: NavPathStack;

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Center }) {
        Column() {
          Text("Dialog NavDestination")
            .fontSize(20)
            .margin({ bottom: 100 })
          Button("Close").onClick(() => {
            this.pageInfos.pop()
          }).width('30%')
        }
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Color.White)
        .borderRadius(10)
        .height('30%')
        .width('80%')
      }.height("100%").width('100%')
    }
    .backgroundColor('rgba(0,0,0,0.5)')
    .hideTitleBar(true)
    .mode(NavDestinationMode.STANDARD)
  }
}

// PageThree.ets
@Component
export struct pageThreeTmp {
  @Consume('pageInfos') pageInfos: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        Text("NavDestinationContent3")
      }.width('100%').height('100%')
    }.title("NavDestinationTitle3")
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}
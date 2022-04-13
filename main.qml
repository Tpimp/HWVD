import QtQuick 2.15

Rectangle{
    id:space
    property real lowLiquidTemp: 50
    property real highLiquidTemp: 1
    property real lowPumpRpm: 3000
    property real highPumpRpm: 1
    anchors.fill:parent
    Connections {
        target: AppController
        function onDraw() {
            var date = new Date();
            time.text = Qt.formatDateTime(date,"hh:mm")
            seconds.text = Qt.formatDateTime(date,"ss")

        }
    }
    Connections{
        target:KrakenZDriver
        function onPumpSpeedChanged(speed : int) {
            if(speed > space.highPumpRpm) {
                space.highPumpRpm = speed;
            }
            if(speed < space.lowPumpRpm) {
                space.lowPumpRpm = speed;
            }
            pumpSpeedLabel.text = lowPumpRpm + " - " + highPumpRpm;
        }
        function onPumpDutyChanged(duty : int){
            fanSpeedReset.start();
        }
        function onLiquidTemperatureChanged(temp : real) {
            liquidTemp.text = temp.toFixed() + "°C"
            if(temp > space.highLiquidTemp) {
                space.highLiquidTemp = temp;
                highTemp.text = space.highLiquidTemp.toFixed() + "°"
            }
            if(temp < space.lowLiquidTemp) {
                space.lowLiquidTemp = temp;
                lowTemp.text = space.lowLiquidTemp.toFixed() + "°"
            }
        }
    }
    Timer{
        id:fanSpeedReset
        interval:1600
        repeat:false
        property int bounce:0
        onTriggered: {
            ++bounce;
            if(bounce >= 4){
                bounce = 0;
            }else {
                space.lowPumpRpm = 3000
                space.highPumpRpm = 1
                fanSpeedReset.start();
            }
        }
    }

    FontLoader {
        id: clockFont
        source:"fonts/DigifaceWide.ttf"
    }
    Image { // Watch Root UX item
        id: back
        source: "images/back.png"
        fillMode:Image.PreserveAspectFit
        anchors.centerIn: parent
        width:360
        height:360
        Image{
            id:shipIcon
            source:"images/other6.png"
            width:32
            height:28
            fillMode:Image.Stretch
            smooth:true
            anchors{
                top:parent.top
                topMargin:44
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: -48
            }
        }
        Text{
            id:fanDuty
            horizontalAlignment: Text.AlignLeft
            color:"#333333"
            leftPadding:2
            font.pixelSize: 18
            font.bold: true
            font.letterSpacing: 1
            text:KrakenZDriver.fanDuty + "%"
            anchors{
                top:parent.top
                topMargin:69
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: -66
            }
        }
        AnimatedImage {
            id: astronaut
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 18
            width: 108
            height: 120
            fillMode:Image.PreserveAspectFit
            source: "images/human.gif"
            speed: (40/AppController.frameDelay) + .125
            playing:true
        }
        Image{
            id:fanIcon
            source:"images/cpu.fan.png"
            width:24
            height:24
            fillMode:Image.PreserveAspectFit
            anchors.centerIn:parent
            smooth:true
            anchors.verticalCenterOffset: 75
            anchors.horizontalCenterOffset: 46
        }
        Text{
            id:fanRpm
            horizontalAlignment: Text.AlignLeft
            color:"#333333"
            leftPadding:3
            font.pixelSize: 22
            font.bold:true
            font.letterSpacing: 1
            text: KrakenZDriver.fanSpeed
            anchors{
                left:fanIcon.right
                verticalCenter: fanIcon.verticalCenter
                verticalCenterOffset:2
            }
        }
        Image{
            id:heartIcon
            source:"images/other1.png"
            width:36
            height:36
            fillMode:Image.PreserveAspectFit
            smooth:true
            anchors
            {
                left:parent.left
                bottom:parent.bottom
                bottomMargin: 86
                leftMargin:54
            }
        }
        Text{
            id:pumpDuty
            horizontalAlignment: Text.AlignLeft
            color:"#333333"
            leftPadding:2
            font.pixelSize: 20
            font.bold:true
            text:KrakenZDriver.pumpDuty
            anchors{
                left:heartIcon.right
                verticalCenter: heartIcon.verticalCenter
            }
        }
        Text{
            id:pumpSpeedLabel
            horizontalAlignment: Text.AlignLeft
            color:"#333333"
            leftPadding:2
            font.pixelSize: 12
            anchors{
                bottom:heartIcon.top
                bottomMargin:-2
                horizontalCenter: heartIcon.horizontalCenter
                horizontalCenterOffset: 6
            }
        }
        Text{
            id:liquidTemp
            horizontalAlignment: Text.AlignLeft
            color:"#333333"
            leftPadding:2
            font.pixelSize: 13
            font.letterSpacing: 1
            anchors{
                top:parent.top
                topMargin:70
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: -4
            }
        }
        Text{
            id:tempHeader
            horizontalAlignment: Text.AlignLeft
            color:"#333333"
            leftPadding:2
            font.pixelSize: 14
            font.letterSpacing: 1
            font.weight: Font.Light
            text: "晴天"
            anchors{
                top:parent.top
                topMargin:52
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: -4
            }
        }
        Text{
            id:airQuality
            horizontalAlignment: Text.AlignLeft
            color:"#333333"
            font.pixelSize: 14
            font.letterSpacing: -2
            font.weight: Font.Light
            text: "空气优质"
            anchors{
                top:parent.top
                topMargin:34
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: 6
            }
        }

        Text{
            id:highTemp
            horizontalAlignment: Text.AlignLeft
            color:"#333333"
            leftPadding:2
            font.pixelSize: 13
            font.letterSpacing: 1
            anchors{
                top:parent.top
                topMargin:54
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset:32
            }
        }
        Image{
            id:upArrow
            source:"images/arrow.png"
            rotation:180
            height:15
            smooth:true
            fillMode: Image.PreserveAspectFit
            anchors{
                verticalCenter: highTemp.verticalCenter
                left: highTemp.right
            }
        }

        Text{
            id:lowTemp
            horizontalAlignment: Text.AlignLeft
            color:"#333333"
            leftPadding:2
            font.pixelSize: 13
            font.letterSpacing: 1
            anchors{
                top:parent.top
                topMargin:71
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: 32
            }
        }
        Image{
            id:downArrow
            source:"images/arrow.png"
            height:15
            smooth:true
            fillMode: Image.PreserveAspectFit
            anchors{
                verticalCenter: lowTemp.verticalCenter
                left: lowTemp.right
            }
        }
    }
    Text {
        id:time
        y:62
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -24
        verticalAlignment: Text.AlignVCenter
        font.family: clockFont.name
        font.letterSpacing: -2
        font.weight: Font.Light
        font.pixelSize: 58
    }
    Text{
        id:seconds
        y:92
        x:232
        font.family: clockFont.name
        font.letterSpacing: -1
        font.weight: Font.Light
        font.pixelSize: 32
    }
    Component.onCompleted: {
        AppController.setFrameDelay(85);
        var temp = KrakenZDriver.liquidTemperature.toFixed() + "°";
        liquidTemp.text = temp + "C";
        lowTemp.text = temp;
        highTemp.text = temp;

    }
}

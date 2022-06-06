import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id:window
    width: 320
    height: 320
    flags:Qt.FramelessWindowHint | Qt.WA_TranslucentBackground
    MouseArea
    {
        anchors.fill: parent
        property int m_x : 0;
        property int m_y : 0;
        onPressed:
        {
            if(previewMode.item) {
                previewMode.item.showOverlay();
            }
            this.m_x = mouse.x;
            this.m_y = mouse.y;
        }
        onPositionChanged:
        {
            window.x = window.x + mouse.x - this.m_x
            window.y = window.y + mouse.y - this.m_y
        }
    }
}

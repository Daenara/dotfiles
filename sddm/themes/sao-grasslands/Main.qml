import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    width: 1024
    height: 768
    property int sessionIndex: session.index
    TextConstants { id: textConstants }

    Connections {
        target: sddm
        onLoginSucceeded: {
        }
        onLoginFailed: {
            txtMessage.text = textConstants.loginFailed
            password.text = ""
        }
    }

    /********************************
               Background
    *********************************/
    Background {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspect
    }

    /*******************************
               Foreground
    ********************************/
    Rectangle {
        visible: primaryScreen
        property variant geometry: screenModel.geometry(screenModel.primary)
        x: geometry.x; y: geometry.y; width: geometry.width; height: geometry.height
        color: "transparent"
	/********* Message Popup ********/
	Rectangle {
	    id: messagePopup
	    width: 300
	    height: 214
	    Image{
	        id: messageImage
	        anchors.fill: parent
                source: "resources/message.png"
            }
            Text {
                id: txtMessage
                anchors.horizontalCenter: parent.horizontalCenter
                y: 40
                text: textConstraints.promt
                font.pixelSize: 10
            } 
	}
        /********* Login Box *********/
        Rectangle {
            id: loginBox
            anchors.fill: parent
            color: "transparent"
            Column {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: 200
                height: 80
                spacing: 6
                /*** Username ***/
                Rectangle {
                    width: parent.width
                    height: 32
                    color: "transparent"
                    Image {
                        id: userimage
                        anchors.fill: parent
                        source: "resources/user.png"
                    }
                    TextInput {
                        id: name
                        y: 9; x: 36
                        width: 160; height: 16
                        text: userModel.lastUser
                        font.pixelSize: 12
                        autoScroll: false
                        KeyNavigation.backtab: btnShutdown; KeyNavigation.tab: password
                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, session.index)
                                event.accepted = true
                            }
                        }
                    }
                }
                /*** Password ***/
                Rectangle {
                    width: parent.width
                    height: 32
                    color: "transparent"
                    Image {
                        id: passwordimage
                        anchors.fill: parent
                        source: "resources/passwd.png"
                    }
                    PasswordBox {
                        id: password
                        y: 8; x: 28
                        width: 160; height: 16
                        color: "transparent"
                        borderColor: "transparent"
                        focusColor: "transparent"
                        hoverColor: "transparent"
                        font.pixelSize: 12
			Timer {
				interval: 200
				running: true
				onTriggered: password.forceActiveFocus()
			}
                        KeyNavigation.backtab: name; KeyNavigation.tab: session
                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, session.index)
                                event.accepted = true
                            }
                        }
                    }
                }
            }
            /***  Buttons ***/
            Column {
                id: buttons
                anchors.top: parent.top
                anchors.topMargin: parent.height*0.10
                anchors.left: parent.left
                anchors.leftMargin: parent.width*0.05
                spacing: 4
                height: 26

                ImageButton {
                    id: session
                    width: parent.height
                    source: "resources/session.png"
                    
                    onClicked: if (menu_session.state === "visible") menu_session.state = ""; else menu_session.state = "visible"
                    KeyNavigation.backtab: password; KeyNavigation.tab: btnSuspend
                }
                ImageButton {
                    id: btnSuspend
                    width: parent.height
                    source: "resources/suspend.png"

                    visible: sddm.canSuspend
                    onClicked: sddm.suspend()
                    KeyNavigation.backtab: session; KeyNavigation.tab: btnHibernate
                }
                ImageButton {
                    id: btnHibernate
                    width: parent.height
                    source: "resources/hibernate.png"

                    visible: sddm.canHibernate
                    onClicked: sddm.hibernate()
                    KeyNavigation.backtab: btnSuspend; KeyNavigation.tab: btnReboot
                }
                ImageButton {
                    id: btnReboot
                    width: parent.height
                    source: "resources/reboot.png"

                    visible: sddm.canReboot
                    onClicked: sddm.reboot()
                    KeyNavigation.backtab: btnHibernate; KeyNavigation.tab: btnShutdown
                }
                ImageButton {
                    id: btnShutdown
                    width: parent.height
                    source: "resources/power.png"

                    visible: sddm.canPowerOff
                    onClicked: sddm.powerOff()
                    KeyNavigation.backtab: btnReboot; KeyNavigation.tab: name
                }
            }
            Menu {
                id: menu_session
                anchors.left: buttons.right
                anchors.top: buttons.verticalCenter
                anchors.leftMargin: 6
                width: 100
                model: sessionModel
                index: sessionModel.lastIndex
            }
        }
    }
}

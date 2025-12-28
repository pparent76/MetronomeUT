import Lomiri.Content 1.3
import Lomiri.Components 1.3 as UBC
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12


Item {
    id: window
    visible: true
    width: 400
    height: 600

    // Thème sombre
    Rectangle {
        anchors.fill: parent
        color: "#1E1E1E"
    }

    Column {
        anchors.fill: parent
        anchors.margins: units.gu(4)
        anchors.topMargin: units.gu(6)
        spacing: units.gu(3.5)

        // --- LOGO METRONOME ---
        Image {
            height: units.gu(12)
            source: "img/metronom.png"
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // --- VOLUME ---
                Text {
                    id:volumeTitle
                    text: "Volume"
                    color:"white"
                    font.pixelSize: units.gu(3)
                }
        Row {
             id:itemVolume
             spacing: units.gu(2)
             width: parent.width
                Slider {
                    id: volumeSlider
                    width: itemVolume.width - volumeLabel.width - itemVolume.spacing
                    from: 1
                    to: 100
                    value: 60
                    onValueChanged: {
                        volumeLabel.text = Math.round(value)
                        timer.setVolume(value)
                    }
                    background: Rectangle {
                        height: units.gu(0.8)
                        radius:  units.gu(0.1)
                        y: (volumeSlider.height - height) / 2
                        color: "#444"    // piste non remplie

                        Rectangle {
                            width: volumeSlider.visualPosition * parent.width
                            height: parent.height
                            radius: units.gu(0.1)
                            color: "#00BFFF"    // piste remplie
                        }
                    }
                }
                Text {
                    id: volumeLabel
                    text: "60"
                    width: units.gu(2.5)
                    color:"white"
                    font.pixelSize: units.gu(2.5)
                }
            }
                Text {
                    id: tempotitle
                    text: "Tempo"
                    color:"white"
                    font.pixelSize: units.gu(3)
                }
        Row {
        width: parent.width
        Slider {
                    id: bpmSlider
                    width: parent.width
                    from: 20
                    to: 250
                    value: 100 
                    onValueChanged: {
                        bpmSpin.value = value
                        timer.setTickingValue(value)
                    }
                    background: Rectangle {
                        height: units.gu(0.8)
                        radius:  units.gu(0.1)
                        y: (bpmSlider.height - height) / 2
                        color: "#444"    // piste non remplie

                        Rectangle {
                            width: bpmSlider.visualPosition * parent.width
                            height: parent.height
                            radius: units.gu(0.1)
                            color: "#00BFFF"    // piste remplie
                        }
                    }
                }     
        }
        // --- BPM ---
       Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: units.gu(2)
                SpinBox {
                    id: bpmSpin
                    from: 20
                    to: 250
                    value: 100
                    onValueChanged: bpmSlider.value = value
                    background: Rectangle { color: theme.palette.normal.background; radius: 4 }
                    font.pixelSize: units.gu(3.5)
                }

                Text {
                    id:bpmtext
                    text: "BPM"
                    color: "white"
                    font.pixelSize: units.gu(3.5)
                }
            }

        Row {
            spacing: units.gu(1)
            anchors.topMargin: units.gu(5)
        Text{
            text: "Stress first beat"
            color: "white" 
            font.pixelSize: units.gu(2.5)
        }   
        // --- FIRST BEAT ---
        UBC.CheckBox {
            id: stressCheck
            checked: false
            // indicator: Rectangle {
            //     width: units.gu(1.6); height: units.gu(1.6); radius: units.gu(0.4)
            //     border.color: "#DDD"
            //     color: stressCheck.checked ? "#00BFFF" : "transparent"
            // }
           // font.pixelSize: units.gu(1.4)
           onCheckedChanged: {
               if (checked)
               {
                   timer.stressBeat(beatsCombo.currentIndex + 2)
               }
               else
               {
                   timer.stressBeat(0)
               }
           }
        }
        }
        // --- NUMBER OF BEATS PER MEASURE ---
        Row {
            visible: stressCheck.checked
            spacing: units.gu(1)

            Label {
                text: "Beats per measure:"
                color: "#DDD"
                font.pixelSize: units.gu(2.5)
            }

            ComboBox {
                id: beatsCombo
                model: [2,3,4,5,6,7,8,9,10,11,12,13,15,16]
                currentIndex: 2 // default 4
                width: units.gu(10)
                onCurrentIndexChanged: {
                                if (stressCheck.checked)
                                {
                                    timer.stressBeat(currentIndex + 2)
                                }
                                else
                                {
                                    timer.stressBeat(0)
                                }   
                }
                background: Rectangle { color: "#333"; radius: 4 }
                palette {
                        text: "black"       // couleur du texte
                        button: "#555"      // couleur des boutons (optionnel)
                }
                contentItem: Text {
                    text: beatsCombo.displayText      // texte affiché
                    color: "white"                    // couleur fixe hors édition
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: units.gu(2.5)
                }
            }
        }
        
    }
    
    Row{
            spacing: units.gu(2)
            anchors.bottom:parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: units.gu(5)
            Button {
                id: startButton
                text: "Start"
                background: Rectangle { color: "#00BFFF"; radius: units.gu(0.8) }
                 
                onClicked: 
                {timer.startTimer();
                startButton.visible=false;
                stopButton.visible=true;
                }
                font.pixelSize: units.gu(5)
            }

            Button {
                id: stopButton
                text: "Stop"
                visible:false
                background: Rectangle { color: "#FF4C4C"; radius: units.gu(0.8) }
                onClicked:{ 
                timer.stopTimer()
                startButton.visible=true;
                stopButton.visible=false;
                }
                font.pixelSize: units.gu(5)
            }
        }  
}

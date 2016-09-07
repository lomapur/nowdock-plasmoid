import QtQuick 2.0
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.kquickcontrolsaddons 2.0 as KQuickControlAddons

Component {
    id: imageBufferingComponent
    Item {
        id: yourImageWithLoadedIconContainer
        anchors.fill: parent

        visible: false

        property QtObject imageTimer

        function updateImage(){
            if(!imageTimer)
                imageTimer = tttTimer.createObject(iconImage);
        }

        Item{
            id:fixedIcon2

            width: middleZoomFactor * (panel.iconSize + 2*shadowImageNoActive.radius)
            height: width
            visible:false

            //property real middleZoomFactor: (panel.iconSize == 32) ? (panel.zoomFactor > 1.5 ? 2 : 1.5) : panel.zoomFactor
            property real middleZoomFactor: panel.zoomFactor

            KQuickControlAddons.QIconItem{
                //    PlasmaCore.IconItem{
                id: iconImage2

                width: fixedIcon2.middleZoomFactor * panel.iconSize
                height: width
                anchors.centerIn: parent

                icon: decoration
                state: KQuickControlAddons.QIconItem.DefaultState
                //     active: false
                enabled: true
                //     source: decoration
                //    usesPlasmaTheme: false

                visible: true
            }
        }


        Item{
            id:fixedIcon

            width: panel.iconSize + 2*shadowImageNoActive.radius
            height: width

            visible:false

            KQuickControlAddons.QIconItem{
                //  PlasmaCore.IconItem{
                id: iconImage

                width: panel.iconSize
                height: width
                anchors.centerIn: parent

                icon: decoration
                state: KQuickControlAddons.QIconItem.DefaultState
                //   active: false
                enabled: true
                //   source: decoration
                //  usesPlasmaTheme: false

                visible: true

                //    onSourceChanged: {
                //   centralItem.updateImages();
                //  }
                /*  onIconChanged: {
                         centralItem.updateImages();
                    }*/

                Component{
                    id:tttTimer

                    Timer{
                        id:ttt
                        repeat:false
                        interval: centralItem.shadowInterval

                        //   property int counter2: 0;

                        onTriggered: {
                            if((index !== -1) &&(!centralItem.toBeDestroyed) &&(!mainItemContainer.delayingRemove)){
                                if(panel.initializationStep){
                                    panel.initializationStep = false;
                                }

                                centralItem.firstDrawed = true;
                                if(normalImage.source)
                                    normalImage.source.destroy();
                                if(zoomedImage.source)
                                    zoomedImage.source.destroy();
                                if(iconImageBuffer.source)
                                    iconImageBuffer.source.destroy();

                                if(panel.enableShadows == true){
                                    shadowImageNoActive.grabToImage(function(result) {
                                        normalImage.source = result.url;
                                        result.destroy();
                                    }, Qt.size(fixedIcon.width,fixedIcon.height) );

                                    shadowImageNoActive2.grabToImage(function(result) {
                                        zoomedImage.source = result.url;
                                        result.destroy();
                                    }, Qt.size(fixedIcon2.width,fixedIcon2.height) );
                                }
                                else{
                                    fixedIcon.grabToImage(function(result) {
                                        normalImage.source = result.url;
                                        result.destroy();
                                    }, Qt.size(fixedIcon.width,fixedIcon.height) );

                                    fixedIcon2.grabToImage(function(result) {
                                        zoomedImage.source = result.url;
                                        result.destroy();
                                    }, Qt.size(fixedIcon2.width,fixedIcon2.height) );
                                }


                                mainItemContainer.buffersAreReady = true;
                                if(!panel.initializatedBuffers)
                                    panel.noInitCreatedBuffers++;

                                iconImageBuffer.opacity = 1;
                            }

                            ttt.destroy(300);
                        }

                        Component.onCompleted: ttt.start();

                        Component.onDestruction: {
                            if(normalImage.source)
                                normalImage.source.destroy();
                            if(zoomedImage.source)
                                zoomedImage.source.destroy();
                            if(iconImageBuffer.source)
                                iconImageBuffer.source.destroy();

                            if(removingAnimation.removingItem)
                                removingAnimation.removingItem.destroy();

                            gc();

                            //                                yourImageWithLoadedIconContainer.destroy();
                        }
                    }// end of timer

                }//end of component of timer

                Component.onCompleted: {
                    yourImageWithLoadedIconContainer.updateImage();
                }
            }
        }

        DropShadow {
            id:shadowImageNoActive
            visible: false
            width: fixedIcon.width
            height: fixedIcon.height
            anchors.centerIn: fixedIcon

            radius: centralItem.shadowSize
            samples: 2 * radius
            color: "#cc080808"
            source: fixedIcon

            verticalOffset: 2
        }

        DropShadow {
            id:shadowImageNoActive2
            visible: false
            width: fixedIcon2.width
            height: fixedIcon2.height
            anchors.centerIn: fixedIcon2

            radius: Math.ceil(panel.zoomFactor*centralItem.shadowSize)
            samples: 2 * radius
            color: "#cc080808"
            source: fixedIcon2

            verticalOffset: 2
        }

    }
}

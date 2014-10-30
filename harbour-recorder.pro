# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-recorder

CONFIG += sailfishapp

SOURCES += src/harbour-recorder.cpp \
    src/codecsetting.cpp

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    rpm/harbour-recorder.spec \
    rpm/harbour-recorder.yaml \
    harbour-recorder.desktop \
    qml/stop.png \
    qml/record.png \
    qml/pages/Settings.qml \
    qml/harbour-recorder.qml \
    qml/util/Popup.qml

HEADERS += \
    src/harbour-recorder.h \
    src/codecsetting.h

QT +=\
    multimedia

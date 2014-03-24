# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = Recorder

CONFIG += sailfishapp

SOURCES += src/Recorder.cpp

OTHER_FILES += qml/Recorder.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    rpm/Recorder.spec \
    rpm/Recorder.yaml \
    Recorder.desktop \
    img/stop.png \
    img/record.png \
    qml/pages/Settings.qml

HEADERS += \
    src/recorder.h

QT +=\
    multimedia


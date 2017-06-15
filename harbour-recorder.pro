# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-recorder

CONFIG += \
    sailfishapp \
    sailfishapp_i18n

appicons.path = /usr/share/icons/hicolor
appicons.files = appicons/*

INSTALLS += appicons

HEADERS += \
    src/recorder.h \
    src/recordingsmodel.h

SOURCES += \
    src/harbour-recorder.cpp \
    src/recorder.cpp \
    src/recordingsmodel.cpp

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/Settings.qml \
    qml/harbour-recorder.qml \
    qml/pages/RenameDialog.qml \
    qml/pages/MigrationPage.qml \
    qml/components/RecordingPlayer.qml \
    qml/components/RecordingDelegate.qml \
    appicons/86x86/apps/harbour-recorder.png \
    appicons/108x108/apps/harbour-recorder.png \
    appicons/128x128/apps/harbour-recorder.png \
    appicons/256x256/apps/harbour-recorder.png \
    rpm/harbour-recorder.spec \
    harbour-recorder.desktop \
    translations/*.ts \
    qml/icons/*.png

QT +=\
    multimedia

TRANSLATIONS += \
    translations/harbour-recorder-ru.ts

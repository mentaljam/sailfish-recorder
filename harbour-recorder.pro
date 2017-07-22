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

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

HEADERS += \
    src/recorder.h \
    src/recordingsmodel.h \
    src/directorymodel.h

SOURCES += \
    src/harbour-recorder.cpp \
    src/recorder.cpp \
    src/recordingsmodel.cpp \
    src/directorymodel.cpp

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/Settings.qml \
    qml/harbour-recorder.qml \
    qml/pages/RenameDialog.qml \
    qml/pages/MigrationPage.qml \
    qml/pages/LocationPage.qml \
    qml/pages/NewDirectoryPage.qml \
    qml/components/RecordingPlayer.qml \
    qml/components/RecordingDelegate.qml \
    rpm/harbour-recorder.spec \
    harbour-recorder.desktop \
    translations/*.ts \
    qml/icons/*.png

QT +=\
    multimedia

TRANSLATIONS += \
    translations/harbour-recorder-ru.ts

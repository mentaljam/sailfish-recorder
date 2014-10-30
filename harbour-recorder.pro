TARGET = harbour-recorder

CONFIG += \
    sailfishapp \
    sailfishapp_i18n

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

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
    qml/harbour-recorder.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/Settings.qml \
    qml/pages/RenameDialog.qml \
    qml/pages/LocationPage.qml \
    qml/pages/NewDirectoryPage.qml \
    qml/pages/Share.qml \
    qml/components/RecordingPlayer.qml \
    qml/components/RecordingDelegate.qml \
    rpm/harbour-recorder.spec \
    rpm/harbour-recorder.changes \
    harbour-recorder.desktop \
    translations/*.ts \
    qml/icons/*.png \
    .tx/config

QT +=\
    multimedia

TRANSLATIONS += \
    translations/harbour-recorder-de.ts \
    translations/harbour-recorder-el.ts \
    translations/harbour-recorder-es.ts \
    translations/harbour-recorder-fi.ts \
    translations/harbour-recorder-fr.ts \
    translations/harbour-recorder-hu.ts \
    translations/harbour-recorder-it.ts \
    translations/harbour-recorder-nl.ts \
    translations/harbour-recorder-nl_BE.ts \
    translations/harbour-recorder-pt_BR.ts \
    translations/harbour-recorder-ru.ts \
    translations/harbour-recorder-sv.ts \
    translations/harbour-recorder-zh_CN.ts \
    translations/harbour-recorder-zh_TW.ts


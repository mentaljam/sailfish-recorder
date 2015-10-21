/*
    A simple audio recording tool.
    Copyright (C) 2014  Corné Dorrestijn

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <QtQuick>
#include "harbour-recorder.h"
#include <sailfishapp.h>

const QString Recorder::oldStoragePath = "/Recordings";
const QString Recorder::defaultStoragePath = "/Documents/Recordings";


int main(int argc, char *argv[])
{
    // SailfishApp::main() will display "qml/template.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //
    // To display the view, call "show()" (will show fullscreen on device).

    qmlRegisterType<Recorder>("harbour.recorder.Recorder", 1, 0, "Recorder");

    return SailfishApp::main(argc, argv);
}

Recorder::Recorder(QObject *parent) : QObject(parent) {
    QCoreApplication::setOrganizationName("harbour-recorder");
    QCoreApplication::setOrganizationDomain("www.corne.info");
    QCoreApplication::setApplicationName("Recorder");

    audioRecorder = new QAudioRecorder(this);
    curRecordingState = 0;

    codecSettingsMap.insert("Vorbis", CodecSetting("audio/vorbis", ".ogg", "ogg"));
    codecSettingsMap.insert("Speex", CodecSetting("audio/speex", ".oga", "ogg"));
    codecSettingsMap.insert("FLAC", CodecSetting("audio/FLAC", ".flac", "raw"));
    codecSettingsMap.insert("PCM", CodecSetting("audio/PCM", ".wav", "wav"));
}

int Recorder::recordingState() {
    return curRecordingState;
}

QStringList Recorder::getExistingFiles() {
    QDir dir(getLocation());
    dir.setSorting(QDir::Time);
    dir.setFilter(QDir::Files);
    QStringList list = dir.entryList();
    return list;
}

void Recorder::removeFile(QString filename) {
    QFile(getLocation() + "/" + filename).remove();
}

void Recorder::renameFile(QString oldFilename, QString newFilename) {
    QFile(getLocation() + "/" + oldFilename).rename(getLocation() + "/" + newFilename);
}

QString Recorder::startRecording() {
    if(audioRecorder->state() == QMediaRecorder::StoppedState) {
        QSettings qsettings;
        QDateTime currentDate = QDateTime::currentDateTime();
        QString selectedCodec = qsettings.value("recorder/codecname").toString();
        CodecSetting codec = codecSettingsMap.value(selectedCodec);

        QString location = getLocation() + "/recording-" + currentDate.toString("yyyyMMddHHmmss") + codec.getExtension();

        if(!QDir(getLocation()).exists()) {
            bool madeDirs = QDir().mkpath(getLocation());
            if(!madeDirs) {
                return "nofolder";
            }
        }

        QAudioEncoderSettings settings;
        settings.setCodec(codec.getCodec());
        settings.setEncodingMode(QMultimedia::TwoPassEncoding);
        settings.setQuality(QMultimedia::HighQuality);

        audioRecorder->setAudioInput("pulseaudio:");
        audioRecorder->setEncodingSettings(settings);
        audioRecorder->setOutputLocation(QUrl(location));
        audioRecorder->setContainerFormat(codec.getContainer());

        audioRecorder->record();
        curRecordingState = 1;
        emit recordingChanged();
        return "recording";
    }
    return "recording";
}


void Recorder::pauseRecording() {
    curRecordingState = 2;
    audioRecorder->pause();
    emit recordingChanged();
}

void Recorder::resumeRecording() {
    curRecordingState = 1;
    audioRecorder->record();
    emit recordingChanged();
}

void Recorder::stopRecordingDelayed() {
    audioRecorder->stop();
    curRecordingState = 0;
    emit recordingChanged();
}

void Recorder::stopRecording() {
    // doesnt work in cover?
    // if(audioRecorder->state() == QMediaRecorder::RecordingState) {

    QTimer::singleShot(1000, this, SLOT(stopRecordingDelayed()));

    // }
}

void Recorder::setLocation(QString location) {
    QSettings settings;
    settings.setValue("recorder/fileLocation", location);
}

QString Recorder::getLocation() {
    QSettings settings;
    return settings.value("recorder/fileLocation",  QDir::homePath() + Recorder::defaultStoragePath).toString();
}

void Recorder::setCodec(QString codec, int index) {
    QSettings settings;
    settings.setValue("recorder/codecindex", index);
    settings.setValue("recorder/codecname", codec);
}

int Recorder::getCodecIndex() {
    QSettings settings;
    return settings.value("recorder/codecindex", 2).toInt();
}

bool Recorder::shouldMigrate() {
    QSettings settings;

    if (settings.value("recorder/migrate-1", false).toBool()) {
        return false;
    }
    settings.setValue("recorder/migrate-1", true);

    if (!settings.value("recorder/fileLocation").toString().compare(QDir::homePath() + Recorder::oldStoragePath) == 0) {
        // The user has set up a custom folder, don't run the migration
        return false;
    }

    // If the old directory exists, migrate the files.
    QDir dir(QDir::homePath() + Recorder::oldStoragePath);
    return dir.exists();
}

bool Recorder::migrate() {
    QSettings settings;
    QDir dir;

    bool result = dir.rename(QDir::homePath() + Recorder::oldStoragePath, QDir::homePath() + Recorder::defaultStoragePath);

    if (result) {
        settings.setValue("recorder/fileLocation", QDir::homePath() + Recorder::defaultStoragePath);
    }

    return result;
}

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
    QCoreApplication::setOrganizationName("corne.info");
    QCoreApplication::setOrganizationDomain("www.corne.info");
    QCoreApplication::setApplicationName("Recorder");

    audioRecorder = new QAudioRecorder(this);
    curRecordingState = 0;
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

        QString extention = qsettings.value("recorder/extension", ".wav").toString();
        QString codec = qsettings.value("recorder/codec", "audio/PCM").toString();

        QString location = getLocation() + "/recording-" + currentDate.toString("yyyyMMddHHmmss") + extention;

        if(!QDir(getLocation()).exists()) {
            bool madeDirs = QDir().mkpath(getLocation());
            if(!madeDirs) {
                return "nofolder";
            }
        }

        QAudioEncoderSettings settings;
        settings.setCodec(codec);
        settings.setEncodingMode(QMultimedia::ConstantBitRateEncoding);
        settings.setQuality(QMultimedia::HighQuality);

        audioRecorder->setAudioInput("pulseaudio:");

        audioRecorder->setEncodingSettings(settings);
        audioRecorder->setOutputLocation(QUrl(location));
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
    return settings.value("recorder/fileLocation",  QDir::homePath() + "/Recordings").toString();
}

void Recorder::setCodec(QString codec, int index) {
    QSettings settings;
    settings.setValue("recorder/codecindex", index);
    if(codec.compare("Vorbis") == 0) {
        settings.setValue("recorder/codec", "audio/vorbis");
        settings.setValue("recorder/extension", ".ogg");
    } else if(codec.compare("Speex") == 0) {
        settings.setValue("recorder/codec", "audio/speex");
        settings.setValue("recorder/extension", ".spx");
    } else if(codec.compare("FLAC") == 0) {
        settings.setValue("recorder/codec", "audio/FLAC");
        settings.setValue("recorder/extension", ".flac");
    } else {
        settings.setValue("recorder/codec", "audio/PCM");
        settings.setValue("recorder/extension", ".wav");
    }
}

int Recorder::getCodecIndex() {
    QSettings settings;
    return settings.value("recorder/codecindex", 2).toInt();
}

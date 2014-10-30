#ifndef RECORDER_H
#define RECORDER_H

#include <QtMultimedia/QAudioRecorder>
#include "codecsetting.h"


class Recorder : public QObject {
    Q_OBJECT
    Q_PROPERTY ( int recordingState READ recordingState NOTIFY recordingChanged)
private:
    QAudioRecorder * audioRecorder;
    QHash<QString, CodecSetting> codecSettingsMap;
public slots:
    void stopRecordingDelayed();
public:
    explicit Recorder(QObject* parent = 0) ;
    ~Recorder() {}
    int curRecordingState;
    Q_INVOKABLE void pauseRecording();
    Q_INVOKABLE void resumeRecording();
    Q_INVOKABLE void stopRecording();
    Q_INVOKABLE void setLocation(QString);
    Q_INVOKABLE void setCodec(QString, int);
    Q_INVOKABLE void removeFile(QString);
    Q_INVOKABLE void renameFile(QString, QString);
    Q_INVOKABLE int recordingState();
    Q_INVOKABLE QString startRecording();
    Q_INVOKABLE QString getLocation();
    Q_INVOKABLE int getCodecIndex();
    Q_INVOKABLE QStringList getExistingFiles();
signals:
    void pathCreationFailed();
    void recordingChanged();
};

#endif // RECORDER_H

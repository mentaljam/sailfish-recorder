#ifndef RECORDER_H
#define RECORDER_H

#include <QtMultimedia/QAudioRecorder>


class Recorder : public QObject {
    Q_OBJECT
    Q_PROPERTY ( bool isRecording READ isRecording NOTIFY recordingChanged)
private:
    QAudioRecorder * audioRecorder;
public:
    explicit Recorder(QObject* parent = 0) ;
    ~Recorder() {}
    bool recording;
    Q_INVOKABLE void stopRecording();
    Q_INVOKABLE void setLocation(QString);
    Q_INVOKABLE bool isRecording();
    Q_INVOKABLE QString startRecording();
    Q_INVOKABLE QString getLocation();
signals:
    void pathCreationFailed();
    void recordingChanged();
};

#endif // RECORDER_H

#include "recorder.h"
#include "recordingsmodel.h"
#include <QDir>
#include <QDateTime>
#include <QUrl>

#define FILE_LOCATION QStringLiteral("recorder/fileLocation")
#define SAMPLE_RATE   QStringLiteral("recorder/samplerate")
#define ENCOD_QUALITY QStringLiteral("recorder/encodingquality")
#define ENCOD_MODE    QStringLiteral("recorder/encodingmode")
#define MIGRATE1      QStringLiteral("recorder/migrate-1")
#define CODEC         QStringLiteral("recorder/codecindex")
#define RECURSIVE     QStringLiteral("recorder/recursiveSearch")


const QString Recorder::defaultStoragePath = QDir::homePath().append("/Documents/Recordings");

Recorder::Recorder(QObject *parent) :
    QAudioRecorder(parent),
    codecSettingsMap{
        { Vorbis, {"audio/vorbis", ".ogg",  "ogg"} },
        { Speex,  {"audio/speex",  ".oga",  "ogg"} },
        { PCM,    {"audio/PCM",    ".wav",  "wav"} },
        { FLAC,   {"audio/FLAC",   ".flac", "raw"} }
    }
{
    this->setAudioInput("pulseaudio:");
    connect(this, &Recorder::durationChanged, this, &Recorder::durationLabelChanged);
    QDir media(QStringLiteral("/media/sdcard"));
    auto mediaEntries = media.entryList(QDir::Dirs | QDir::NoDotAndDotDot);
    // If SD Card is not mounted mediaEntries will be empty
    if (!mediaEntries.empty())
    {
        mSdCardPath = media.absoluteFilePath(mediaEntries.first());
    }
}

RecordingsModel *Recorder::recordingsModel() const
{
    return mRecordingsModel;
}

void Recorder::setRecordingsModel(RecordingsModel *recordingsModel)
{
    if (mRecordingsModel == recordingsModel)
    {
        return;
    }

    mRecordingsModel = recordingsModel;
}

QString Recorder::location() const
{
    return settings.value(FILE_LOCATION, Recorder::defaultStoragePath).toString();
}

void Recorder::setLocation(const QString &location)
{
    if (this->location() != location)
    {
        settings.setValue(FILE_LOCATION, location);
        emit this->locationChanged();
    }
}

int Recorder::sampleRate() const
{
    return settings.value(SAMPLE_RATE, 0).toInt();
}

void Recorder::setSampleRate(const int &sampleRate)
{
    if (this->sampleRate() != sampleRate)
    {
        settings.setValue(SAMPLE_RATE, sampleRate);
        emit this->sampleRateChanged();
    }
}

QMultimedia::EncodingQuality Recorder::encodingQuality() const
{
    auto quality = settings.value(ENCOD_QUALITY, QMultimedia::HighQuality).toInt();
    return static_cast<QMultimedia::EncodingQuality>(quality);
}

void Recorder::setEncodingQuality(QMultimedia::EncodingQuality quality)
{
    if (   quality < QMultimedia::VeryLowQuality
        || quality > QMultimedia::VeryHighQuality
        || this->encodingQuality() == quality)
    {
        return;
    }
    settings.setValue(ENCOD_QUALITY, quality);
    emit this->encodingQualityChanged();
}

QMultimedia::EncodingMode Recorder::encodingMode() const
{
    auto mode = settings.value(ENCOD_MODE, QMultimedia::TwoPassEncoding).toInt();
    return static_cast<QMultimedia::EncodingMode>(mode);
}

void Recorder::setEncodingMode(QMultimedia::EncodingMode &mode)
{
    if (   mode < QMultimedia::ConstantQualityEncoding
        || mode > QMultimedia::TwoPassEncoding
        || this->encodingMode() == mode)
    {
        return;
    }
    settings.setValue(ENCOD_MODE, mode);
    emit this->encodingModeChanged();
}

Recorder::Codec Recorder::codec() const
{
    return static_cast<Recorder::Codec>(settings.value(CODEC, FLAC).toInt());
}

void Recorder::setCodec(const Codec &codec)
{
    if (this->codec() != codec)
    {
        settings.setValue(CODEC, codec);
        emit this->codecChanged();
    }
}

QString Recorder::durationLabel() const
{
    return Recorder::formatTime(this->duration());
}

bool Recorder::recursiveSearch() const
{
    return settings.value(RECURSIVE, false).toBool();
}

void Recorder::setRecursiveSearch(bool recursiveSearch)
{
    if (this->recursiveSearch() != recursiveSearch)
    {
        settings.setValue(RECURSIVE, recursiveSearch);
        emit this->recursiveSearchChanged();
    }
}

QString Recorder::formatTime(const qint64 &msec)
{
    // Use rounded secs instead of msecs for a smoother update of the label
    return QTime(0, 0).addSecs(int(qreal(msec) * 0.001 + 0.5))
            .toString(QStringLiteral("HH:mm:ss"));
}

void Recorder::startRecording()
{
    if(this->state() != QMediaRecorder::StoppedState)
    {
        return;
    }

    QDir location(this->location());
    if(!location.exists()) {
        if (!location.mkpath(".")) {
            emit this->pathCreationFailed();
        }
        else {
            // Reset the model after path creation to show the new file.
            this->recordingsModel()->resetModel();
        }
    }

    QAudioEncoderSettings encoderSettings;

    CodecSetting codec = codecSettingsMap[this->codec()];

    encoderSettings.setCodec(codec.codec);
    encoderSettings.setEncodingMode(this->encodingMode());
    encoderSettings.setQuality(this->encodingQuality());

    int selectedSampleRate = this->sampleRate();
    if (selectedSampleRate != 0)
    {
        encoderSettings.setSampleRate(selectedSampleRate);
    }

    auto fileName = location.absoluteFilePath(tr("recording")
                        .append(QDateTime::currentDateTime().toString("-yyyyMMddHHmmss"))
                        .append(codec.extension));

    this->setEncodingSettings(encoderSettings);
    this->setOutputLocation(QUrl(fileName));
    this->setContainerFormat(codec.container);

    this->record();
}

bool Recorder::shouldMigrate() const
{
    if (settings.value(MIGRATE1, false).toBool())
    {
        return false;
    }

    auto oldStoragePath = QDir::homePath().append("/Recordings");

    if (this->location() != oldStoragePath)
    {
        // The user has set up a custom folder, don't run the migration
        return false;
    }

    // If the old directory exists, migrate the files.
    return QDir(oldStoragePath).exists();
}

bool Recorder::migrate()
{
    auto oldStoragePath = QDir::homePath().append("/Recordings");

    bool result = QDir().rename(oldStoragePath, Recorder::defaultStoragePath);

    if (result)
    {
        settings.setValue(MIGRATE1, true);
        settings.setValue(FILE_LOCATION, Recorder::defaultStoragePath);
        emit this->locationChanged();
    }

    return result;
}

void Recorder::removeFile(const QString &filePath)
{
    QFile(filePath).remove();
}

void Recorder::renameFile(const QString &oldPath, const QString &newPath)
{
    if (oldPath != newPath)
    {
        QFile(oldPath).rename(newPath);
    }
}

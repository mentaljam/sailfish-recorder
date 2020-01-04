#ifndef RECORDINGSMODEL_H
#define RECORDINGSMODEL_H

#include <QAbstractListModel>
#include <QFileInfo>

class Recorder;
class QFileSystemWatcher;

class RecordingsModel : public QAbstractListModel
{
    Q_OBJECT

public:

    enum Roles
    {
        FilePath = Qt::UserRole,
        FileName,
        FileDir,
        Modified,
        Section
    };
    Q_ENUM(Roles)

    explicit RecordingsModel(QObject *parent = 0);

    Recorder *recorder() const;
    void setRecorder(Recorder *recorder);
    void resetModel();

    Q_INVOKABLE bool contains(const QString &filePath) const;

private slots:
    void scanRecords(const QString &path);

private:
    static QString sectionName(const QDate &modDate);

private:
    Recorder *mRecorder;
    QFileSystemWatcher *mWatcher;
    QFileInfoList mData;
    static const QStringList filters;

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;
};

#endif // RECORDINGSMODEL_H

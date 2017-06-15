#ifndef RECORDINGSMODEL_H
#define RECORDINGSMODEL_H

#include <QAbstractListModel>
#include <QFileInfo>

class QFileSystemWatcher;

class RecordingsModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathChanged)

public:

    enum Roles
    {
        FilePath = Qt::UserRole,
        FileName,
        Modified,
        Section
    };
    Q_ENUM(Roles)

    explicit RecordingsModel(QObject *parent = 0);

    QString path() const;
    void setPath(const QString &path);

signals:
    void pathChanged();

private slots:
    void scanRecords(const QString &path);

private:
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

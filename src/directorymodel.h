#ifndef DIRECTORYMODEL_H
#define DIRECTORYMODEL_H

#include <QStringListModel>

class DirectoryModel : public QStringListModel
{
    Q_OBJECT
    Q_PROPERTY(QString location READ location WRITE setLocation NOTIFY locationChanged)

public:
    explicit DirectoryModel(QObject *parent = 0);

    QString location() const;
    void setLocation(QString location);

    Q_INVOKABLE bool newDir(const QString &name);
    Q_INVOKABLE bool removeDir(const QString &name);

    Q_INVOKABLE bool contains(const QString &name) const;

signals:
    void locationChanged();

private:
    QString mLocation;
};

#endif // DIRECTORYMODEL_H

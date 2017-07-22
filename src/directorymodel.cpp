#include "directorymodel.h"
#include <QDir>

DirectoryModel::DirectoryModel(QObject *parent) :
    QStringListModel(parent)
{

}

QString DirectoryModel::location() const
{
    return mLocation;
}

void DirectoryModel::setLocation(QString location)
{
    location = QDir::cleanPath(location);
    Q_ASSERT(QFileInfo(location).isDir());
    if (mLocation != location)
    {
        mLocation = location;
        emit this->locationChanged();
        // .mid(2) is required to remove "." and ".." entries
        auto entries = QDir(location).entryList(QDir::Dirs, QDir::Name).mid(2);
        this->setStringList(entries);
    }
}

bool DirectoryModel::newDir(const QString &name)
{
    Q_ASSERT(QFileInfo(mLocation).isDir());
    if (QDir(mLocation).mkdir(name))
    {
        auto pos = this->rowCount();
        this->insertRow(pos);
        this->setData(this->createIndex(pos, 0), name);
        return true;
    }
    return false;
}

bool DirectoryModel::removeDir(const QString &name)
{
    Q_ASSERT(QFileInfo(mLocation).isDir());
    QDir dir(mLocation);
    auto pos = this->stringList().indexOf(name);
    if (pos != -1 && dir.cd(name) && dir.removeRecursively())
    {
        this->removeRow(pos);
        return true;
    }
    return false;
}

bool DirectoryModel::contains(const QString &name) const
{
    return this->stringList().contains(name);
}

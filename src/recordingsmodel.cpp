#include "recordingsmodel.h"
#include <QFileSystemWatcher>
#include <QDir>
#include <QDateTime>

const QStringList RecordingsModel::filters{
    "*.ogg",
    "*.oga",
    "*.wav",
    "*.flac"
};

RecordingsModel::RecordingsModel(QObject *parent) :
    QAbstractListModel(parent),
    mWatcher(new QFileSystemWatcher(this))
{
    connect(mWatcher, &QFileSystemWatcher::directoryChanged,
            this, &RecordingsModel::scanRecords);
}

QString RecordingsModel::path() const
{
    auto directories = mWatcher->directories();
    return directories.empty() ? "" : directories[0];
}

void RecordingsModel::setPath(const QString &path)
{
    auto oldPath = this->path();
    if (oldPath != path)
    {
        if (!mData.empty())
        {
            mWatcher->removePath(oldPath);
        }
        mWatcher->addPath(path);
        this->scanRecords(path);
        emit this->pathChanged();
    }
}

void RecordingsModel::scanRecords(const QString &path)
{
    // Scan for updated and removed records
    for (int row = mData.size() - 1; row > -1; --row)
    {
        auto oldFileInfo = mData[row];
        QFileInfo newFileInfo(oldFileInfo);
        newFileInfo.refresh();
        if (newFileInfo.exists())
        {
            // Update record
            if (newFileInfo.lastModified() != oldFileInfo.lastModified())
            {
                auto index = this->createIndex(row, 0);
                emit this->dataChanged(index, index, { Modified });
            }
        }
        else
        {
            // Add a new record
            this->beginRemoveRows(QModelIndex(), row, row);
            mData.removeAt(row);
            this->endRemoveRows();
        }
    }

    // Scan for new records
    auto fileInfoList = QDir(path).entryInfoList(RecordingsModel::filters, QDir::Files);
    for (auto fileInfo: fileInfoList)
    {
        // Add a new record
        if (mData.indexOf(fileInfo) == -1)
        {
            auto pos = mData.size();
            this->beginInsertRows(QModelIndex(), pos, pos);
            mData.append(fileInfo);
            this->endInsertRows();
        }
    }
}

int RecordingsModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : mData.size();
}

QVariant RecordingsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
    {
        return QVariant();
    }

    auto fileInfo = mData[index.row()];

    if (role == Section)
    {
        auto curDate = QDate::currentDate();
        auto modDate = fileInfo.lastModified().date();
        auto days = modDate.daysTo(curDate);
        if (days == 0)
        {
            return tr("Today");
        }
        if (days == 1)
        {
            return tr("Yesterday");
        }
        if (days < 7 && modDate.dayOfWeek() < curDate.dayOfWeek())
        {
            return tr("This week");
        }
        if (days < curDate.daysInMonth() && modDate.day() < curDate.day())
        {
            return tr("Last month");
        }
        if (days < 183)
        {
            return tr("Last 6 months");
        }
        return tr("Older");
    }

    switch (role)
    {
    case FilePath:
        return fileInfo.absoluteFilePath();
    case FileName:
        return fileInfo.fileName();
    case Modified:
        return fileInfo.lastModified();
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> RecordingsModel::roleNames() const
{
    return {
        { FilePath, "filePath" },
        { FileName, "fileName" },
        { Modified, "modified" },
        { Section,  "section"  }
    };
}

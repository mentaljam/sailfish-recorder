#include "recordingsmodel.h"
#include "recorder.h"
#include <QFileSystemWatcher>
#include <QDirIterator>
#include <QDateTime>

const QStringList RecordingsModel::filters{
    "*.ogg",
    "*.oga",
    "*.wav",
    "*.flac"
};

RecordingsModel::RecordingsModel(QObject *parent) :
    QAbstractListModel(parent),
    mRecorder(0),
    mWatcher(new QFileSystemWatcher(this))
{
    connect(mWatcher, &QFileSystemWatcher::directoryChanged, this, &RecordingsModel::scanRecords);
}

Recorder *RecordingsModel::recorder() const
{
    return mRecorder;
}

void RecordingsModel::setRecorder(Recorder *recorder)
{
    if (mRecorder == recorder)
    {
        return;
    }

    if (mRecorder)
    {
        disconnect(mRecorder, &Recorder::locationChanged, this, &RecordingsModel::onLocationChanged);
        disconnect(mRecorder, &Recorder::recursiveSearchChanged, this, &RecordingsModel::resetModel);
    }

    mRecorder = recorder;
    connect(mRecorder, &Recorder::locationChanged, this, &RecordingsModel::onLocationChanged);
    connect(mRecorder, &Recorder::recursiveSearchChanged, this, &RecordingsModel::resetModel);

    this->scanRecords();
}

void RecordingsModel::scanRecords()
{
    Q_ASSERT(mRecorder);

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
            // Remove record
            this->beginRemoveRows(QModelIndex(), row, row);
            mData.removeAt(row);
            this->endRemoveRows();
        }
    }

    // Scan for new records
    auto flags = mRecorder->recursiveSearch() ? QDirIterator::Subdirectories : QDirIterator::NoIteratorFlags;
    QDirIterator it(mRecorder->location(), RecordingsModel::filters, QDir::Files, flags);
    while (it.hasNext())
    {
        // Add a new record
        QFileInfo fileInfo(it.next());
        if (mData.indexOf(fileInfo) == -1)
        {
            auto pos = mData.size();
            this->beginInsertRows(QModelIndex(), pos, pos);
            mData.append(fileInfo);
            this->endInsertRows();
        }
    }
}

void RecordingsModel::onLocationChanged()
{
    bool needSetPath = true;
    auto dirs = mWatcher->directories();
    auto newPath = mRecorder->location();
    if (!dirs.empty())
    {
        auto currentPath = dirs[0];
        needSetPath = currentPath != newPath;
        if (needSetPath)
        {
            mWatcher->removePath(currentPath);
        }
    }
    if (needSetPath)
    {
        mWatcher->addPath(newPath);
        this->resetModel();
    }
}

void RecordingsModel::resetModel()
{
    this->beginResetModel();
    mData.clear();
    this->scanRecords();
    this->endResetModel();
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

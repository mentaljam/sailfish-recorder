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

#include "recorder.h"
#include "recordingsmodel.h"
#include "directorymodel.h"
#include <QtQuick>
#include <sailfishapp.h>
#include <QSortFilterProxyModel>


int main(int argc, char *argv[])
{
    qmlRegisterType<Recorder>("harbour.recorder", 1, 0, "Recorder");
    qmlRegisterType<DirectoryModel>("harbour.recorder", 1, 0, "DirectoryModel");

    auto app = SailfishApp::application(argc, argv);

    QCoreApplication::setOrganizationName("harbour-recorder");
    QCoreApplication::setApplicationName("Recorder");

    auto view = SailfishApp::createView();
    auto context = view->rootContext();

    Recorder recorder;
    context->setContextProperty("recorder", &recorder);

    RecordingsModel sourceModel;
    sourceModel.setRecorder(&recorder);

    QSortFilterProxyModel recordingsModel;
    recordingsModel.setSourceModel(&sourceModel);
    recordingsModel.setSortRole(RecordingsModel::Modified);
    recordingsModel.setDynamicSortFilter(true);
    recordingsModel.sort(0, Qt::DescendingOrder);
    context->setContextProperty("recordingsModel", &recordingsModel);

    view->setSource(SailfishApp::pathTo("qml/harbour-recorder.qml"));
    view->show();
    return app->exec();
}

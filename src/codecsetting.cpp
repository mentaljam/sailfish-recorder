#include <QtQuick>
#include "codecsetting.h"

CodecSetting::CodecSetting()
{

}

CodecSetting::CodecSetting(QString codec, QString extension, QString container)
{
    this->codec = codec;
    this->container = container;
    this->extension = extension;
}

QString CodecSetting::getCodec()
{
    return this->codec;
}

QString CodecSetting::getExtension()
{
    return this->extension;
}

QString CodecSetting::getContainer()
{
    return this->container;
}

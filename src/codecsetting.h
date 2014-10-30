#ifndef CODECSETTING_H
#define CODECSETTING_H

class CodecSetting
{
private:
    QString codec;
    QString extension;
    QString container;
public:
    CodecSetting(QString codec, QString extension, QString container);
    CodecSetting();
    QString getCodec();
    QString getExtension();
    QString getContainer();
};

#endif // CODECSETTING_H

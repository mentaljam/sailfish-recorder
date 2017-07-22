# Translations

You can help to localize harbour-recorder to your language using [Transifex](https://www.transifex.com/mentaljam/harbour-recorder) or [Qt Linguist](http://doc.qt.io/qt-5/qtlinguist-index.html).

If you want to test your translation before publishing you should compile it and place produced qm file to (root access is required)

    /usr/share/harbour-recorder/translations

The application tries to load translation files automatically basing on your system locale settings. Also you can run application with selected locale from terminal. For example for Russian language the command is

    LANG=ru harbour-recorder

TARGET = ru.auroraos.MoiFinansi

CONFIG += auroraapp
QT += core gui qml quick sql widgets

PKGCONFIG += \

SOURCES += \
    src/databasemanager.cpp \
    src/main.cpp \
    src/seconddatabasemanager.cpp

HEADERS += \
    src/databasemanager.h \
    src/seconddatabasemanager.h

DISTFILES += \
    qml/pages/Analitika.qml \
    rpm/ru.auroraos.MoiFinansi.spec \
    qml/pages/Achieve.qml \
    qml/pages/Advice.qml \
    qml/pages/Savings.qml


AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += auroraapp_i18n console
DEFINES += QT_MESSAGELOGCONTEXT
TRANSLATIONS += \
    translations/ru.auroraos.MoiFinansi.ts \
    translations/ru.auroraos.MoiFinansi-ru.ts \

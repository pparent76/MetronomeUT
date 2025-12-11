cmake_minimum_required(VERSION 3.5)

project(metronome LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Standard C++11
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(QML_FILES
    qml/Main.qml
)


find_package(Qt5 REQUIRED COMPONENTS Core Gui Widgets Multimedia  Qml Quick QuickControls2)

qt5_add_resources(QML_RES qml/qml.qrc)


# Fichiers sources
set(SOURCES
    src/main.cpp
    src/Timer.cpp
)

set(HEADERS
    src/Timer.h
)

set(RESOURCES
    resource.qrc
)

# Génération des fichiers UI, MOC et ressources (Qt5)
qt5_add_resources(QRC_SOURCES ${RESOURCES})

# Exécutable
add_executable( metronome
    ${SOURCES}
    ${HEADERS}
    ${QRC_SOURCES}
    ${QML_RES}
)


# Inclusions automatiques de Qt
target_link_libraries(metronome
    PRIVATE
        Qt5::Core
        Qt5::Gui
        Qt5::Widgets
        Qt5::Multimedia
        Qt5::Qml
        Qt5::Quick 
        Qt5::QuickControls2       
)
 
install(FILES icon.png DESTINATION ${CMAKE_INSTALL_PREFIX})
install(FILES icon-splash.png DESTINATION ${CMAKE_INSTALL_PREFIX})
install(FILES manifest.json DESTINATION ${CMAKE_INSTALL_PREFIX})
install(FILES metronome.desktop DESTINATION ${CMAKE_INSTALL_PREFIX})
install(FILES metronome.apparmor DESTINATION ${CMAKE_INSTALL_PREFIX})
install(TARGETS metronome
    RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}
)

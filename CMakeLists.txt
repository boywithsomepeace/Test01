cmake_minimum_required(VERSION 3.21)

project(EV_HMI VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2 SerialPort)

qt_add_executable(EV_HMI
    main.cpp
    resources.qrc
    backend/VehicleData.h
    backend/VehicleData.cpp
    backend/SerialManager.h
    backend/SerialManager.cpp
    backend/TelemetryParser.h
    backend/TelemetryParser.cpp
    backend/TelemetrySimulator.h
    backend/TelemetrySimulator.cpp
    backend/WarningManager.h
    backend/WarningManager.cpp
)

target_link_libraries(EV_HMI
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
        Qt6::SerialPort
)

if(UNIX AND NOT APPLE)
    target_compile_definitions(EV_HMI PRIVATE QT_QPA_PLATFORM_EGLFS)
endif()

install(TARGETS EV_HMI
    BUNDLE DESTINATION .
    RUNTIME DESTINATION bin
)

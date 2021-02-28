cmake_minimum_required(VERSION 3.5)
SET(CMAKE_CXX_STANDARD 17)

SET(VIEWS_FOLDER "views")
SET(TEST_FOLDER "tests")
set(MODELS_PREFIX "models")

set(CMAKE_PREFIX_PATH "D:/Qt/6.0.1/msvc2019_64/lib/cmake")
list(APPEND CMAKE_PREFIX_PATH "D:/Qt/6.0.1/msvc2019_64/bin")


# Define Project name. Note: You have only ONE Project, this is equivalent to the solution name in visual studio.
get_filename_component(ProjectId ${CMAKE_CURRENT_SOURCE_DIR} NAME)
string(REPLACE " " "_" ProjectId ${ProjectId})
project(${ProjectId})

# Include a utils.cmake which "hides" ugly code so that the individual cmake files can stay clean and beautiful.
include(Utils.cmake)


# this sets the build and library paths. Usually you dont want to build libraries and executables in different locations, 
# as the dlls usually reside in the same directory as .exe files. This results in a <build_dir>/bin/<config> directory which
# contains all libraries and executables.
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# This is Qt specific
find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui Widgets Concurrent REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui Widgets Concurrent REQUIRED)


# From utils.cmake
SETUP_QT()
SETUP_CATCH()


# Add subdirectories that should by parsed by cmake. A subdir not containing a CMakeLists.txt will *not* be processed!
message("Looking for subdirectories in ${CMAKE_CURRENT_SOURCE_DIR}/${MODELS_PREFIX}")
SUBDIRLIST(SUBDIRS "${CMAKE_CURRENT_SOURCE_DIR}/${MODELS_PREFIX}")
FOREACH(subdir ${SUBDIRS})
  message("Adding ${subdir}")
  ADD_SUBDIRECTORY(${MODELS_PREFIX}/${subdir})
ENDFOREACH()

add_subdirectory(globals/catch2)
add_subdirectory(${VIEWS_FOLDER})
add_subdirectory(${TEST_FOLDER})




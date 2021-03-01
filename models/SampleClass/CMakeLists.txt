# Set name for library
get_filename_component(LIBRARY_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
string(REPLACE " " "_" LIBRARY_NAME ${LIBRARY_NAME})


SET( _sources 
		sampleclass.h
		sampleclass.cpp
)

#if they are using qt dependencies
SET (_deps Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Widgets)

# utils.cmake
DEPLOY_SHARED_LIBRARY( ${LIBRARY_NAME} "${_sources}" "${_deps}" )

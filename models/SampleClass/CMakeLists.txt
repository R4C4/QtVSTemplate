# Set name for library
SET( LIBRARY_NAME "SampleClass" )


SET( _sources 
		sampleclass.h
		sampleclass.cpp
)

#if they are using qt dependencies
SET (_deps Qt${QT_VERSION_MAJOR}::Core )

# utils.cmake
DEPLOY_SHARED_LIBRARY( ${LIBRARY_NAME} "${_sources}" "${_deps}" )

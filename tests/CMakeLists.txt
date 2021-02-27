SET(APPLICATION_NAME "SampleTests" )

SET(CMAKE_CXX_STANDARD 11)

SET( _sources 
				tst_sampletests.cpp
			  main.cpp )

# Add here additional libraries used in testing
SET( _deps Qt${QT_VERSION_MAJOR}::Core
		   Qt${QT_VERSION_MAJOR}::Gui
		   catch )

DEPLOY_QT_APPLICATION(${APPLICATION_NAME} "${_sources}" "${_deps}")

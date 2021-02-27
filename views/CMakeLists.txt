
# Set the application name.
SET( APPLICATION_NAME "SampleViews" )

# Set a variable containing all source and header files for this application/library
SET( _sources main.cpp
			  mainwindow.cpp
			  mainwindow.h
			  mainwindow.ui 
)

# Set all dependencies. This includes libraries that are built by this solution as well as
# third party dependencies such as Qt		  
SET( _deps Qt${QT_VERSION_MAJOR}::Core
		   Qt${QT_VERSION_MAJOR}::Gui
		   Qt${QT_VERSION_MAJOR}::Widgets
		   SampleClass
)


# utils.cmake
DEPLOY_QT_APPLICATION(${APPLICATION_NAME} "${_sources}" "${_deps}")


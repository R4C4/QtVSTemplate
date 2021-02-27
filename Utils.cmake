# This is a built in cmake functionality for generating export headers used when linking shared libraries
include(GenerateExportHeader)

# This macro sets up Qts windeployment tool. This is used to copy all dependent qt libraries and plugins to the build tree.
macro( SETUP_QT )
	#add Qt windeployment for automatically linking/copying necessary plattform plugins
	if(Qt${QT_VERSION_MAJOR}_FOUND AND WIN32 AND TARGET Qt${QT_VERSION_MAJOR}::qmake AND NOT TARGET Qt${QT_VERSION_MAJOR}::windeployqt)
		get_target_property(_qt_qmake_location Qt${QT_VERSION_MAJOR}::qmake IMPORTED_LOCATION)

		execute_process(
			COMMAND "${_qt_qmake_location}" -query QT_INSTALL_PREFIX
			RESULT_VARIABLE return_code
			OUTPUT_VARIABLE qt_install_prefix
			OUTPUT_STRIP_TRAILING_WHITESPACE
		)

		set(imported_location "${qt_install_prefix}/bin/windeployqt.exe")

		if(EXISTS ${imported_location})
			add_executable(Qt${QT_VERSION_MAJOR}::windeployqt IMPORTED)

			set_target_properties(Qt${QT_VERSION_MAJOR}::windeployqt PROPERTIES
				IMPORTED_LOCATION ${imported_location}
			)
		endif()
	endif()
endmacro()

# As Catch seems to be a header only library, adding the paths to the include dir seems to be enough.
macro( SETUP_CATCH )
	# Add catch library
	if (DEFINED ENV{CATCH_INCLUDE_DIR})
		set(CATCH_INCLUDE_DIR $ENV{CATCH_INCLUDE_DIR})
	else ()
		set(CATCH_INCLUDE_DIR "D:/Projects/Formular/globals/include") # set by Qt Creator wizard
	endif ()
	if (CATCH_INCLUDE_DIR STREQUAL "")
		message("CATCH_INCLUDE_DIR is not set, assuming Catch2 can be found automatically in your system")
	elseif (EXISTS ${CATCH_INCLUDE_DIR})
		include_directories(${CATCH_INCLUDE_DIR})
	endif ()
endmacro()

# Wrapper for adding an application that links against Qt.
# After adding the executable and linking libraries, the deployment tool is executed.
macro(DEPLOY_QT_APPLICATION app_name sources dependencies )

	execute_process(COMMAND ${CMAKE_COMMAND} -E echo_append "Adding Qt Application ${app_name}...")
	set(CMAKE_AUTOUIC ON)
	set(CMAKE_AUTOMOC ON)
	set(CMAKE_AUTORCC ON)

	add_executable(${app_name} ${sources} )
	target_link_libraries(${app_name} ${dependencies})

	if(TARGET Qt${QT_VERSION_MAJOR}::windeployqt)
		add_custom_command(TARGET ${app_name}
			POST_BUILD
			COMMAND Qt${QT_VERSION_MAJOR}::windeployqt --dir "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/$<CONFIG>" "$<TARGET_FILE_DIR:${app_name}>/$<TARGET_FILE_NAME:${app_name}>"
		)
		# copy deployment directory during installation
		install(
			DIRECTORY
			"${CMAKE_CURRENT_BINARY_DIR}"
			DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
		)
	endif()
	
	execute_process(COMMAND ${CMAKE_COMMAND} -E echo_append "Done")

endmacro()

# Wrapper for adding a shared library
# After adding the library, export headers are generated and include paths are set.
macro(DEPLOY_SHARED_LIBRARY lib_name sources dependencies )

	set(CMAKE_AUTOUIC ON)
	set(CMAKE_AUTOMOC ON)
	set(CMAKE_AUTORCC ON)
	
	execute_process(COMMAND ${CMAKE_COMMAND} -E echo_append "Adding Library ${lib_name}...")
	
	add_library(${lib_name} SHARED ${sources} )
	target_link_libraries(${lib_name} ${dependencies})

	# set include paths s.t. it works as follows: <LibraryName/IncludeName.h>
	TARGET_INCLUDE_DIRECTORIES(${lib_name} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/..)
	# set include paths for generated header (only exists in the build tree) s.t. it works as follows: <LibraryName/LibraryNameExport.h>
	TARGET_INCLUDE_DIRECTORIES(${lib_name} PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/)

	GENERATE_EXPORT_HEADER(${lib_name}           
		BASE_NAME ${lib_name}  
		EXPORT_MACRO_NAME ${lib_name}_DLL
		EXPORT_FILE_NAME ${lib_name}Export.h
		STATIC_DEFINE SHARED_EXPORTS_BUILT_AS_STATIC)
		
	execute_process(COMMAND ${CMAKE_COMMAND} -E echo_append "Done")
endmacro()


MACRO(SUBDIRLIST result curdir)
  FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
  SET(dirlist "")
  FOREACH(child ${children})
    IF(IS_DIRECTORY ${curdir}/${child})
      LIST(APPEND dirlist ${child})
    ENDIF()
  ENDFOREACH()
  SET(${result} ${dirlist})
ENDMACRO()
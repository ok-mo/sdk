*** Settings ***
Library  OperatingSystem

Resource  ${CURDIR}/doc/guide.robot
Resource  ${CURDIR}/doc/reference.robot
Resource  ${CURDIR}/doc/board.robot

*** Variables ***
${ROOT_DIR}  ${CURDIR}/../../

*** Test Cases ***

Documentation generation has been setup
	Documentation infrastructure is in place

Documentation is in good order
	Doxygen main page has been written
	PDF header has been created
	Guides have well structured chapters
	Drivers have been documented
	Libraries have been documented
	Boards have been documented

*** Keywords ***

Documentation infrastructure is in place
	Directory Should Exist  ${ROOT_DIR}/doc/_doxygen/
	Directory Should Exist  ${ROOT_DIR}/doc/_extensions/
	Directory Should Exist  ${ROOT_DIR}/doc/_scripts/
	Directory Should Exist  ${ROOT_DIR}/doc/_static/
	Directory Should Exist  ${ROOT_DIR}/doc/_templates/
	File Should Exist  ${ROOT_DIR}/doc/Makefile
	File Should Exist  ${ROOT_DIR}/doc/CMakeLists.txt
	File Should Exist  ${ROOT_DIR}/doc/conf.py
	File Should Exist  ${ROOT_DIR}/doc/zephyr.doxyfile.in
	File Should Exist  ${ROOT_DIR}/doc/index.rst
	File Should Exist  ${ROOT_DIR}/doc/index-tex.rst

Doxygen main page has been written
	File Should Exist  ${ROOT_DIR}/doc/_doxygen/mainpage.md

PDF header has been created
	File Should Exist  ${ROOT_DIR}/doc/_static/latex/title.tex

Guides have well structured chapters
	@{GUIDES} =	List Directories In Directory	${ROOT_DIR}/doc/guides/
	FOR  ${GUIDE}  IN  @{GUIDES}
		File Should Exist  ${ROOT_DIR}/doc/guides/${GUIDE}.rst
		Set Test Variable  ${CHAPTER_FILES}  ${ROOT_DIR}/doc/guides/${GUIDE}/
		Chapter follows guide structure
	END

Drivers have been documented
	@{DRIVER_CLASSES} =	List Directories In Directory	${ROOT_DIR}/drivers/
	FOR  ${DRIVER_CLASS}  IN  @{DRIVER_CLASSES}
		Directory Should Exist  ${ROOT_DIR}/doc/drivers/${DRIVER_CLASS}/
		@{DRIVERS} =	List Files In Directory  ${ROOT_DIR}/drivers/${DRIVER_CLASS}/  *.c
		FOR  ${DRIVER}  IN  @{DRIVERS}
			${PATH}  ${FILE}  Split Path  ${DRIVER}
			${SECTION}  ${EXT}  Split Extension  ${FILE}
			Set Test Variable  ${CHAPTER_FILES}  ${ROOT_DIR}/doc/drivers/${DRIVER_CLASS}/${SECTION}/
			File Should Exist  ${ROOT_DIR}/doc/drivers/${DRIVER_CLASS}/${SECTION}.rst
			Chapter follows reference structure
		END
		# find invalid directories
		@{INVALIDS} =	List Directories In Directory	${ROOT_DIR}/drivers/${DRIVER_CLASS}/
		FOR  ${INVALID}  IN  @{INVALIDS}
			Log To Console  Do not put directories under driver class folder (drivers/${DRIVER_CLASS}/${INVALID})
			Fail
		END
	END

Subsystems have been documented
	@{SUBSYSTS} =	List Directories In Directory	${ROOT_DIR}/subsys/
	FOR  ${SUBSYS}  IN  @{SUBSYSTS}
		File Should Exist  ${ROOT_DIR}/doc/subsys/${SUBSYS}.rst
		Set Test Variable  ${CHAPTER_FILES}  ${ROOT_DIR}/doc/subsys/${SUBSYS}/
		Chapter follows reference structure
	END

Libraries have been documented
	@{LIBRARIES} =	List Directories In Directory	${ROOT_DIR}/lib/
	FOR  ${LIB}  IN  @{LIBRARIES}
		File Should Exist  ${ROOT_DIR}/doc/lib/${LIB}.rst
		Set Test Variable  ${CHAPTER_FILES}  ${ROOT_DIR}/doc/lib/${LIB}/
		Chapter follows reference structure
	END

Boards have been documented
	@{ARCHS} =	List Directories In Directory	${ROOT_DIR}/boards/
	FOR  ${ARCH}  IN  @{ARCHS}
		@{BOARDS} =	List Directories In Directory	${ROOT_DIR}/boards/${ARCH}/
		FOR  ${BOARD}  IN  @{BOARDS}
			File Should Exist  ${ROOT_DIR}/doc/boards/${ARCH}/${BOARD}.rst
			Set Test Variable  ${CHAPTER_FILES}  ${ROOT_DIR}/doc/boards/${ARCH}/${BOARD}/
			Chapter follows board reference structure
		END
	END


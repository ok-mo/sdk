*** Settings ***
Library  OperatingSystem
Library  ${CURDIR}/repository.py
Resource  ${CURDIR}/readme.robot
Variables  ${CURDIR}/../variables.py

*** Test Cases ***

Git repository has been setup
	Zephyr repository has a west yaml file
	Zephyr repository has a top level CMake file
	Zephyr repository has a top level Kconfig file
	Zephyr repository has a readme file
	Zephyr repository has a license file
	Zephyr repository has a gitignore file
	Zephyr repository has a CODEOWNERS file
	Zephyr repository has a precommit hook
	Zephyr repository has a VERSION file
	Zephyr repository has an init script that sets up the workspace

Git merge request title is valid
	Check merge request title

Codeowners file is sorted
	${result}=  Run Process  ${CURDIR}/../../scripts/ci/check-file-sorted  ${CURDIR}/../../CODEOWNERS
	IF  ${result.rc} != 0
		Log To Console  CODEOWNERS file is not sorted
		Log To Console  ${result.stdout}
		Fail
	END

*** Keywords ***

Zephyr repository has a readme file
	Set Test Variable  ${README}  ${PROJECT_ROOT}/README.rst
	File Should Exist  ${README}
	Readme should follow sales letter structure

Zephyr repository has a top level CMake file
	File Should Exist  ${PROJECT_ROOT}/CMakeLists.txt

Zephyr repository has a top level Kconfig file
	File Should Exist  ${PROJECT_ROOT}/Kconfig

Zephyr repository has a license file
	File Should Exist  ${PROJECT_ROOT}/LICENSE

Zephyr repository has a gitignore file
	File Should Exist  ${PROJECT_ROOT}/.gitignore

Zephyr repository has a west yaml file
	File Should Exist  ${PROJECT_ROOT}/west.yml

Zephyr repository has a CODEOWNERS file
	File Should Exist  ${PROJECT_ROOT}/CODEOWNERS

Zephyr repository has a precommit hook
	File Should Exist  ${PROJECT_ROOT}/.githooks/pre-commit

Zephyr repository has a VERSION file
	File Should Exist  ${PROJECT_ROOT}/VERSION

Zephyr repository has an init script that sets up the workspace
	File Should Exist  ${PROJECT_ROOT}/scripts/init

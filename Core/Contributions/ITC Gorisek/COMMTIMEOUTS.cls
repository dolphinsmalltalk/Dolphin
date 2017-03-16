"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #COMMTIMEOUTS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
COMMTIMEOUTS guid: (GUID fromString: '{e08f77e3-f05e-4df3-ab60-64f74d12ce29}')!
COMMTIMEOUTS comment: ''!
!COMMTIMEOUTS categoriesForClass!IDB Goodies! !
!COMMTIMEOUTS class methodsFor!

defineFields
	"Private - Define the fields for a Win32 COMMTIMEOUTS structure

		COMMTIMEOUTS compileDefinition
		COMMTIMEOUTS beUncompiled"

	self
		defineField: #readIntervalTimeout type: DWORDField new;
		defineField: #readTotalTimeoutMultiplier type: DWORDField new;
		defineField: #readTotalTimeoutConstant type: DWORDField new;
		defineField: #writeTotalTimeoutMultiplier type: DWORDField new;
		defineField: #writeTotalTimeoutConstant type: DWORDField new! !
!COMMTIMEOUTS class categoriesFor: #defineFields!initializing!public! !


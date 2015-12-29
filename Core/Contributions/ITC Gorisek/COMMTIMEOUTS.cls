"Filed out from Dolphin Smalltalk X6.2"!

Win32Structure subclass: #COMMTIMEOUTS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
COMMTIMEOUTS guid: (GUID fromString: '{E08F77E3-F05E-4DF3-AB60-64F74D12CE29}')!
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


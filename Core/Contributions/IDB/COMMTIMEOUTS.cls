"Filed out from Dolphin Smalltalk X6"!

Win32Structure subclass: #COMMTIMEOUTS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
COMMTIMEOUTS guid: (GUID fromString: '{012BA301-5420-11D3-998B-BCA753D3B065}')!
COMMTIMEOUTS comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
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


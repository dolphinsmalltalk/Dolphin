"Filed out from Dolphin Smalltalk X6"!

Win32Structure subclass: #DEVNAMES
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DEVNAMES guid: (GUID fromString: '{776A9E91-190A-4EA6-969C-92BC7B280AD9}')!
DEVNAMES comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!DEVNAMES categoriesForClass!External-Data-Structured-Win32!IDB Goodies! !
!DEVNAMES class methodsFor!

defineFields
	"Define the fields of the Win32 DEVNAMES structure.
	DEVNAMES compileDefinition
	DEVNAMES decompileDefinition
		
	typedef struct _deviNAMES
		WORD wDriverOffset;
		WORD wDeviceOffset;
		WORD wOutputOffset;
		WORD wDefault;
		// strings follow here
		} DEVNAMES"

	self
		defineField: #wDriverOffset type: WORDField new;
		defineField: #wDeviceOffset type: WORDField new;
		defineField: #wOutputOffset type: WORDField new;
		defineField: #wDefault type: WORDField new! !
!DEVNAMES class categoriesFor: #defineFields!initializing!public! !


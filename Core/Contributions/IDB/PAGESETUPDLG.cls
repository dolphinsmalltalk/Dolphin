"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #PAGESETUPDLG
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PAGESETUPDLG guid: (GUID fromString: '{C96162D4-5DD4-43D1-A305-E90D67357D91}')!
PAGESETUPDLG comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!PAGESETUPDLG categoriesForClass!IDB Goodies! !
!PAGESETUPDLG methodsFor!

defaultFlag
	#JamesFoster.
	^self devNamesDo: [:devNames | devNames wDefault]!

deviceNameFromDevMode
	#JamesFoster.
	^self devModeDo: [:devMode | devMode deviceName]!

deviceNameFromDevNames
	#JamesFoster.
	^self devNamesDo: [:devMode | devMode deviceName]!

devModeDo: aBlock
	| hDevMode pDevMode |
	#JamesFoster.
	hDevMode := self hDevMode.
	(pDevMode := KernelLibrary default globalLock: hDevMode) ifNil: [^nil].
	^[aBlock value: (DEVMODE fromAddress: pDevMode)]
		ensure: [KernelLibrary default globalUnlock: hDevMode]!

devNamesDo: aBlock
	| hDevNames pDevNames |
	#JamesFoster.
	hDevNames := self hDevNames.
	(pDevNames := KernelLibrary default globalLock: hDevNames) ifNil: [^self].
	^[aBlock value: (DEVNAMES fromAddress: pDevNames)]
		ensure: [KernelLibrary default globalUnlock: hDevNames]!

driverName
	#JamesFoster.
	^self devNamesDo: [:devMode | devMode driverName]!

dwSize: anObject
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

orientation
	#JamesFoster.
	^self devModeDo: [:devMode | devMode dmOrientation]!

outputName
	#JamesFoster.
	^self devNamesDo: [:devNames | devNames outputName]!

ownerView: aView
	"Set the parent window for the dialog to aView."

	| hWnd |
	hWnd := aView asParameter.
	hWnd isNull ifFalse: [self hwndOwner: hWnd]!

paperSize
	#JamesFoster.
	^self devModeDo: [:devMode | devMode dmPaperSize]! !
!PAGESETUPDLG categoriesFor: #defaultFlag!accessing!public! !
!PAGESETUPDLG categoriesFor: #deviceNameFromDevMode!accessing!public! !
!PAGESETUPDLG categoriesFor: #deviceNameFromDevNames!accessing!public! !
!PAGESETUPDLG categoriesFor: #devModeDo:!helpers!public! !
!PAGESETUPDLG categoriesFor: #devNamesDo:!helpers!public! !
!PAGESETUPDLG categoriesFor: #driverName!accessing!public! !
!PAGESETUPDLG categoriesFor: #dwSize:!**compiled accessors**!public! !
!PAGESETUPDLG categoriesFor: #orientation!accessing!public! !
!PAGESETUPDLG categoriesFor: #outputName!accessing!public! !
!PAGESETUPDLG categoriesFor: #ownerView:!accessing!public! !
!PAGESETUPDLG categoriesFor: #paperSize!accessing!public! !

!PAGESETUPDLG class methodsFor!

defineFields
	"Define the fields of the Win32 PAGESETUPDLG structure.

		PAGESETUPDLG compileDefinition
		PAGESETUPDLG decompileDefinition

	typedef struct tagPSD { 
		DWORD lStructSize; 
		HWND hwndOwner; 
		HGLOBAL hDevMode; 
		HGLOBAL hDevNames; 
		DWORD Flags; 
		POINT ptPaperSize; 
		RECT rtMinMargin; 
		RECT rtMargin; 
		HINSTANCE hInstance; 
		LPARAM lCustData; 
		LPPAGESETUPHOOK lpfnPageSetupHook; 
		LPPAGEPAINTHOOK lpfnPagePaintHook; 
		LPCTSTR lpPageSetupTemplateName; 
		HGLOBAL hPageSetupTemplate; } PAGESETUPDLG, *LPPAGESETUPDLG; "

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #hwndOwner type: DWORDField writeOnly;
		defineField: #hDevMode type: HANDLEField new;
		defineField: #hDevNames type: HANDLEField new;
		defineField: #flags type: DWORDField new;
		defineField: #ptPaperSize type: (StructureField type: POINTL);
		defineField: #rtMinMargin type: (StructureField type: RECT);
		defineField: #rtMargin type: (StructureField type: RECT);
		defineField: #hInstance type: DWORDField filler;
		defineField: #lCustData type: DWORDField filler;
		defineField: #lpfnPageSetupHook type: (PointerField type: ExternalAddress) beFiller;
		defineField: #lpfnPagePaintHook type: (PointerField type: ExternalAddress) beFiller;
		defineField: #lpPageSetupTemplateName type: (PointerField type: String) beFiller;
		defineField: #hPageSetupTemplate type: HANDLEField filler!

packing
	"Answer the default packing for instances of the receiver.
	This is the maximum alignment to which members of the structure
	after the first are padded. Each field type has a natural alignment
	(e.g. ints align to 32-bit boundaries), and it is the smaller of the
	packing and the natural alignment which is used to decide the
	padding necessary for the field in the structure.
	PRINTDLG is an old Win16 structure with byte packing."

	^1! !
!PAGESETUPDLG class categoriesFor: #defineFields!initializing!public! !
!PAGESETUPDLG class categoriesFor: #packing!constants!public! !


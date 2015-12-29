"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #PAGESETUPDLG
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PAGESETUPDLG guid: (GUID fromString: '{C96162D4-5DD4-43D1-A305-E90D67357D91}')!
PAGESETUPDLG comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!PAGESETUPDLG categoriesForClass!IDB Goodies! !
!PAGESETUPDLG methodsFor!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

ownerView: aView 
	"Set the parent window for the dialog to aView."

	| hWnd |
	hWnd := aView asParameter.
	hWnd isNull ifFalse: [self hwndOwner: hWnd]! !
!PAGESETUPDLG categoriesFor: #dwSize:!**compiled accessors**!public! !
!PAGESETUPDLG categoriesFor: #ownerView:!accessing!public! !

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
		defineField: #lCustData type: INT_PTRField filler;
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


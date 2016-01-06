"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #Printer
	instanceVariableNames: 'hDevNames hDevMode rtMargin margins selectionRange pageRange pageRangeLimits titleBlock printerCanvas'
	classVariableNames: ''
	poolDictionaries: 'PrintingConstants Win32Constants'
	classInstanceVariableNames: ''!
Printer guid: (GUID fromString: '{38D2291D-3137-45FF-9573-B92AE401F1A8}')!
Printer comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!Printer categoriesForClass!IDB Goodies! !
!Printer methodsFor!

defaultTitleBlock
	^nil!

initialize
	super initialize.
	hDevMode := hDevNames := printerCanvas := 0.
	titleBlock := self defaultTitleBlock.
	self showPageSetupDialog: false.
	self showPrintDialog: false selectionRange: (1 to: 0)!

margins
	^margins!

pageRange
	^pageRange!

pageRangeLimits: anObject
	pageRangeLimits := anObject!

pageSize
	^(printerCanvas getDeviceCaps: PHYSICALWIDTH) @ (printerCanvas getDeviceCaps: PHYSICALHEIGHT)!

print: aView
	self print: aView selectionRange: aView selectionRange!

print: aView selectionRange: anInterval
	(self showPrintDialog: true selectionRange: anInterval)
		ifNotNil:
			[self setPrinterCanvas.
			aView printDocumentTo: self]!

printerCanvas
	^printerCanvas!

printPreview: aView
	| printPreviewShell |
	printPreviewShell := PrintPreviewShell show.
	printPreviewShell printer: self documentView: aView!

printPreview: aView for: aPrintPreviewShell
	self setPrinterCanvas.
	aView printPreviewDocumentTo: self for: aPrintPreviewShell!

selectionRange
	^selectionRange!

setPrinterCanvas
	| devModeAddr devNamesAddr devMode devNames hDC |
	devModeAddr := KernelLibrary default globalLock: hDevMode.
	devMode := DEVMODE new initializeAtAddress: devModeAddr.
	devNamesAddr := KernelLibrary default globalLock: hDevNames.
	devNames := DEVNAMES new initializeAtAddress: devNamesAddr.
	hDC := GDILibrary default
		createDC: (String fromAddress: devNamesAddr yourAddress + devNames wDriverOffset)
		lpszDevice: (String fromAddress: devNamesAddr yourAddress + devNames wDeviceOffset)
		lpszOutput: (String fromAddress: devNamesAddr yourAddress + devNames wOutputOffset)
		lpInitData: devMode.
	KernelLibrary default globalUnlock: hDevNames.
	KernelLibrary default globalUnlock: hDevMode.
	self assert: [hDC notNil].
	printerCanvas := PrinterCanvas withOwnedDC: hDC asInteger!

showPageSetupDialog: aBoolean
	"aBoolean is false if we don't want the dialog to be displayed, just set the defaults"

	| pageSetupDlg active apiResult |
	active := View active.
	pageSetupDlg := PAGESETUPDLG new.
	pageSetupDlg
		ownerView: active;
		hDevMode: hDevMode;
		hDevNames: hDevNames.
	rtMargin
		ifNotNil:
			[pageSetupDlg
				rtMargin: rtMargin;
				flags: pageSetupDlg flags | PSD_MARGINS].
	aBoolean
		ifFalse:
			[pageSetupDlg
				flags: pageSetupDlg flags | PSD_RETURNDEFAULT;
				hDevMode: 0;
				hDevNames: 0].
	apiResult := [SessionManager inputState startIdleTimer: active.
	ComDlgLibrary default pageSetupDlg: pageSetupDlg asParameter]
		ensure: [SessionManager inputState stopIdleTimer: active].
	apiResult
		ifTrue:
			[rtMargin := pageSetupDlg rtMargin copy.
			margins := (pageSetupDlg flags anyMask: PSD_INHUNDREDTHSOFMILLIMETERS)
				ifTrue:
					["convert mm margin to inches"
					(rtMargin topLeft / 2.54 corner: rtMargin bottomRight / 2.54) truncated]
				ifFalse: [rtMargin asRectangle].
			hDevMode := pageSetupDlg hDevMode copy.
			hDevNames := pageSetupDlg hDevNames copy]
		ifFalse:
			[| error |
			(error := ComDlgLibrary default commDlgExtendedError) = 0
				ifFalse: [self error: 'PageSetupDialog error: ' , error printString].
			^nil]!

showPrintDialog: showBoolean selectionRange: anInterval
	"aBoolean is false if we don't want the dialog to be displayed, just set the defaults"

	| printDlg active apiResult |
	printDlg := PRINTDLG new.
	active := View active.
	printDlg
		ownerView: active;
		flags: ##(PD_USEDEVMODECOPIES | PD_ALLPAGES);
		nFromPage: 1;
		nToPage: 1;
		nMinPage: 1;
		nMaxPage: (pageRangeLimits ifNil: [16rFFFF] ifNotNil: [pageRangeLimits stop]);
		nCopies: 1;
		hDC: 0;
		hDevMode: hDevMode;
		hDevNames: hDevNames.
	anInterval isEmpty ifTrue: [printDlg flags: printDlg flags | PD_NOSELECTION].
	showBoolean
		ifFalse:
			[printDlg
				flags: printDlg flags | PD_RETURNDEFAULT;
				hDevMode: 0;
				hDevNames: 0].
	apiResult := [SessionManager inputState startIdleTimer: active.
	ComDlgLibrary default printDlg: printDlg asParameter]
		ensure: [SessionManager inputState stopIdleTimer: active].
	apiResult
		ifTrue:
			[selectionRange := (printDlg flags anyMask: PD_SELECTION) ifTrue: [anInterval].
			pageRange := (printDlg flags anyMask: PD_PAGENUMS)
				ifTrue: [printDlg nFromPage to: printDlg nToPage].
			hDevMode := printDlg hDevMode copy.
			hDevNames := printDlg hDevNames copy]
		ifFalse:
			[| error |
			(error := ComDlgLibrary default commDlgExtendedError) = 0
				ifFalse:
					[printerCanvas := nil.
					self error: 'PrintSetupDialog error: ' , error printString].
			^nil]!

titleBlock
	^titleBlock!

titleBlock: anObject
	"
	[:printerCanvas :pageNumber :leftMargin :rightMargin | 
		]"

	titleBlock := anObject! !
!Printer categoriesFor: #defaultTitleBlock!accessing!defaults!public! !
!Printer categoriesFor: #initialize!initializing!public! !
!Printer categoriesFor: #margins!accessing!public! !
!Printer categoriesFor: #pageRange!accessing!public! !
!Printer categoriesFor: #pageRangeLimits:!accessing!public! !
!Printer categoriesFor: #pageSize!accessing!public! !
!Printer categoriesFor: #print:!operations!printing!public! !
!Printer categoriesFor: #print:selectionRange:!operations!printing!public! !
!Printer categoriesFor: #printerCanvas!accessing!public! !
!Printer categoriesFor: #printPreview:!operations!public! !
!Printer categoriesFor: #printPreview:for:!operations!public! !
!Printer categoriesFor: #selectionRange!accessing!public! !
!Printer categoriesFor: #setPrinterCanvas!operations!printing!public! !
!Printer categoriesFor: #showPageSetupDialog:!operations!public! !
!Printer categoriesFor: #showPrintDialog:selectionRange:!operations!public! !
!Printer categoriesFor: #titleBlock!accessing!public! !
!Printer categoriesFor: #titleBlock:!accessing!public! !

!Printer class methodsFor!

new
	^super new initialize!

printerNames
	| printerInfo |
	#JamesFoster.
	printerInfo := (String new: 1024) asParameter.
	KernelLibrary default
		getProfileString: 'devices' asParameter
		keyName: nil
		default: String new asParameter
		returnedString: printerInfo
		size: printerInfo size.
	^(printerInfo subStrings: Character null) select: [:each | each notEmpty]!

selectPrinterNameWithPrompt: promptString default: defaultString
	| list |
	#JamesFoster.
	list := self printerNames asOrderedCollection.
	(list includes: defaultString)
		ifTrue:
			[list
				remove: defaultString;
				addFirst: defaultString].
	^ChoicePrompter choices: list caption: promptString! !
!Printer class categoriesFor: #new!object creation!public! !
!Printer class categoriesFor: #printerNames!accessing!public! !
!Printer class categoriesFor: #selectPrinterNameWithPrompt:default:!helpers!public! !


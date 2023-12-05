"Filed out from Dolphin Smalltalk"!

Object subclass: #Printer
	instanceVariableNames: 'devNames devMode rtMargin margins selectionRange pageRanges pageRangeLimits titleBlock printerCanvas'
	classVariableNames: ''
	poolDictionaries: 'PrintingConstants Win32Constants'
	classInstanceVariableNames: ''!
Printer guid: (GUID fromString: '{38d2291d-3137-45ff-9573-b92ae401f1a8}')!
Printer comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!Printer categoriesForClass!IDB Goodies! !
!Printer methodsFor!

cacheDeviceInfo: aDeviceStructure
	devMode := aDeviceStructure devMode.
	devNames := aDeviceStructure devNames!

defaultTitleBlock
	^nil!

initialize
	super initialize.
	titleBlock := self defaultTitleBlock.
	pageRanges := #().
	self showPageSetupDialog: false.
	self showPrintDialog: false selectionRange: (1 to: 0)!

margins
	^margins!

pageRangeLimits: anObject
	pageRangeLimits := anObject!

pageRanges
	^pageRanges!

pageSize
	^(printerCanvas getDeviceCaps: PHYSICALWIDTH) @ (printerCanvas getDeviceCaps: PHYSICALHEIGHT)!

print: aView
	self print: aView selectionRange: aView selectionRange!

print: aView selectionRange: anInterval
	(self showPrintDialog: true selectionRange: anInterval)
		ifTrue:
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
	| hDC |
	hDC := GDILibrary default
				createDC: devNames driverName
				lpszDevice: devNames deviceName
				lpszOutput: devNames outputName
				lpInitData: devMode.
	self assert: [hDC notNil].
	printerCanvas := PrinterCanvas withOwnedDC: hDC asInteger!

showPageSetupDialog: aBoolean
	"aBoolean is false if we don't want the dialog to be displayed, just return the defaults"

	| pageSetupDlg |
	pageSetupDlg := PageSetupDialog new.
	pageSetupDlg ownerView: View active.
	rtMargin ifNotNil: [pageSetupDlg margins: rtMargin].
	aBoolean
		ifTrue: 
			[devMode ifNotNil: [pageSetupDlg devMode: devMode].
			devNames ifNotNil: [pageSetupDlg devNames: devNames]]
		ifFalse: [pageSetupDlg returnDefaults].
	pageSetupDlg showModal
		ifNil: [^nil]
		ifNotNil: 
			["convert mm margin to inches"
			rtMargin := pageSetupDlg margins.
			margins := (pageSetupDlg flags anyMask: PSD_INHUNDREDTHSOFMILLIMETERS)
						ifTrue: [(rtMargin topLeft / 2.54 corner: rtMargin bottomRight / 2.54) truncated]
						ifFalse: [rtMargin].
			self cacheDeviceInfo: pageSetupDlg]!

showPrintDialog: showBoolean selectionRange: anInterval
	"aBoolean is false if we don't want the dialog to be displayed, just set the defaults"

	| printDlg mode |
	printDlg := PrintDialog new.
	printDlg
		caption: '<s>: Print' << SessionManager current applicationName;
		ownerView: View active;
		pageRanges: pageRanges;
		printableRange: (1 to: (pageRangeLimits ifNil: [16rFFFF] ifNotNil: [pageRangeLimits stop])).
	anInterval isEmpty ifTrue: [printDlg disablePrintSelectionOnly].
	showBoolean
		ifTrue: 
			[printDlg
				devMode: devMode;
				devNames: devNames]
		ifFalse: [printDlg returnDefaults].
	printDlg showModal ifNotNil: [:canvas | canvas free].
	printDlg result ~~ #cancel
		ifTrue: 
			[mode := printDlg rangeMode.
			selectionRange := mode == #selectionOnly ifTrue: [anInterval].
			pageRanges := printDlg pageRanges.
			self cacheDeviceInfo: printDlg].
	^printDlg result == #print!

titleBlock
	^titleBlock!

titleBlock: anObject
	"
	[:printerCanvas :pageNumber :leftMargin :rightMargin | 
		]"

	titleBlock := anObject! !
!Printer categoriesForMethods!
cacheDeviceInfo:!operations!private! !
defaultTitleBlock!accessing!defaults!public! !
initialize!initializing!public! !
margins!accessing!public! !
pageRangeLimits:!accessing!public! !
pageRanges!accessing!public! !
pageSize!accessing!public! !
print:!operations!printing!public! !
print:selectionRange:!operations!printing!public! !
printerCanvas!accessing!public! !
printPreview:!operations!public! !
printPreview:for:!operations!public! !
selectionRange!accessing!public! !
setPrinterCanvas!operations!printing!public! !
showPageSetupDialog:!operations!public! !
showPrintDialog:selectionRange:!operations!public! !
titleBlock!accessing!public! !
titleBlock:!accessing!public! !
!

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
!Printer class categoriesForMethods!
new!object creation!public! !
printerNames!accessing!public! !
selectPrinterNameWithPrompt:default:!helpers!public! !
!


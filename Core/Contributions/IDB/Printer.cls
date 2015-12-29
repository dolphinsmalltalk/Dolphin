"Filed out from Dolphin Smalltalk X6"!

Object subclass: #Printer
	instanceVariableNames: 'hDevNames hDevMode rtMargin margins selectionRange pageRange titleBlock'
	classVariableNames: 'Default'
	poolDictionaries: 'PrintingConstants ScintillaConstants Win32Constants'
	classInstanceVariableNames: ''!
Printer guid: (GUID fromString: '{38D2291D-3137-45FF-9573-B92AE401F1A8}')!
Printer comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!Printer categoriesForClass!IDB Goodies!Kernel-Objects! !
!Printer methodsFor!

defaultTitleBlock
	^self subclassResponsibility!

initialize
	super initialize.
	hDevMode := hDevNames := 0.
	titleBlock := self defaultTitleBlock.
	self showPageSetupDialog: false!

print: aView showDialog: aBoolean 
	(self showPrintDialog: aBoolean selectionRange: aView selectionRange) 
		ifNotNil: 
			[:arg | 
			aView 
				printOn: arg
				margins: margins
				selectionRange: selectionRange
				pageRange: pageRange
				titleBlock: titleBlock]!

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
	
	[SessionManager inputState startIdleTimer: active.
	apiResult := ComDlgLibrary default pageSetupDlg: pageSetupDlg asParameter] 
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
				ifFalse: [self error: 'PageSetupDialog error: ' , error printString]]!

showPrintDialog: showBoolean selectionRange: anInterval 
	"aBoolean is false if we don't want the dialog to be displayed, just set the defaults"

	| printDlg active apiResult |
	printDlg := PRINTDLG new.
	active := View active.
	printDlg
		ownerView: active;
		flags: ##(PD_USEDEVMODECOPIES | PD_ALLPAGES | PD_RETURNDC);
		nFromPage: 1;
		nToPage: 1;
		nMinPage: 1;
		nMaxPage: 16rFFFF;
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
	
	[SessionManager inputState startIdleTimer: active.
	apiResult := ComDlgLibrary default printDlg: printDlg asParameter] 
			ensure: [SessionManager inputState stopIdleTimer: active].
	apiResult 
		ifTrue: 
			[selectionRange := (printDlg flags anyMask: PD_SELECTION) ifTrue: [anInterval].
			pageRange := (printDlg flags anyMask: PD_PAGENUMS) 
						ifTrue: [printDlg nFromPage to: printDlg nToPage].
			hDevMode := printDlg hDevMode copy.
			hDevNames := printDlg hDevNames copy.
			^PrinterCanvas withOwnedDC: printDlg hDC]
		ifFalse: 
			[| error |
			(error := ComDlgLibrary default commDlgExtendedError) = 0 
				ifFalse: [self error: 'PrintSetupDialog error: ' , error printString].
			^nil]!

titleBlock
	^titleBlock!

titleBlock: anObject
	titleBlock := anObject! !
!Printer categoriesFor: #defaultTitleBlock!defaults!private! !
!Printer categoriesFor: #initialize!initializing!private! !
!Printer categoriesFor: #print:showDialog:!operations!printing!private! !
!Printer categoriesFor: #showPageSetupDialog:!operations!private! !
!Printer categoriesFor: #showPrintDialog:selectionRange:!operations!private! !
!Printer categoriesFor: #titleBlock!accessing!private! !
!Printer categoriesFor: #titleBlock:!accessing!private! !

!Printer class methodsFor!

default
	Default ifNil: [Default := self new initialize].
	^Default! !
!Printer class categoriesFor: #default!accessing!instance creation!public! !


"Filed out from Dolphin Smalltalk X6"!

IdeExtensions subclass: #IdePrinterExtensions
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IdePrinterExtensions guid: (GUID fromString: '{C257C45C-8A17-4A09-944E-7732133D8945}')!
IdePrinterExtensions comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!IdePrinterExtensions categoriesForClass!IDB Goodies! !
!IdePrinterExtensions class methodsFor!

extendMenuIn: aBrowser before: aSymbol 
	| menu |
	menu := aBrowser view menuBar find: 'File'.
	menu
		insertItem: (CommandMenuItem commandDescription: (ClosedCommandDescription 
							command: #pageSetup
							description: 'Page Setup...'
							queryBlock: 
								[:query | 
								query isEnabled: true.
								true]
							receiver: aBrowser))
			before: aSymbol;
		insertItem: (CommandMenuItem commandDescription: (ClosedCommandDescription 
							command: #print
							description: 'Print...'
							queryBlock: 
								[:query | 
								query isEnabled: aBrowser canPrint.
								true]
							receiver: aBrowser))
			before: aSymbol;
		insertItem: DividerMenuItem separator before: aSymbol! !
!IdePrinterExtensions class categoriesFor: #extendMenuIn:before:!helpers!public! !


"Filed out from Dolphin Smalltalk X6"!

Printer subclass: #IdePrinter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IdePrinter guid: (GUID fromString: '{D90015CD-DA64-4BC4-ACAB-B337BAAD2F27}')!
IdePrinter comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!IdePrinter categoriesForClass!IDB Goodies! !
!IdePrinter methodsFor!

defaultTitleBlock
	^
	[:printerCanvas :pageNumber :leftMargin :rightMargin | 
	printerCanvas
		font: (Font name: 'Arial' pointSize: 12) beBold;
		forecolor: Color black;
		setTextAlign: TA_LEFT;
		text: 'Dolphin X6 IDE Printer    ' , Date today printString at: leftMargin @ 40;
		setTextAlign: TA_RIGHT;
		text: 'Page: ' , pageNumber printString at: rightMargin @ 40]! !
!IdePrinter categoriesFor: #defaultTitleBlock!defaults!private! !

!IdePrinter class methodsFor!

kill
	"
IdePrinter kill
"

	Default := nil! !
!IdePrinter class categoriesFor: #kill!accessing!public! !


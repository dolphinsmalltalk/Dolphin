"Filed out from Dolphin Smalltalk"!

Object subclass: #ScintillaAnnotation
	instanceVariableNames: 'line text styles'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaAnnotation guid: (GUID fromString: '{2d20c021-0cef-46f7-ba44-4c4191189df9}')!
ScintillaAnnotation comment: ''!
!ScintillaAnnotation categoriesForClass!MVP-Views-Support! !
!ScintillaAnnotation methodsFor!

= comparand 
	^comparand class == self class and: [line = comparand line and: [text = comparand text]]!

hash
	^line hash bitXor: text hash!

line
	^line!

printOn: aStream 
	aStream
		basicPrint: self;
		nextPut: $(;
		display: self line;
		nextPutAll: ': ';
		display: self text;
		space;
		display: self styles;
		nextPut: $)!

setLine: anInteger text: aString styles: aRunArrayOfSymbol 
	line := anInteger.
	text := aString.
	styles := aRunArrayOfSymbol!

styles
	^styles!

text
	"Answer the text  of the annotation."

	^text! !
!ScintillaAnnotation categoriesForMethods!
=!comparing!public! !
hash!comparing!public! !
line!public! !
printOn:!printing!public! !
setLine:text:styles:!initializing!private! !
styles!accessing!public! !
text!accessing!public! !
!

!ScintillaAnnotation class methodsFor!

icon
	^ScintillaView icon!

line: anInteger text: aString style: aSymbol 
	^self 
		line: anInteger
		text: aString
		styles: (RunArray new: aString size withAll: aSymbol)!

line: anInteger text: aString styles: aSequencedReadableCollectionOfSymbol 
	^(self new)
		setLine: anInteger
			text: aString
			styles: aSequencedReadableCollectionOfSymbol;
		yourself! !
!ScintillaAnnotation class categoriesForMethods!
icon!constants!development!public! !
line:text:style:!public! !
line:text:styles:!initializing!private! !
!


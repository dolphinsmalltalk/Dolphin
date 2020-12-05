"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'UI.Scintilla.Annotation'
	instanceVariableNames: 'line text styles'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.Annotation guid: (Core.GUID fromString: '{2d20c021-0cef-46f7-ba44-4c4191189df9}')!
UI.Scintilla.Annotation comment: ''!
!UI.Scintilla.Annotation categoriesForClass!MVP-Views-Support! !
!UI.Scintilla.Annotation methodsFor!

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
!UI.Scintilla.Annotation categoriesFor: #=!comparing!public! !
!UI.Scintilla.Annotation categoriesFor: #hash!comparing!public! !
!UI.Scintilla.Annotation categoriesFor: #line!public! !
!UI.Scintilla.Annotation categoriesFor: #printOn:!printing!public! !
!UI.Scintilla.Annotation categoriesFor: #setLine:text:styles:!initializing!private! !
!UI.Scintilla.Annotation categoriesFor: #styles!accessing!public! !
!UI.Scintilla.Annotation categoriesFor: #text!accessing!public! !

!UI.Scintilla.Annotation class methodsFor!

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
!UI.Scintilla.Annotation class categoriesFor: #icon!constants!development!public! !
!UI.Scintilla.Annotation class categoriesFor: #line:text:style:!public! !
!UI.Scintilla.Annotation class categoriesFor: #line:text:styles:!initializing!private! !


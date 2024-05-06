"Filed out from Dolphin Smalltalk"!

Object subclass: #ScintillaStyler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ScintillaConstants'
	classInstanceVariableNames: ''!

ScintillaStyler guid: (GUID fromString: '{7dc234ba-44c2-490a-a7a1-7aafd6b577ec}')!

ScintillaStyler isAbstract: true!

ScintillaStyler comment: 'ScintillaStyler is the abstract class of objects responsible for dynamically ''colouring'' the text in a <ScintillaView>. This is done by applying text styles in runs between start and end points. Initially the control will request that the entire text be styled, then as the view is edited it will send further requests to style modified text. Concrete subclasses define the manner in which the text is styled, for example to do syntax colouring for a particular programming language.
'!

!ScintillaStyler categoriesForClass!Kernel-Objects! !

!ScintillaStyler methodsFor!

blockSize
	"Private - Style in blocks of a maximum of 16k characters. This allows the editor to remain
	responsive while the large bodies of text are styled incrementally."

	^##(32 * 1024)!

colorText: aString in: aScintillaView startingAt: aSmallInteger 
	"Colour the <String> of text from the <ScintillaView>, starting at the character position
	identified by the <Integer> argument. Note that the initial styling position has already
	been set."

	^self subclassResponsibility!

colorTextFrom: startInteger to: endInteger in: aScintillaView
	"#colorText:in:startingAt: may not be implemented in a deployed application that does not use container based styling (i.e. all concrete stylers are stripped)."

	self
		colorText: (aScintillaView plainTextFrom: startInteger to: endInteger)
		in: aScintillaView
		startingAt: startInteger!

onStyleNeeded: aScintillaView from: startInteger to: stopInteger 
	"Callback from Scintilla requesting that the specified text range be coloured."

	| startPos |
	startPos := self stylingStartBefore: startInteger in: aScintillaView.
	self 
		resetStylingIn: aScintillaView
		from: startPos
		to: stopInteger.
	self 
		colorTextFrom: startPos
		to: (startInteger + self blockSize min: stopInteger)
		in: aScintillaView!

prepareToStyleView: aScintillaView
	"The receiver has been set up as the styler for the specified <ScintillaView>. This is an
	opportunity to initialise that view appropriately for this styler."!

resetStylingIn: aScintillaView from: startPos to: anInteger 
	aScintillaView startStylingFrom: startPos!

stylingStartBefore: startInteger in: aScintillaView 
	"Locate the position before the <integer>, startInteger, from which to start styling in the
	<ScintillaView>, aScintillaView. This needs to be a position from which we can safely start
	the scanner from its start state."

	"Implementation Note: Step back over any whitespace until we find the end of a token, and
	then back until we find further whitespace before that. This is necessary to cover the case
	where backspace is used to delete the last character in the token thus changing its
	interpretation (e.g. deleting the close quote of a string), or when the interpretation of a
	token changes when a further character is typed (e.g. typing a multi-part keyword literal
	and entering the colon on the second keyword). We must then step back to the start of the
	token so that we may kick off the lexer from its start state. We are more interested in
	speed than elegance here."

	| prev |
	startInteger <= 1 ifTrue: [^1].
	prev := startInteger - 1.
	(aScintillaView styleNamed: #whitespace) 
		ifNil: 
			["No whitespace style, so must look for whitespace characters in the #normal style"
			| white |
			white := aScintillaView whitespaces.
			
			[prev > 0 and: 
					[(aScintillaView styleIdAt: prev) == 0 
						and: [white identityIncludes: (aScintillaView characterAt: prev)]]] 
					whileTrue: [prev := prev - 1].
			
			[prev == 0 or: 
					[(aScintillaView styleIdAt: prev) == 0 
						and: [white identityIncludes: (aScintillaView characterAt: prev)]]] 
					whileFalse: [prev := prev - 1]]
		ifNotNil: 
			[:style | 
			| id |
			id := style id.
			[prev > 0 and: [(aScintillaView styleIdAt: prev) == id]] whileTrue: [prev := prev - 1].
			[prev == 0 or: [(aScintillaView styleIdAt: prev) == id]] whileFalse: [prev := prev - 1]].
	^prev + 1! !

!ScintillaStyler categoriesForMethods!
blockSize!constants!private! !
colorText:in:startingAt:!operations!private! !
colorTextFrom:to:in:!event handling!public! !
onStyleNeeded:from:to:!event handling!public! !
prepareToStyleView:!initializing!public! !
resetStylingIn:from:to:!helpers!private! !
stylingStartBefore:in:!event handling!public! !
!

!ScintillaStyler class methodsFor!

icon
	^ScintillaView icon!

new
	^super new initialize! !

!ScintillaStyler class categoriesForMethods!
icon!constants!development!public! !
new!instance creation!public! !
!


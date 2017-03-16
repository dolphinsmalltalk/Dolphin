"Filed out from Dolphin Smalltalk 7"!

ScintillaStyler subclass: #DiffsScintillaStyler
	instanceVariableNames: 'diffs'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DiffsScintillaStyler guid: (GUID fromString: '{96903aa2-f14b-4deb-ba96-92a484fb00f6}')!
DiffsScintillaStyler comment: ''!
!DiffsScintillaStyler categoriesForClass!Kernel-Objects! !
!DiffsScintillaStyler methodsFor!

colorNormal: aScintillaView from: current to: anInteger 
	| stream last whitespace |
	stream := (aScintillaView plainTextFrom: current to: anInteger) readStream.
	last := 0.
	whitespace := self lookupStyle: self whitespaceStyleName in: aScintillaView.
	[stream atEnd] whileFalse: 
			[stream skipSeparators.
			aScintillaView applyStyle: whitespace toNext: stream position - last.
			last := stream position.
			stream skipWhile: [:ch | ch isSeparator not].
			aScintillaView applyStyleId: 0 toNext: stream position - last.
			last := stream position]!

diffs: anObject
	diffs := anObject!

initialize
	diffs := #()!

lookupStyle: aSymbol in: aScintillaView 
	^(aScintillaView styleNamed: aSymbol) ifNil: [0] ifNotNil: [:style | style id]!

onStyleNeeded: aScintillaView from: startInteger to: stopInteger 
	"Callback from Scintilla requesting that the specified text range be coloured."

	| current |
	current := startInteger.
	diffs do: 
			[:each | 
			| intersection |
			intersection := (each start max: current) to: (each stop min: stopInteger).
			intersection notEmpty 
				ifTrue: 
					[self 
						colorNormal: aScintillaView
						from: current
						to: each start - 1.
					current := intersection stop + 1.
					aScintillaView applyStyle: #diff toNext: current - each start]].
	"Any remaining text has no diffs"
	self 
		colorNormal: aScintillaView
		from: current
		to: stopInteger!

whitespaceStyleName
	^#whitespace! !
!DiffsScintillaStyler categoriesFor: #colorNormal:from:to:!public! !
!DiffsScintillaStyler categoriesFor: #diffs:!accessing!public! !
!DiffsScintillaStyler categoriesFor: #initialize!initializing!private! !
!DiffsScintillaStyler categoriesFor: #lookupStyle:in:!helpers!private! !
!DiffsScintillaStyler categoriesFor: #onStyleNeeded:from:to:!event handling!public! !
!DiffsScintillaStyler categoriesFor: #whitespaceStyleName!constants!private! !


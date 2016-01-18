"Filed out from Dolphin Smalltalk 7"!

MultilineTextEditTest subclass: #RichTextEditTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RichTextEditTest guid: (GUID fromString: '{BC34BF3F-4B1C-44A8-9C0C-B25DB1E72469}')!
RichTextEditTest comment: ''!
!RichTextEditTest categoriesForClass!Unclassified! !
!RichTextEditTest methodsFor!

classToTest
	^RichTextEdit!

margins
	^0 @ 1!

testCharNearestPosition
	| text point char |
	#'1551'.
	text := (FileStream read: SourceManager default sourcesFileName) next: 100000.
	presenter text: text.
	(Array 
		with: 1
		with: (presenter view positionAtLine: 2)
		with: (presenter view positionAtLine: 1000)
		with: (presenter view positionAtLine: (presenter view lineFromPosition: text size // 2))
		with: (presenter view positionAtLine: (presenter view lineFromPosition: text size))) do: 
				[:each | 
				point := presenter view positionOfChar: each.
				char := presenter view charNearestPosition: point.
				self assert: char = each]! !
!RichTextEditTest categoriesFor: #classToTest!helpers!private! !
!RichTextEditTest categoriesFor: #margins!private!unit tests! !
!RichTextEditTest categoriesFor: #testCharNearestPosition!public!unit tests! !


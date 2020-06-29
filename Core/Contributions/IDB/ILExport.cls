"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ILExport
	instanceVariableNames: 'images colorTable bitmap'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ILExport guid: (GUID fromString: '{9a0859d6-5add-4465-b138-4f154e114e37}')!
ILExport comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ILExport categoriesForClass!IDB Goodies! !
!ILExport methodsFor!

createBitmap: aPoint
	bitmap := DeviceIndependentBitmap 
				width: aPoint x
				height: aPoint y
				depth: colorTable size lowBit - 1.
	bitmap
		setMap3DColors: false;
		setColorTable: colorTable.
	bitmap erase!

createColorTable: aBag force256: aBoolean
	| colors |
	colors := (aBag asSet 
				asSortedCollection: [:a :b | (aBag occurrencesOf: a) > (aBag occurrencesOf: b)]) 
					asOrderedCollection.
	colors := (colors copyWithoutAll: (Array with: Color white with: Color black))
				addFirst: Color black;
				addLast: Color white;
				asArray.
	aBoolean 
		ifTrue: [colors := colors resize: 256]
		ifFalse: 
			[(colors size between: 3 and: 15) ifTrue: [colors := colors resize: 16].
			(colors size between: 17 and: 255) ifTrue: [colors := colors resize: 256]].
	colors := colors copyReplacing: nil withObject: Color white.
	colorTable := StructureArray length: colors size elementClass: RGBQUAD.
	1 to: colors size
		do: [:index | colorTable at: index put: (RGBQUAD fromColor: (colors at: index))]!

setImages: aCollection
	images := aCollection! !
!ILExport categoriesFor: #createBitmap:!operations!public! !
!ILExport categoriesFor: #createColorTable:force256:!operations!public! !
!ILExport categoriesFor: #setImages:!accessing!public! !

!ILExport class methodsFor!

export: aCollection to: aStream
	(self new setImages: aCollection) exportTo: aStream! !
!ILExport class categoriesFor: #export:to:!operations!public! !


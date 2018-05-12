"Filed out from Dolphin Smalltalk 7"!

Color subclass: #IndexedColor
	instanceVariableNames: 'index'
	classVariableNames: 'ColorNames ColorsByIndex ColorsByName'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IndexedColor guid: (GUID fromString: '{87b4c53a-026e-11d3-9fd7-00a0cc3e4a32}')!
IndexedColor comment: 'IndexedColor instances represent the 16 standard colours defined by Windows that are always available in the standard system palette. There are actually 20 indexed colours, but 4 of these do not necessarily map to a fixed colour name.

We have used a logical system to name the colours, but Microsoft also use the following name,  e.g. in the common Font dialog:

		black
		maroon		(darkRed)
		green		(darkGreen)
		olive		(brown)
		navy		(darkBlue)
		purple		(darkMagenta)
		teal			(darkCyan)
		gray		(darkGray)
		silver 		(gray)
		red
		lime			(green)
		yellow		
		blue
		fuschia		(magenta)
		acqua		(cyan)
		white

These names will vary by locale, where as Dolphin''s symbolic names will always be the same.

As of Dolphin 6.0 there is a single, unique, instance of IndexedColor for each of the standard system colours.'!
!IndexedColor categoriesForClass!Drawing! !
!IndexedColor methodsFor!

= anIndexedColour
	"Answer true if anIndexedColour is equal to (has the same index as) the receiver."

	^self species == anIndexedColour species and: [self index = anIndexedColour index]!

asIndexedColor
	"Answer the receiver as anIndexedColour."

	^self!

asParameter
	"Answer the receiver such that it can be used for an API call."

	^index!

asRGB
	"Answer the receiver as an RGB using the default palette."

	^SystemMetrics current hasGdiPalettes 
		ifTrue: [self asRGBUsingPalette: self defaultPalette]
		ifFalse: [self asRGBUsingNoPalette]!

asRGBUsingNoPalette
	"Answer the receiver as an RGB  when no palette is available ."

	#wineFix.
	^RGB stdColor: (ColorNames at: self index)!

asRGBUsingPalette: anExternalHandle 
	"Answer the <RGB> equivalent of the receiver as mapped in the palette with the specified
	handle."

	| paletteEntry |
	paletteEntry := PALETTEENTRY new.
	^(GDILibrary default 
		getPaletteEntries: anExternalHandle
		iStartIndex: index
		nEntries: 1
		lppe: paletteEntry) == 0 
		ifTrue: [GDILibrary default systemError]
		ifFalse: [paletteEntry asColor]!

hash
	"Answer the SmallInteger hash value for the receiver."

	^index hash!

index
	"Answer the receiver's index."

	^index!

printOn: aStream
	"Put an ASCII representation of receiver onto aStream."

	aStream nextPut: $(.
	(ColorNames lookup: self index)
		ifNil: 
			[aStream
				display: self class;
				space;
				display: #withIndex:;
				space;
				print: self index]
		ifNotNil: 
			[:colourName |
			aStream
				display: Color;
				space;
				display: colourName].
	aStream nextPut: $)!

setIndex: anInteger
	"Private - Set the receiver's index to anInteger."

	index := anInteger! !
!IndexedColor categoriesFor: #=!comparing!public! !
!IndexedColor categoriesFor: #asIndexedColor!converting!public! !
!IndexedColor categoriesFor: #asParameter!converting!public! !
!IndexedColor categoriesFor: #asRGB!converting!public!wine fix! !
!IndexedColor categoriesFor: #asRGBUsingNoPalette!converting!public!wine fix! !
!IndexedColor categoriesFor: #asRGBUsingPalette:!converting!public! !
!IndexedColor categoriesFor: #hash!comparing!public! !
!IndexedColor categoriesFor: #index!accessing!public! !
!IndexedColor categoriesFor: #printOn:!development!printing!public! !
!IndexedColor categoriesFor: #setIndex:!accessing!private! !

!IndexedColor class methodsFor!

initialize
	"Initialise the map of standard colour names to indices.
		self initialize.
	"

	| colorsByIndex colorNames colorsByName |
	colorsByName := IdentityDictionary new.
	colorsByIndex := IdentityDictionary new.
	colorNames := IdentityDictionary new.
	#(#(#black 16r1000000) #(#darkRed 16r1000001) #(#darkGreen 16r1000002) #(#brown 16r1000003) #(#darkBlue 16r1000004) #(#darkMagenta 16r1000005) #(#darkCyan 16r1000006) #(#gray 16r1000007) #(#darkGray 16r100000C) #(#red 16r100000D) #(#green 16r100000E) #(#yellow 16r100000F) #(#blue 16r1000010) #(#magenta 16r1000011) #(#cyan 16r1000012) #(#white 16r1000013))
		do: 
			[:each |
			| color |
			colorNames at: each second put: each first.
			color := self basicNew setIndex: each second.
			color isImmutable: true.
			colorsByName at: each first put: color.
			colorsByIndex at: each second put: color].
	colorNames
		shrink;
		isImmutable: true.
	colorsByName
		shrink;
		isImmutable: true.
	colorsByIndex
		shrink;
		isImmutable: true.
	self addClassConstant: 'ColorNames' value: colorNames.
	self addClassConstant: 'ColorsByName' value: colorsByName.
	self addClassConstant: 'ColorsByIndex' value: colorsByIndex!

stbReadFrom: anSTBInFiler format: anSTBClassConversion 
	"Read an instance of the receiver from the binary filer, aSTBInFiler."

	"Implementation Note: Overridden in order to maintain unique instances without using an
	STBSingletonProxy."

	| answer ref |
	anSTBInFiler version < 3 ifTrue: [anSTBInFiler stream skip: 4].
	"Make a placeholder for the IndexedColor"
	ref := anSTBInFiler register: nil.
	answer := self withIndex: anSTBInFiler basicNext.
	anSTBInFiler fixup: ref to: answer.
	^answer!

stdColor: aSymbol 
	"Answer an instance whose name is aSymbol."

	^ColorsByName at: aSymbol!

withIndex: anInteger 
	"Answer an instance whose index is anInteger."

	^ColorsByIndex at: anInteger
		ifAbsent: 
			[(self basicNew)
				setIndex: anInteger;
				yourself]! !
!IndexedColor class categoriesFor: #initialize!development!initializing!public! !
!IndexedColor class categoriesFor: #stbReadFrom:format:!binary filing!public! !
!IndexedColor class categoriesFor: #stdColor:!instance creation!public! !
!IndexedColor class categoriesFor: #withIndex:!instance creation!public! !


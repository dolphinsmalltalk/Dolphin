"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.AbstractCustomLineCapInitializer subclass: #'Graphics.Gdiplus.CustomLineCapInitializer'
	instanceVariableNames: 'fillPath strokePath baseCap baseInset strokeCaps'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.CustomLineCapInitializer guid: (Core.GUID fromString: '{ea986b36-8426-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.CustomLineCapInitializer comment: ''!
!Graphics.Gdiplus.CustomLineCapInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self == anObject or: 
			[super = anObject and: 
					[strokePath = anObject strokePath and: 
							[fillPath = anObject fillPath and: 
									[baseCap = anObject baseCap
										and: [baseInset = anObject baseInset and: [strokeCaps = anObject strokeCaps]]]]]]!

applyAdditionalAttributes: aHandle
	super applyAdditionalAttributes: aHandle.
	strokeCaps = ##({LineCapFlat. LineCapFlat})
		ifFalse: 
			[Gdip
				gdipSetCustomLineCapStrokeCaps: aHandle
				startCap: (strokeCaps at: 1)
				endCap: (strokeCaps at: 2)]!

baseCap
	^baseCap!

baseCapOf: aCustomLineCap
	| buf |
	buf := UInt32Bytes new.
	Gdip gdipGetCustomLineCapBaseCap: aCustomLineCap asParameter baseCap: buf.
	^buf asSignedInteger!

baseCapOf: aCustomLineCap set: aLineCapConstant
	baseCap := aLineCapConstant.
	aCustomLineCap basicHandle
		ifNotNil: [:handle | Gdip gdipSetCustomLineCapBaseCap: handle baseCap: aLineCapConstant]!

baseInset
	^baseInset!

baseInsetOf: aCustomLineCap
	| buf |
	buf := UInt32Bytes new.
	Gdip gdipGetCustomLineCapBaseInset: aCustomLineCap asParameter inset: buf.
	^buf floatAtOffset: 0!

baseInsetOf: aCustomLineCap set: aNumber
	baseInset := aNumber.
	aCustomLineCap basicHandle
		ifNotNil: [:handle | Gdip gdipSetCustomLineCapBaseInset: handle inset: aNumber asFloat]!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip
		gdipCreateCustomLineCap: fillPath asParameter
		strokePath: strokePath asParameter
		baseCap: baseCap
		baseInset: baseInset
		customCap: gpHandle.
	^gpHandle!

defaultStrokeCaps
	^##({LineCapFlat. LineCapFlat})!

fillPath
	^fillPath!

fillPath: aFillPath strokePath: aStrokePath baseCap: aLineCapConstant baseInset: aRealBaseInset
	widthScale := 1.
	strokeJoin := LineJoinMiter.
	fillPath := aFillPath.
	strokePath := aStrokePath.
	baseCap := aLineCapConstant.
	baseInset := aRealBaseInset.
	strokeCaps := self defaultStrokeCaps.
	^self!

hash
	"Answer the <integer> hash value for the receiver."

	^(((((super hash + strokeCaps hash) hashMultiply + fillPath hash) hashMultiply + baseCap hash)
		hashMultiply + baseInset hash)
		hashMultiply + strokePath hash)
		hashMultiply!

initializeFromHandle: aHandle
	"Private - Cache all the attributes of the native Gdiplus CustomLineCap identified by the specified <External.Handle> into the receiver."

	"We cannot query the fillPath or strokePath, so cannot populate the receiver correctly from a handle."

	^self shouldNotImplement!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^strokeCaps = self defaultStrokeCaps!

postCopy
	fillPath := fillPath copy.
	strokePath := strokePath copy.
	^super postCopy!

printAttributesOn: aStream
	strokePath
		ifNil: 
			[aStream
				nextPutAll: 'fillPath: ';
				print: fillPath]
		ifNotNil: 
			[aStream
				nextPutAll: 'strokePath: ';
				print: strokePath].
	aStream nextPutAll: ' baseCap: '.
	self printLineCapName: baseCap on: aStream.
	aStream
		nextPutAll: ' baseInset: ';
		print: baseInset.
	strokeCaps = ##({LineCapFlat. LineCapFlat})
		ifFalse: 
			[aStream nextPutAll: '; startCap: '.
			self printLineCapName: strokeCaps first on: aStream.
			aStream nextPutAll: ' endCap: '.
			self printLineCapName: strokeCaps second on: aStream].
	super printAttributesOn: aStream!

strokeCaps
	^strokeCaps!

strokeCapsOf: aCustomLineCap
	| buf |
	buf := ByteArray newFixed: 8.
	Gdip
		gdipGetCustomLineCapStrokeCaps: aCustomLineCap asParameter
		startCap: buf
		endCap: buf yourAddress + 4.
	^{buf sdwordAtOffset: 0. buf sdwordAtOffset: 4}!

strokeCapsOf: aCustomLineCap setStart: startLineCapConstant end: endLineCapConstant
	strokeCaps := {startLineCapConstant. endLineCapConstant}.
	aCustomLineCap basicHandle
		ifNotNil: 
			[:handle |
			Gdip
				gdipSetCustomLineCapStrokeCaps: handle
				startCap: startLineCapConstant
				endCap: endLineCapConstant]!

strokePath
	^strokePath! !
!Graphics.Gdiplus.CustomLineCapInitializer categoriesForMethods!
=!comparing!public! !
applyAdditionalAttributes:!attributes!private!realizing/unrealizing! !
baseCap!accessing!private! !
baseCapOf:!attributes!private! !
baseCapOf:set:!attributes!private! !
baseInset!accessing!private! !
baseInsetOf:!attributes!private! !
baseInsetOf:set:!attributes!private! !
basicCreateHandle!private!realizing/unrealizing! !
defaultStrokeCaps!constants!private! !
fillPath!accessing!private! !
fillPath:strokePath:baseCap:baseInset:!initializing!private! !
hash!comparing!public! !
initializeFromHandle:!initializing!private! !
isSelfEvaluating!public!testing! !
postCopy!copying!public! !
printAttributesOn:!printing!private! !
strokeCaps!accessing!private! !
strokeCapsOf:!attributes!private! !
strokeCapsOf:setStart:end:!attributes!private! !
strokePath!accessing!private! !
!

!Graphics.Gdiplus.CustomLineCapInitializer class methodsFor!

fillPath: fillPath strokePath: strokePath baseCap: baseCap baseInset: baseInset 
	^self new 
		fillPath: fillPath
		strokePath: strokePath
		baseCap: baseCap
		baseInset: baseInset!

stbConvertFrom: anSTBClassFormat
	^
	[:data |
	self
		fillPath: (data at: 2)
		strokePath: (data at: 3)
		baseCap: (data at: 4)
		baseInset: (data at: 5)]! !
!Graphics.Gdiplus.CustomLineCapInitializer class categoriesForMethods!
fillPath:strokePath:baseCap:baseInset:!instance creation!public! !
stbConvertFrom:!binary filing!public! !
!


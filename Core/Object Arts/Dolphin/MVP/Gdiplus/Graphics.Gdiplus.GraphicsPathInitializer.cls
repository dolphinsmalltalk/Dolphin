"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.GraphicsPathInitializer'
	instanceVariableNames: 'pathPoints pathTypes fillMode'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'FillModeNames' -> #('FillModeAlternate' 'FillModeWinding').
		'PathPointTypeNames' -> #('PathPointTypeStart' 'PathPointTypeLine' 16r2 'PathPointTypeBezier' 16r4 16r5 16r6)
	}!
Graphics.Gdiplus.GraphicsPathInitializer guid: (Core.GUID fromString: '{fcef1a11-834c-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.GraphicsPathInitializer comment: ''!
!Graphics.Gdiplus.GraphicsPathInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self == anObject or: 
			[self species == anObject species and: 
					[fillMode = anObject fillMode
						and: [pathTypes = anObject pathTypes and: [pathPoints = anObject pathPoints]]]]!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	pathPoints isEmpty
		ifTrue: [Gdip gdipCreatePath: fillMode path: gpHandle]
		ifFalse: 
			[Gdip
				gdipCreatePath2I: pathPoints
				types: pathTypes
				count: pathPoints size
				fillMode: fillMode
				path: gpHandle].
	^gpHandle!

fillMode
	^fillMode!

fillModeOf: aGraphicsPath set: aFillModeConstant
	Gdip gdipSetPathFillMode: aGraphicsPath handle fillMode: aFillModeConstant.
	fillMode := aFillModeConstant!

hash
	"Answer the <integer> hash value for the receiver."

	^(((self species hash + fillMode hash) hashMultiply + pathTypes hash) hashMultiply + pathPoints hash)
		hashMultiply!

initializeFromHandle: aHandle
	"Private - Cache all the attributes of the native Gdiplus GraphicsPath identified by the specified <External.Handle> into the receiver."

	| buf count |
	aHandle isNil ifTrue: [^self].
	buf := ByteArray newFixed: 4.
	Gdip gdipGetPathFillMode: aHandle fillMode: buf.
	fillMode := buf uint32AtOffset: 0.
	Gdip gdipGetPointCount: aHandle count: buf.
	count := buf int32AtOffset: 0.
	count <= 0
		ifTrue: 
			[pathPoints := #().
			pathTypes := #[].
			^self].
	"In general our Gdiplus wrappers user the functions taking integer co-ordinates. This assumes that the default pixel-offset mode (PixelOffsetModeDefault which is the same as PixelOffsetModeNone and PixelOffsetModeHighSpeed), where pixel's are centred on whole-integer co-ords, as opposed to PixelOffsetModeHighQuality/PixelOffsetModeHalf, where pixels are centred on the .5's, and makes most sense for mixed use of GDI and GDI+. The use of 32-bit single precision floats for co-ordinates would allow for more accuracy, and in particular less accumulated round error, but there are potentially negative impacts on overall performance and interoperability."
	pathPoints := POINTLArray new: count.
	Gdip
		gdipGetPathPointsI: aHandle
		points: pathPoints
		count: count.
	pathTypes := ByteArray new: count.
	Gdip
		gdipGetPathTypes: aHandle
		types: pathTypes
		count: count!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^true!

pathPoints
	^pathPoints!

pathTypes
	^pathTypes!

pointCountGet: aGpGraphicsPath
	| count |
	count := UInt32Bytes new.
	Gdip gdipGetPointCount: aGpGraphicsPath count: count.
	^count asSignedInteger!

points: aSequencedOfPoints types: aSequenceOfPathPointTypeConstants fillMode: aFillModeConstant
	pathPoints := POINTLArray marshal: aSequencedOfPoints.
	pathTypes := aSequenceOfPathPointTypeConstants asByteArray.
	fillMode := aFillModeConstant.
	^self!

printAttributesOn: aStream
	aStream
		nextPutAll: 'points: ';
		print: pathPoints asArray;
		nextPutAll: ' types: '.
	pathTypes isEmpty
		ifTrue: [aStream print: pathTypes]
		ifFalse: 
			[aStream nextPut: ${.
			pathTypes do: 
					[:each |
					self
						printEnum: (each bitAnd: PathPointTypePathTypeMask)
						names: PathPointTypeNames
						on: aStream.
					#('PathPointTypeDashMode' 'PathPointTypePathMarker' 'PathPointTypeCloseSubpath') do: 
							[:eachFlag |
							(each allMask: (Gdiplus at: eachFlag))
								ifTrue: 
									[aStream
										nextPut: $|;
										print: Gdiplus;
										nextPut: $.;
										nextPutAll: eachFlag]]]
				separatedBy: [aStream nextPutAll: '. '].
			aStream nextPut: $}].
	fillMode == FillModeAlternate ifTrue: [^self].
	aStream nextPutAll: ' fillMode: '.
	self
		printEnum: fillMode
		names: FillModeNames
		on: aStream! !
!Graphics.Gdiplus.GraphicsPathInitializer categoriesForMethods!
=!comparing!public! !
basicCreateHandle!private!realizing/unrealizing! !
fillMode!accessing!private! !
fillModeOf:set:!attributes!private! !
hash!comparing!public! !
initializeFromHandle:!initializing!private! !
isSelfEvaluating!public!testing! !
pathPoints!accessing!private! !
pathTypes!accessing!private! !
pointCountGet:!attributes!private! !
points:types:fillMode:!initializing!private! !
printAttributesOn:!attributes!printing!private! !
!

!Graphics.Gdiplus.GraphicsPathInitializer class methodsFor!

cloneHandle: aHandle
	| clone |
	clone := Handle new.
	Gdip gdipClonePath: aHandle clonePath: clone.
	^clone!

freeHandle: aHandle
	Gdip gdipDeletePath: aHandle!

points: aSequenceOfPoints types: aSequenceOfPathPointTypeConstants fillMode: aFillModeConstant 
	^self new 
		points: aSequenceOfPoints
		types: aSequenceOfPathPointTypeConstants
		fillMode: aFillModeConstant!

stbConvertFrom: anSTBClassFormat
	^
	[:data |
	self
		points: (data at: 2)
		types: (data at: 3)
		fillMode: (data at: 4)]!

stbVersion
	"1: pathPoints now stored as a POINTLArray to reduce marshalling/unmarshalling overhead."

	^1! !
!Graphics.Gdiplus.GraphicsPathInitializer class categoriesForMethods!
cloneHandle:!private!realizing/unrealizing! !
freeHandle:!private!realizing/unrealizing! !
points:types:fillMode:!instance creation!public! !
stbConvertFrom:!binary filing!public! !
stbVersion!binary filing!public! !
!


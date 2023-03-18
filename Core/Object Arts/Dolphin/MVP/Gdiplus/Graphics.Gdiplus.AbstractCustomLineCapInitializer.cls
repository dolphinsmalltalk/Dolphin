"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Initializer
	subclass: #'Graphics.Gdiplus.AbstractCustomLineCapInitializer'
	instanceVariableNames: 'strokeJoin widthScale'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.AbstractCustomLineCapInitializer guid: (Core.GUID fromString: '{155c3088-8cb5-4093-85dc-877ccbc9de0e}')!
Graphics.Gdiplus.AbstractCustomLineCapInitializer isNonInstantiable: true!
Graphics.Gdiplus.AbstractCustomLineCapInitializer comment: ''!
!Graphics.Gdiplus.AbstractCustomLineCapInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self species == anObject species
		and: [strokeJoin == anObject strokeJoin and: [widthScale = anObject widthScale]]!

applyAdditionalAttributes: aHandle
	widthScale = 1
		ifFalse: [Gdip gdipSetCustomLineCapWidthScale: aHandle widthScale: widthScale asFloat].
	strokeJoin == LineJoinMiter
		ifFalse: [Gdip gdipSetCustomLineCapStrokeJoin: aHandle lineJoin: strokeJoin]!

hash
	"Answer the <integer> hash value for the receiver."

	^((self species hash + strokeJoin hash) hashMultiply + widthScale hash) hashMultiply!

initializeFromHandle: aHandle
	"Private - Cache all the attributes of the native Gdiplus CustomLineCap identified by the specified <External.Handle> into the receiver."

	| buf |
	buf := ByteArray new: 4.
	Gdip gdipGetCustomLineCapStrokeJoin: aHandle lineJoin: buf.
	strokeJoin := buf int32AtOffset: 0.
	Gdip gdipGetCustomLineCapWidthScale: aHandle widthScale: buf.
	widthScale := buf floatAtOffset: 0!

printAttributesOn: aStream
	widthScale = 1
		ifFalse: 
			[aStream
				nextPutAll: '; ';
				nextPutAll: #widthScale:;
				space;
				print: widthScale].
	strokeJoin == LineJoinMiter
		ifFalse: 
			[aStream
				nextPutAll: '; ';
				nextPutAll: #strokeJoin:;
				space.
			self
				printEnum: strokeJoin
				names: Gdiplus.LineJoinNames
				on: aStream]!

strokeJoin
	^strokeJoin!

strokeJoinOf: aCustomLineCap
	| buf |
	buf := UInt32Bytes new.
	Gdip gdipGetCustomLineCapStrokeJoin: aCustomLineCap asParameter lineJoin: buf.
	^buf asSignedInteger!

strokeJoinOf: aCustomLineCap set: aLineJoinConstant
	strokeJoin := aLineJoinConstant.
	aCustomLineCap basicHandle
		ifNotNil: [:handle | Gdip gdipSetCustomLineCapStrokeJoin: handle lineJoin: aLineJoinConstant]!

widthScale
	^widthScale!

widthScaleOf: aCustomLineCap
	| buf |
	buf := UInt32Bytes new.
	Gdip gdipGetCustomLineCapWidthScale: aCustomLineCap asParameter widthScale: buf.
	^buf floatAtOffset: 0!

widthScaleOf: aCustomLineCap set: aNumber
	widthScale := aNumber.
	aCustomLineCap basicHandle
		ifNotNil: [:handle | Gdip gdipSetCustomLineCapWidthScale: handle widthScale: aNumber asFloat]! !
!Graphics.Gdiplus.AbstractCustomLineCapInitializer categoriesForMethods!
=!comparing!public! !
applyAdditionalAttributes:!attributes!private!realizing/unrealizing! !
hash!comparing!public! !
initializeFromHandle:!initializing!private! !
printAttributesOn:!printing!private! !
strokeJoin!accessing!private! !
strokeJoinOf:!attributes!private! !
strokeJoinOf:set:!attributes!private! !
widthScale!accessing!private! !
widthScaleOf:!attributes!private! !
widthScaleOf:set:!attributes!private! !
!

!Graphics.Gdiplus.AbstractCustomLineCapInitializer class methodsFor!

cloneHandle: aHandle
	| clone |
	clone := Handle new.
	Gdip gdipCloneCustomLineCap: aHandle clonedCap: clone.
	^clone!

freeHandle: aHandle
	Gdip gdipDeleteCustomLineCap: aHandle! !
!Graphics.Gdiplus.AbstractCustomLineCapInitializer class categoriesForMethods!
cloneHandle:!private!realizing/unrealizing! !
freeHandle:!private!realizing/unrealizing! !
!


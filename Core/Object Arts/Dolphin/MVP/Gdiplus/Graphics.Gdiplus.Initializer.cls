"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Graphics.Gdiplus.Initializer'
	instanceVariableNames: ''
	classVariableNames: 'UncachedAttributeValue'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'AnchorCapNames'
				-> #('LineCapNoAnchor' 'LineCapSquareAnchor' 'LineCapRoundAnchor' 'LineCapDiamondAnchor' 'LineCapArrowAnchor')
		}!

Graphics.Gdiplus.Initializer guid: (Core.GUID fromString: '{4687fd64-6607-4be7-b45b-f533ef511bc5}')!

Graphics.Gdiplus.Initializer isNonInstantiable: true!

Graphics.Gdiplus.Initializer comment: 'An instance of GdiplusInitializer serves as a proxy for a GdiplusBase factory.  Instances of subclasses contain enough information to create and recreate a corresponding GdiplusBase subclass instance. '!

!Graphics.Gdiplus.Initializer methodsFor!

applyAdditionalAttributes: aHandle
	"Nothing to do at this level"!

basicCreateHandle
	^self subclassResponsibility!

createHandle
	| handle |
	handle := self basicCreateHandle.
	self applyAdditionalAttributes: handle.
	^handle!

initializeFromHandle: aGpHandle
	"Private - Cache all the attributes of the native Gdiplus object identified by the specified <External.Handle> into the receiver."

	"In many subclasses not all attributes can be queried from the wrapped Gdiplus native object as the API is either not complete, or in a couple of cases the getter functions are present but not implemented."

	self error: 'Cannot build this initializer from Gdiplus native object'!

isPersistent
	"Answer true if the receiver holds sufficient information such that it can recreate the Gdiplus native object it describes exactly as it was across Smalltalk image save/restore. This is generally true."

	^true!

onPreSaveImage: aGdiplusObject
	"Private - The image is about to be saved. Cache any state that is needed to restore the object initialized by the receiver when the image is reloaded."

	!

printAttributesOn: aStream
	"Private"

	self subclassResponsibility!

printEnum: enumInteger names: anArrayOfStrings on: aStream
	aStream
		print: Gdiplus;
		nextPut: $.;
		nextPutAll: (anArrayOfStrings at: enumInteger + 1)!

printGdiplusObject: aGdiplusObject on: aStream
	self isSelfEvaluating
		ifTrue: 
			[aStream
				nextPut: $(;
				print: aGdiplusObject evaluationClass;
				space]
		ifFalse: 
			[aGdiplusObject basicPrintOn: aStream.
			aStream nextPut: $(].
	self printAttributesOn: aStream.
	aStream nextPut: $)!

printLineCapName: aLineCapConstant on: aStream
	aStream
		print: Gdiplus;
		nextPut: $.;
		nextPutAll: (Gdiplus nameOfLineCap: aLineCapConstant)!

printOn: aStream
	self isSelfEvaluating
		ifTrue: 
			[aStream
				nextPut: $(;
				print: self class;
				space]
		ifFalse: 
			[self basicPrintOn: aStream.
			aStream nextPut: $(].
	self printAttributesOn: aStream.
	aStream nextPut: $)! !

!Graphics.Gdiplus.Initializer categoriesForMethods!
applyAdditionalAttributes:!private!realizing/unrealizing! !
basicCreateHandle!private!realizing/unrealizing! !
createHandle!private!realizing/unrealizing! !
initializeFromHandle:!initializing!private! !
isPersistent!public!testing! !
onPreSaveImage:!event handling!private! !
printAttributesOn:!printing!private! !
printEnum:names:on:!printing!private! !
printGdiplusObject:on:!printing!public! !
printLineCapName:on:!printing!private! !
printOn:!printing!public! !
!

!Graphics.Gdiplus.Initializer class methodsFor!

cloneHandle: aHandle
	^self subclassResponsibility!

freeHandle: aHandle
	^self subclassResponsibility!

fromHandle: aHandle
	^self new initializeFromHandle: aHandle!

icon
	^Gdiplus icon!

initialize
	self addClassConstant: 'UncachedAttributeValue' value: Object new!

stbConvertFrom: anSTBClassFormat
	anSTBClassFormat version == 0 ifTrue: [^[:data | (data copyFrom: 2) becomeA: self]].
	^super stbConvertFrom: anSTBClassFormat!

stbVersion
	"1: As a general change, the library instance variable has been removed. There are additional changes in some subclasses."

	^1! !

!Graphics.Gdiplus.Initializer class categoriesForMethods!
cloneHandle:!private!realizing/unrealizing! !
freeHandle:!private!realizing/unrealizing! !
fromHandle:!instance creation!public! !
icon!constants!public! !
initialize!class initialization!public! !
stbConvertFrom:!binary filing!public! !
stbVersion!binary filing!public! !
!


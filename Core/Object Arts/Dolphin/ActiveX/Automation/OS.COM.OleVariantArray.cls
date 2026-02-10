"Filed out from Dolphin Smalltalk"!

External.ExternalArray
	subclass: #'OS.COM.OleVariantArray'
	instanceVariableNames: 'objects'
	classVariableNames: ''
	imports: #(#{OS.COM.OleVariant})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.OleVariantArray guid: (Core.GUID fromString: '{98618723-d088-45e1-8420-9d86a9ae44de}')!

OS.COM.OleVariantArray isNonInstantiable: true!

OS.COM.OleVariantArray comment: '`OleVariantArray` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of `OleVariant`s.

## Instance Variables:
  `objects`		`<Array> of <Object>`. Holds references to the original objects (before conversion to variants) that are stored into the array to synchronise lifetime. Necessary for objects that convert to `VT_BYREF` variants, such as `Structure`s.


'!

!OS.COM.OleVariantArray methodsFor!

basicLength: anInteger
	super basicLength: anInteger.
	objects ifNil: [objects := Array new: anInteger] ifNotNil: [objects resize: anInteger].
	^self!

basicUncheckedAt: anInteger
	^self elementClass fromAddress: (bytes yourAddress + ((anInteger - 1) * _VARIANT_Size)) owner: self!

copyBytes: aByteObject
	self class
		copyBytes: aByteObject
		from: 1
		to: self byteSize
		into: bytes!

elementSize
	^_VARIANT_Size!

initialize
	self beFinalizable!

initializeVariant: anOleVariant
	"Private - Initialize the variant argument to be a vector type holding a copy of the receiver's values. This will be either a (VT_ARRAY|VT_VARIANT), or a (VT_VECTOR|VT_VARIANT)."
	
	anOleVariant variantVector: self!

isSelfEvaluating
	^false!

needsFree
	"Private - Answer whether the receiver requires freeing of any external resources. Owned arrays of variant will need to be VariantClear'd."

	^owner isNil and: [self isNull not]!

onStartup
	"Private - The system is starting. Modify the state of the receiver to account for the fact than any external memory allocated for the receiver during the previous session is no longer accessible."

	self beUnfinalizable.
	"Even if the array itself is allocated in Dolphin memory, the variants within it may reference external resources (e.g. BSTRs), so we just discard."
	bytes := nil!

postCopy
	super postCopy.
	objects := objects copy.
	^self!

uncheckedAt: anInteger
	"Private - Answer a Smalltalk <Object> that is the value of the variant at the specified <integer> index in the receiver. No bounds checks are performed on the subscript."

	^(self basicUncheckedAt: anInteger) value!

uncheckedAt: anInteger put: anObject
	"Private - Set the value of the variant at the specified <integer> index in the receiver to be the variant representation of the argument, anObject. No bounds checks are performed on the subscript."

	"We keep a reference to the object in case it is something that gets stored by reference into the variant, e.g. a Structure."
	objects at: anInteger put: anObject.
	(self basicUncheckedAt: anInteger) value: anObject.
	^anObject! !

!OS.COM.OleVariantArray categoriesForMethods!
basicLength:!public! !
basicUncheckedAt:!accessing!private! !
copyBytes:!copying!private! !
elementSize!public! !
initialize!initializing!private! !
initializeVariant:!converting!private! !
isSelfEvaluating!public!testing! !
needsFree!private!realizing/unrealizing! !
onStartup!event handling!private! !
postCopy!copying!public! !
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!OS.COM.OleVariantArray class methodsFor!

copyBytes: srcByteObject from: startInteger to: stopInteger into: destByteObject
	self subclassResponsibility!

requiresFinalization
	"Answer whether instances of the receiver that own their own resources will require free'ing either explicitly or by finalization. 
	`VariantClear` needs to be called for internally owned instances, e.g. value instances."

	^true!

with: anObject
	"Answer a new instance of the receiver containing the single <Object> argument."

	| array |
	array := self new: 1.
	anObject initializeVariant: (array uncheckedAt: 1).
	^array!

withAll: newElements bufferClass: bufferClass
	"Answer a new instance of the receiver containing all of the 
	elements of the <collection> newElements.
	An error will be raised if any of the elements of newElements
	cannot be stored in instances of the receiver."

	| answer |
	answer := self new: newElements size bufferClass: bufferClass.
	newElements inject: 1
		into: 
			[:i :elem |
			elem initializeVariant: (answer basicUncheckedAt: i).
			i + 1].
	^answer! !

!OS.COM.OleVariantArray class categoriesForMethods!
copyBytes:from:to:into:!copying!private! !
requiresFinalization!public!realizing/unrealizing!testing! !
with:!instance creation!public! !
withAll:bufferClass:!instance creation!public! !
!


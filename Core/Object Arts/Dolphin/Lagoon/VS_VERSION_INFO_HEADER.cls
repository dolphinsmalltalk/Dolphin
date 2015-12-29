"Filed out from Dolphin Smalltalk X6"!

Win32Structure subclass: #VS_VERSION_INFO_HEADER
	instanceVariableNames: 'key valueOffset'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
VS_VERSION_INFO_HEADER guid: (GUID fromString: '{EFC64C05-AA07-41B8-BA73-60F7974C6E3F}')!
VS_VERSION_INFO_HEADER comment: 'VS_VERSION_INFO_HEADER is an ExternalStructure class to represent the headers for version resource blocks. It is not a real Win32 structure.

See the VersionResource class.'!
!VS_VERSION_INFO_HEADER categoriesForClass!External-Data-Structured-Win32! !
!VS_VERSION_INFO_HEADER methodsFor!

childrenOffset
	"Answer the offset into the resource block pointed at by the receiver at which the 
	children start (if any - not all version blocks have children)."

	^(self valueOffset + self wValueLength) roundUpTo: 4!

key
	"Answer the <readableString> key of this version info block."

	key isNil ifTrue: [
		key := self szKey asString].
	^key!

printOn: target
	target
		basicPrint: self;
		nextPut: $(;
		nextPutAll: self key;
		nextPutAll: ', wLength = '; print: self wLength;
		nextPutAll: ', wValueLength='; print: self wValueLength;
		nextPutAll: ', wType='; print: self wType;
		nextPut: $)
	!

szKey
	^UnicodeString fromAddress: self yourAddress asInteger + 6!

valueBytes
	"Answer a <ByteArray> containing the value of this version info block."

	^ByteArray 
		fromAddress: self yourAddress asInteger + self valueOffset 
		length: self wValueLength!

valueDWORDs
	"Answer a <DWORDArray> containing the values of the receiver (assumes this is a Var block)."

	^DWORDArray fromAddress: self yourAddress asInteger + self valueOffset length: self wValueLength//4!

valueOffset
	"Answer the offset into the resource block pointed at by the receiver at which the value
	starts."

	valueOffset isNil ifTrue: [
		valueOffset := (self class byteSize + ((self key size+1)*2)) roundUpTo: 4].
	^valueOffset!

valueString
	"Answer the <UnicodeString> value of the receiver (assumes this is a String block).
	Note that the string will be zero terminated if non-empty."

	^self wValueLength = 0
		ifTrue: [UnicodeString new]
		ifFalse: [UnicodeString fromAddress: self yourAddress asInteger + self valueOffset]!

wLength
	"Answer the receiver's wLength field as a Smalltalk object."

	^(bytes wordAtOffset: 0)!

wType
	"Answer the receiver's wType field as a Smalltalk object."

	^(bytes wordAtOffset: 4)!

wValueLength
	"Answer the receiver's wValueLength field as a Smalltalk object."

	^(bytes wordAtOffset: 2)! !
!VS_VERSION_INFO_HEADER categoriesFor: #childrenOffset!accessing!public! !
!VS_VERSION_INFO_HEADER categoriesFor: #key!accessing!public! !
!VS_VERSION_INFO_HEADER categoriesFor: #printOn:!printing!public! !
!VS_VERSION_INFO_HEADER categoriesFor: #szKey!accessing!private! !
!VS_VERSION_INFO_HEADER categoriesFor: #valueBytes!accessing!public! !
!VS_VERSION_INFO_HEADER categoriesFor: #valueDWORDs!accessing!public! !
!VS_VERSION_INFO_HEADER categoriesFor: #valueOffset!accessing!public! !
!VS_VERSION_INFO_HEADER categoriesFor: #valueString!accessing!public! !
!VS_VERSION_INFO_HEADER categoriesFor: #wLength!**compiled accessors**!public! !
!VS_VERSION_INFO_HEADER categoriesFor: #wType!**compiled accessors**!public! !
!VS_VERSION_INFO_HEADER categoriesFor: #wValueLength!**compiled accessors**!public! !

!VS_VERSION_INFO_HEADER class methodsFor!

defineFields
	"Private - Define the layout of the Win32 VS_VERSION_INFO_HEADER structure.
	
		self compileDefinition
	"
 
	self
		defineField: #wLength type: WORDField readOnly;
		defineField: #wValueLength type: WORDField readOnly;
		defineField: #wType type: WORDField readOnly
		"All other fields are of variable length"! !
!VS_VERSION_INFO_HEADER class categoriesFor: #defineFields!initializing!private! !


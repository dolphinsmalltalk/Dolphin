"Filed out from Dolphin Smalltalk 7"!

Kernel.AttributeDescriptor subclass: #'External.Field'
	instanceVariableNames: 'offset structClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Field guid: (Core.GUID fromString: '{87b4c4d8-026e-11d3-9fd7-00a0cc3e4a32}')!
External.Field isNonInstantiable: true!
External.Field comment: 'ExternalField is the abstract class of metadata objects that describe the fields of <ExternalStructure>s, including such attributes as the byte offset of the field, the type of the field, and potentially the size of the field.

Instance Variables:
	offset		<SmallInteger>. Fixed offset, in bytes, of the field described in any instance of structClass.
	structClass	<ExternalStructure class> of which the instance is describing a field.

'!
!External.Field categoriesForClass!External-Data-Types! !
!External.Field methodsFor!

alignment
	"Answer the alignment requirements for the receiver.
	This is the default alignment required for a field of the receiver's type
	when embedded in an array or structure, generally speaking this is the
	same as the byte size."

	^self byteSize!

beFiller
	"Set the receiver's flag to specify that it is a filler field.
	The field will be largely ignored being neither readable nor writeable.
	Answer the receiver."

	self beInaccessible!

byteSize
	"Private - Answer the byteSize of the field the receiver represents."

	^self subclassResponsibility!

emitStaticExpression: operation on: aWriteStream 
	aWriteStream nextPutAll: '##('.
	operation value: aWriteStream.
	aWriteStream nextPut: $)!

isFiller
	"Private - Answer whether the receiver is a filler field."

	^self isInaccessible
!

isFixedSize
	"Private - Answer whether the field described by the receiver is of a fixed size, i.e.
	known statically as opposed to varying dynamically at runtime."

	^true!

offset
	"Private - Answer the offset of the receiver's field in its structure template."

	^offset!

offset: anInteger
	"Private - Set the offset of the receiver's field in a structure template to be anInteger."

	offset := anInteger.
	!

printOn: aStream
	"Append a representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(; print: self offset; nextPut: $)!

structClass
	"Private - Answer the <ExternalStructure> class of which the receiver describes a field."

	^structClass!

structClass: anExternalStructureClass
	structClass := anExternalStructureClass!

valueType
	"Private - Answer the class of Smalltalk object to be used to represent the values stored in the field described by the receiver."

	^Object! !
!External.Field categoriesFor: #alignment!constants!public! !
!External.Field categoriesFor: #beFiller!modes!public! !
!External.Field categoriesFor: #byteSize!accessing!private! !
!External.Field categoriesFor: #emitStaticExpression:on:!automatic generation!private! !
!External.Field categoriesFor: #isFiller!private!testing! !
!External.Field categoriesFor: #isFixedSize!private!testing! !
!External.Field categoriesFor: #offset!accessing!private! !
!External.Field categoriesFor: #offset:!accessing!private! !
!External.Field categoriesFor: #printOn:!printing!public! !
!External.Field categoriesFor: #structClass!accessing!private! !
!External.Field categoriesFor: #structClass:!accessing!private! !
!External.Field categoriesFor: #valueType!automatic generation!constants!private! !

!External.Field class methodsFor!

filler
	"Answer an instance of the receiver which describes a field which will not be used
	(it cannot be read or written)."

	^self new beFiller! !
!External.Field class categoriesFor: #filler!instance creation!public! !


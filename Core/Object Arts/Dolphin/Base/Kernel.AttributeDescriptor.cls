"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Kernel.AttributeDescriptor'
	instanceVariableNames: 'flags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'AccessorMask' -> 16r4.
		'MutableMask' -> 16r20.
		'MutatorMask' -> 16r8.
		'NonBrowsableMask' -> 16r80.
		'NullableMask' -> 16r40.
		'OverrideMask' -> 16r10.
		'ReadableMask' -> 16r1.
		'WriteableMask' -> 16r2
	}!
Kernel.AttributeDescriptor guid: (Core.GUID fromString: '{87b4c455-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.AttributeDescriptor isNonInstantiable: true!
Kernel.AttributeDescriptor comment: 'AttributeDescriptor is an abstract class of meta-objects that be used to describe the shape of other objects. It has a subclass, Aspect, instances of which describe how to access object''s published ''aspects'' (e.g. instance variables) through getter and setter methods, and a subclass, ExternalField, instances of which describe the fields of C style structures. Note that these objects are all descriptors, and need to be combined with a subject object in order to become "closed".'!
!Kernel.AttributeDescriptor categoriesForClass!Attribute-Definition! !
!Kernel.AttributeDescriptor methodsFor!

beCompiled
	"Set the receiver's flags to specify it as an compiled attribute
	(i.e. one with compiled accessors to retrieve/set its value).
	Answer the receiver."

	flags := flags maskSet: ##(AccessorMask | MutatorMask)!

beImmutable
	flags := flags maskClear: MutableMask!

beInaccessible
	"Set the receiver's flag to specify that it is inaccessible.
	ie. being neither readable nor writeable.
	Answer the receiver."

	flags := flags maskClear: ##(WriteableMask | ReadableMask)!

beMutable
	"Set this aspect to be mutable, i.e. it can be modified in-place."

	flags := flags maskSet: MutableMask!

beNonBrowsable
	"Set the receiver's flags to specify it as an non-browseable attribute. Non-browseable
	attributes are not normally shown in printed output and in inspectors, etc."

	flags := flags maskSet: NonBrowsableMask!

beOverride
	"Set the receiver's flags to specify it as an override attribute
	(i.e. one for which compiled accessors will be generated, even if defined
	in the superclass). The default behaviour for an attribute is not to compile
	accessors where they are already defined in the superclass."

	flags := flags maskSet: OverrideMask!

beReadOnly
	"Set the receiver's flags to specify it as a 'read only' attribute.
	Answer the receiver."

	flags := (flags maskClear: WriteableMask) maskSet: ReadableMask!

beUncompiled
	"Set the receiver's flags to specify it as an uncompiled attribute
	(i.e. one without any compiled accessors which will use the #doesNotUnderstand:
	mechanism to retrieve/set its value when sent accessor messages).
	Answer the receiver."

	flags := flags maskClear: ##(AccessorMask | MutatorMask)!

beWriteOnly
	"Set the receiver's flags to specify it as a 'write-only' attribute.
	Answer the receiver."

	flags := (flags maskClear: ReadableMask) maskSet: WriteableMask!

canGenerateAccessor
	"Private - Answer whether it is possible to generate a read accessor method
	for the receiver."

	^self canGenerateAccessors
		and: [self isReadable
			and: [flags anyMask: AccessorMask]]
!

canGenerateAccessors
	"Private - Answer whether accessors can be compiled for the receiver."

	^true!

canGenerateMutator
	"Private - Answer whether it is possible to generate a write accessor method
	for the receiver."

	^self canGenerateAccessors 
		and: [self isWriteable
			and: [flags anyMask: MutatorMask]]!

defaultFlags
	^##(WriteableMask | ReadableMask | AccessorMask | MutatorMask | NullableMask)!

initialize
	"Private - Initialize the receiver.
	By default attributes support read/write and compiled accessors."

	flags := self defaultFlags!

isBrowsable
	"Answer whether the receiver describes an attribute that should appear in property browsers, printStrings, etc."

	^(flags bitAnd: ##(ReadableMask | NonBrowsableMask)) == ReadableMask!

isInaccessible
	"Answer whether the receiver is an inaccessible attribute."

	^(flags anyMask: WriteableMask | ReadableMask) not!

isMutable
	"Answer true if this aspect is mutable, i.e. it can be modified in-place.
	If not then a copy of the aspect will be made when its value is taken"

	^flags allMask: MutableMask
	!

isNonBrowsable
	"Answer whether the receiver describes a non-browsable attribute. Non-browsable attributes
	are not normally shown in printed output and in inspectors, etc."

	^flags allMask: NonBrowsableMask!

isNullable
	"Answer true if this aspect is nullable, i.e. it can be set to nil.
	In order to be nullable, an aspect must be writeable."

	^flags allMask: ##(WriteableMask | NullableMask)!

isNullable: aBoolean 
	flags := flags mask: NullableMask set: aBoolean!

isOverride
	"Answer whether the receiver is an attribute which overrides
	one in the superclass (i.e. accessors will be generated for it regardless
	of whether they already exist in the superclass)."

	^flags anyMask: OverrideMask!

isReadable
	"Answer whether the receiver is a readable attribute."

	^flags anyMask: ReadableMask!

isWriteable
	"Answer whether the receiver is a writeable attribute."

	^flags anyMask: WriteableMask!

readFrom: anObject
	"Private - Answer the attribute of anObject represented by the receiver."

	^self subclassResponsibility!

writeInto: subjectObject value: valueObject
	"Private - Set the attribute of subjectObject described by the receiver 
	to valueObject."

	^self subclassResponsibility! !
!Kernel.AttributeDescriptor categoriesFor: #beCompiled!modes!public! !
!Kernel.AttributeDescriptor categoriesFor: #beImmutable!modes!public! !
!Kernel.AttributeDescriptor categoriesFor: #beInaccessible!modes!public! !
!Kernel.AttributeDescriptor categoriesFor: #beMutable!modes!public! !
!Kernel.AttributeDescriptor categoriesFor: #beNonBrowsable!modes!public! !
!Kernel.AttributeDescriptor categoriesFor: #beOverride!modes!public! !
!Kernel.AttributeDescriptor categoriesFor: #beReadOnly!modes!public! !
!Kernel.AttributeDescriptor categoriesFor: #beUncompiled!modes!public! !
!Kernel.AttributeDescriptor categoriesFor: #beWriteOnly!modes!public! !
!Kernel.AttributeDescriptor categoriesFor: #canGenerateAccessor!private!testing! !
!Kernel.AttributeDescriptor categoriesFor: #canGenerateAccessors!private!testing! !
!Kernel.AttributeDescriptor categoriesFor: #canGenerateMutator!private!testing! !
!Kernel.AttributeDescriptor categoriesFor: #defaultFlags!initializing!private! !
!Kernel.AttributeDescriptor categoriesFor: #initialize!initializing!private! !
!Kernel.AttributeDescriptor categoriesFor: #isBrowsable!public!testing! !
!Kernel.AttributeDescriptor categoriesFor: #isInaccessible!public!testing! !
!Kernel.AttributeDescriptor categoriesFor: #isMutable!public!testing! !
!Kernel.AttributeDescriptor categoriesFor: #isNonBrowsable!public!testing! !
!Kernel.AttributeDescriptor categoriesFor: #isNullable!public!testing! !
!Kernel.AttributeDescriptor categoriesFor: #isNullable:!modes!public! !
!Kernel.AttributeDescriptor categoriesFor: #isOverride!public!testing! !
!Kernel.AttributeDescriptor categoriesFor: #isReadable!public!testing! !
!Kernel.AttributeDescriptor categoriesFor: #isWriteable!public!testing! !
!Kernel.AttributeDescriptor categoriesFor: #readFrom:!indirect accessing!private! !
!Kernel.AttributeDescriptor categoriesFor: #writeInto:value:!indirect accessing!private! !

!Kernel.AttributeDescriptor class methodsFor!

inaccessible
	"Private - Answer an instance of the receiver which describes an attribute
	which is neither writable nor readable."

	^self new beInaccessible
!

new
	"Answer an instance of the receiver which describes an attribute
	which can be both read from and written to."

	^super new initialize!

readOnly
	"Answer an instance of the receiver which describes an attribute
	which cannot be set."

	^self new beReadOnly!

uncompiled
	"Answer an instance of the receiver which describes a field which will not be compiled."

	^self new beUncompiled!

writeOnly
	"Answer an instance of the receiver which describes an attribute
	which cannot be read, only written."

	^self new beWriteOnly! !
!Kernel.AttributeDescriptor class categoriesFor: #inaccessible!instance creation!private! !
!Kernel.AttributeDescriptor class categoriesFor: #new!instance creation!public! !
!Kernel.AttributeDescriptor class categoriesFor: #readOnly!instance creation!public! !
!Kernel.AttributeDescriptor class categoriesFor: #uncompiled!instance creation!public! !
!Kernel.AttributeDescriptor class categoriesFor: #writeOnly!instance creation!public! !


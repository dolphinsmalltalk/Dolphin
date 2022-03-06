"Filed out from Dolphin Smalltalk"!

Core.Association subclass: #'Kernel.VariableBinding'
	instanceVariableNames: 'environment flags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'ClassMask' -> 16r2.
		'DeprecatedMask' -> 16r100.
		'PrivateMask' -> 16r1
	}!
Kernel.VariableBinding guid: (Core.GUID fromString: '{1e72742f-5466-4331-bb39-2ff12ac9743f}')!
Kernel.VariableBinding comment: ''!
!Kernel.VariableBinding categoriesForClass!Collections-Support! !
!Kernel.VariableBinding methodsFor!

= anObject
	"Answer whether the receiver is equal to the argument."

	^self == anObject or: 
			[self species == anObject species
				and: [environment == anObject environment and: [key = anObject key and: [value = anObject value]]]]!

absoluteName
	"Answer the <String> absolute qualified name of this binding, inclusive of 'Root'. This is guaranteed to be unambiguous."

	^environment absoluteNameFor: key!

asQualifiedReference
	"Answer a <BindingReference> that refs to this binding."

	^BindingReference pathString: key home: environment!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: key!

displayString
	^key!

environment
	^environment!

environment: aNamespace 
	<mutable>
	environment := aNamespace!

flags
	^flags!

fullName
	"Answer the <String> fully qualified name of this variable, which is a dot-separated path from (but not including) Smalltalk."

	^environment fullNameFor: key!

fullyQualifiedReference
	"Answer a <BindingReference> that represents a fully qualified reference to the receiver relative to Smalltalk. If the Class is not in the hierarchy below Smalltalk (i.e. it is in Root, or another namespace hierarchy under Root), then it will be an absolute binding reference.
	The resulting binding reference can be used to resolve the receiver, if installed, or to redeclare it, when not."

	^BindingReference path: (environment fullPath copyWith: key)!

isClassBinding
	^value class isMeta and: [key == value unqualifiedName and: [environment == value basicEnvironment]]!

isClassVariable
	"Answer whether the receiver is a class variable binding (as opposed to a namespace variable binding)."

	^flags allMask: ClassMask!

isClassVariable: aBoolean
	"Set whether the receiver is a class variable binding (as opposed to a namespace variable binding)."

	self setFlags: (flags mask: ClassMask set: aBoolean)!

isConstant
	"Answer whether the receiver is a constant binding, the value of which cannot be assigned."

	^self isImmutable!

isConstant: aBoolean
	"Set whether the receiver should be a constant binding, the value of which cannot be assigned."

	self isImmutable: aBoolean!

isDeprecated
	"Answer whether the receiver should be considered deprecated."

	^flags allMask: DeprecatedMask!

isDeprecated: aBoolean
	"Set whether the receiver should be considered deprecated."

	flags := flags mask: DeprecatedMask set: aBoolean!

isPrivate
	"Answer whether the receiver is a private binding that should only be visible in its home namespace."

	^flags allMask: PrivateMask!

isPrivate: aBoolean
	self setFlags: (flags mask: PrivateMask set: aBoolean)!

key: aKey value: aValue
	"Private - Set the instance variables of the receiver to aKey->aValue"

	super key: aKey value: aValue.
	flags := 0.
	^self!

owningPackage
	"Answer the receiver's owning <Package>."

	^self class packageManager packageOfVariableNamed: self fullyQualifiedReference!

owningPackage: aPackageOrNil
	"Set the receiver's owning <Package> to be the argument. Any current package association is replaced."

	self class packageManager addVariableNamed: self fullyQualifiedReference to: aPackageOrNil!

refersTo: anObject asLiteralOf: aCompiledMethod
	^(self = anObject or: [value == anObject and: [self isClassBinding]])
		or: [environment includesEnvironment: anObject]!

setFlags: anInteger
	<mutable>
	flags := anInteger!

targetVariable
	^self!

unqualifiedName
	^key! !
!Kernel.VariableBinding categoriesForMethods!
=!comparing!public! !
absoluteName!accessing!public! !
asQualifiedReference!converting!public! !
displayOn:!printing!public! !
displayString!displaying!public! !
environment!accessing!public! !
environment:!accessing!public! !
flags!public! !
fullName!accessing!public! !
fullyQualifiedReference!converting!public! !
isClassBinding!public!testing! !
isClassVariable!public! !
isClassVariable:!public! !
isConstant!public! !
isConstant:!public! !
isDeprecated!public! !
isDeprecated:!public! !
isPrivate!public! !
isPrivate:!public! !
key:value:!initializing!private! !
owningPackage!accessing!development!public! !
owningPackage:!accessing!development!public! !
refersTo:asLiteralOf:!private!testing! !
setFlags:!accessing!private! !
targetVariable!accessing!public! !
unqualifiedName!accessing!public! !
!

!Kernel.VariableBinding class methodsFor!

stbConvertFrom: anSTBClassFormat
	"Convert from previous version resource. 
	Version Changes:
		1) Adds 'environment'
		2) Adds 'flags'
	"

	^
	[:data |
	| binding value |
	binding := self basicNew.
	1 to: data size do: [:i | binding instVarAt: i put: (data at: i)].
	binding setFlags: 0.
	binding environment
		ifNil: 
			["In most cases a VariableBinding will be in STB/STL because it is referenced from the literal frame of a method. We have to try and deduce the environment:
				- If the variable has the same name as a variable in Smalltalk that references the exact same value, we patch the environment to Smalltalk; or
				- If the variable refers to a class and has the same unqualified name as the class, we patch it to the environment of that class; otherwise
				- we leave the envionment as we are unable to determine the correct class"
			value := binding value.
			(Smalltalk at: binding key ifAbsent: Collection.AbsentCookie) == value
				ifTrue: [binding environment: Smalltalk]
				ifFalse: 
					[(value class isMeta and: [binding key == value name])
						ifTrue: [binding environment: value environment]
						ifFalse: 
							["Mark it as a class variable which will exclude it from treatment as a class binding"
							binding isClassVariable: true]]].
	binding]!

stbVersion
	^2! !
!Kernel.VariableBinding class categoriesForMethods!
stbConvertFrom:!binary filing!public! !
stbVersion!binary filing!public! !
!


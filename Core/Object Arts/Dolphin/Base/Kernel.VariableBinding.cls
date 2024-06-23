"Filed out from Dolphin Smalltalk"!

Core.Association
	subclass: #'Kernel.VariableBinding'
	instanceVariableNames: 'environment flags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'ClassMask' -> 16r2. 'DeprecatedMask' -> 16r100. 'PrivateMask' -> 16r1 }!

Kernel.VariableBinding guid: (Core.GUID fromString: '{1e72742f-5466-4331-bb39-2ff12ac9743f}')!

Kernel.VariableBinding comment: '`VariableBinding` is the special class of `Assocation`s representing the static variables of classes and namespaces. Static variables include both class and namespace (formerly global) variables. The can be referred to in code directly by name using either a fully-qualified name, or, visibility depending, a partially-qualified or unqualified name.

`VariableBinding`s are aware of their ''environment'', which is the `Class` in which they reside. They can be considered as owned by that environment, in which case they are referred to as ''class variables''. They can also be independently owned by a package, rather than the class in which they reside, in which case they are referred to as ''namespace variables''. The terminology ''shared variables'' is also used for namespace variables, but this may be confusing since class variables are also shareable (i.e. externally referenceable using a qualified name) if they are not marked as ''private''. As `Namespace`s in Dolphin 8 are actually classes, namespace variables are held as bindings in the same class pool as the class'' own variables. Any class is fundamentally a namespace, so any class may hold namespace variables. Conversely `Namespace`s (as classes) can have class variables and constants that they own as part of their definition.

Static variables can be marked as constant, in which case they are immutable. Immutable static variables with values that have immediate bytecode representations are inlined by the compiler, although the variable will still be added to the referencing methods literal frame. Attempting to assign to a static constant static will cause a compilation error. Attempting to modify the value of a constant binding, looked up by some other means than direct reference to its name in code, will cause a runtime error as the VM enforces the immutability of objects where set.

Static variables can be used to create an alias for a class, either under a different name in the classes own namespace, or in an entirely different namespace. This is particularly useful for creating ''old names'' aliases to namespaced classes so that they can still be referenced from legacy code that is not namespace aware. Legacy code expects all variables to be bindable by unqualified name, either as globals defined in Smalltalk, or local class variables, or from ''shared pools'' (imported dictionaries of static variables). The commonly used classes in the Smalltalk class library are now in namespaces such as Core and Kernel, and these namespaces are imported into the `Smalltalk` namespace so that the classes are still visible to legacy code (where not renamed). Some other classes that have been renamed, or which live in other namespaces, have aliases defined by the base system. These are typically owned by an ''(Old Names)'' package that sits alongside the package that owns the class. A cache of these old names is maintained by the Smalltalk namespace in order to enable round-tripping of legacy code by filing out using old names so that there is some chance of loading code modified in Dolphin 8 in Dolphin 7.1:
```
Smalltalk oldNames
```

Static variables can also be marked as deprecated. This is used to mark old-name aliases that should be updated. An example is `Smalltalk.UnicodeString`, a deprecated alias for `Core.Utf16String`. 
```
Smalltalk bindings select: [:each | each isDeprecated]
``

The variable bindings for classes are somewhat special. These are constants, and should not be added, removed or modified directly, rather this is achieved by defining, removing, or renaming classes. The class bindings can be identified easily:
```
Smalltalk bindings select: [:each | each isClassBinding]
```
'!

!Kernel.VariableBinding categoriesForClass!Kernel-Support! !

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

	aPuttableStream nextPutAll: self shortName!

displayString
	^self shortName!

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
	"Answer whether the receiver is a class variable binding (as opposed to a namespace variable binding). Class variables are considered to be owned by a class, and form part of its definition. Namespace variables (aka 'shared' variables, although class variables can also be referenced directly from other classes, i.e shared, so this terminology is a little confusing) are not considered to be owned by the namespace class, and are independently packagable."

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

key: aString value: anObject environment: aNamespace flags: anInteger
	key := aString.
	value := anObject.
	environment := aNamespace.
	flags := anInteger!

owningPackage
	"Answer the receiver's owning <Package>."

	^self class packageManager packageOfVariableNamed: self fullyQualifiedReference!

owningPackage: aPackageOrNil
	"Set the receiver's owning <Package> to be the argument. Any current package association is replaced."

	self class packageManager addVariableNamed: self fullyQualifiedReference to: aPackageOrNil!

refersToLiteral: anObject
	^(self = anObject or: [value == anObject and: [self isClassBinding]])
		or: [environment includesEnvironment: anObject]!

setFlags: anInteger
	<mutable>
	flags := anInteger!

shortName
	"Answer the shortest <String> name of this variable that is bindable from Smalltalk. i.e. for variables defined directly in Smalltalk, or in any of its imports, this will be an unqualified name. Otherwise it is the fully qualified name relative to Smalltalk."

	^environment ifNotNil: [environment shortNameFor: key] ifNil: [key]!

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
key:value:environment:flags:!initializing!private! !
owningPackage!accessing!development!public! !
owningPackage:!accessing!development!public! !
refersToLiteral:!private!testing! !
setFlags:!accessing!private! !
shortName!accessing!public! !
targetVariable!accessing!public! !
unqualifiedName!accessing!public! !
!

!Kernel.VariableBinding class methodsFor!

key: aString value: anObject environment: aNamespace flags: anInteger
	<primitive: 157>
	^self new
		key: aString
		value: anObject
		environment: aNamespace
		flags: anInteger! !

!Kernel.VariableBinding class categoriesForMethods!
key:value:environment:flags:!instance creation!private! !
!


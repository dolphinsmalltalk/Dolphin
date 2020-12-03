"Filed out from Dolphin Smalltalk 7"!

Kernel.PoolDictionary variableSubclass: #PoolConstantsDictionary
	instanceVariableNames: 'name'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
PoolConstantsDictionary guid: (Core.GUID fromString: '{87b4c52e-026e-11d3-9fd7-00a0cc3e4a32}')!
PoolConstantsDictionary comment: 'Prior to Dolphin 7.2, `PoolConstantDictionary` instances were used as shared constants pools, the canonical example being `Win32Constants`.  From Dolphin 7.2 constants pools are namespaces specialised to hold immutable bindings, and are created as subclasses of `SharedPool`. 

`PoolConstantDictionary` definitions stored in older packages will be automatically converted to `SharedPool` subclasses at package load time, so this class is only required for loading such packages. It should have no instances at other times.'!
!PoolConstantsDictionary categoriesForClass!Deprecated! !
!PoolConstantsDictionary methodsFor!

add: anAssociation
	"Add the key/value pair provided in the <Association> argument to the receiver.
	The actual <Association> is not added as there are many constraints so it is safe to add a newly formed constant VariableBinding."

	self at: anAssociation key put: anAssociation value.
	^anAssociation!

classesReferencing
	^Smalltalk allClasses select: [:c | c allSharedPools includes: self]!

isValidKey: aString
	^aString notEmpty and: 
			[| initial |
			initial := aString first.
			(initial == $_ or: [initial isLetter])
				and: [aString allSatisfy: [:each | each == $_ or: [each isAlphaNumeric]]]]!

keyString: anObject
	| answer |
	answer := anObject asString.
	(self isValidKey: answer) ifFalse: [^self error: ('Invalid key: <1p>' expandMacrosWith: answer)].
	^answer!

name
	"Answer the receiver's name."

	^name ifNil: [self environment keyAtValue: self ifAbsent: [self anonymousName]]!

name: aSymbol 
	name := aSymbol asSymbol!

newAssociation: keyObject value: valueObject 
	^(super newAssociation: keyObject value: valueObject)
		isImmutable: true;
		yourself!

preResize: newMe 
	"Private - This message is sent by the receiver when resizing, before the
	receiver's elements are added to newMe. We must assign across the
	search policy."

	name isNil ifFalse: [newMe name: name]! !
!PoolConstantsDictionary categoriesFor: #add:!adding!public! !
!PoolConstantsDictionary categoriesFor: #classesReferencing!development!private! !
!PoolConstantsDictionary categoriesFor: #isValidKey:!adding!development!private! !
!PoolConstantsDictionary categoriesFor: #keyString:!adding!development!private! !
!PoolConstantsDictionary categoriesFor: #name!accessing!public! !
!PoolConstantsDictionary categoriesFor: #name:!accessing!private! !
!PoolConstantsDictionary categoriesFor: #newAssociation:value:!helpers!private! !
!PoolConstantsDictionary categoriesFor: #preResize:!adding!private! !

!PoolConstantsDictionary class methodsFor!

named: aSymbol 
	^(self new)
		name: aSymbol;
		yourself! !
!PoolConstantsDictionary class categoriesFor: #named:!instance creation!public! !


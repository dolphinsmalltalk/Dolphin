"Filed out from Dolphin Smalltalk"!

STBProxy subclass: #STBClassProxy
	instanceVariableNames: 'packageName locatorKey'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

STBClassProxy guid: (GUID fromString: '{87b4c6ea-026e-11d3-9fd7-00a0cc3e4a32}')!

STBClassProxy comment: ''!

!STBClassProxy categoriesForClass!System-Binary storage! !

!STBClassProxy methodsFor!

locatorKey: aString
	"Private - Set the receiver's locatorKey inst var to aString."

	locatorKey := aString!

packageName: aString
	"Private - Set the receiver's package name inst var to aString."

	packageName := aString!

resolveWithClassLocator: aClassLocator 
	"Private - If the class represented by the <ClassLocator> argument is a resident class or a
	loaded imported class then answer the class. Otherwise answer a <ClassStub> representing the
	class which will be resolved when it is first used."

	^aClassLocator findAvailableClass ifNil: [self withClassLocator: aClassLocator]!

stbFixup: inFiler at: anInteger
	"Resolve the receiver to either the behaviour it represents or an appropriate stub class."

	| behaviourOrStub classLocator |

	"Create a class locator that can be used to find this class"
	classLocator := inFiler classLocator copyWithCodeBase.
	classLocator key: locatorKey; packageName: packageName.

	behaviourOrStub := self resolveWithClassLocator: classLocator.
	inFiler fixup: anInteger to: behaviourOrStub.

	^behaviourOrStub.!

withClassLocator: aClassLocator
	^(Smalltalk lookup: #ClassStub) ifNotNil: [:classStub | classStub withClassLocator: aClassLocator]! !

!STBClassProxy categoriesForMethods!
locatorKey:!accessing!private! !
packageName:!accessing!private! !
resolveWithClassLocator:!converting!private! !
stbFixup:at:!converting!public! !
withClassLocator:!converting!private! !
!

!STBClassProxy class methodsFor!

forClass: aClass
	"Answer a new instance with its locator key representing aClass."

	| answer |
	answer := self basicNew.
	answer locatorKey: aClass name asString.
	aClass owningPackage ifNotNil: [:package | answer packageName: package name].
	^answer!

stbConvertFrom: anSTBClassFormat 
	"Convert from earlier version models.
	1: Added 'packageName' instance variable."

	^
	[:data | 
	| newInst |
	newInst := self basicNew.
	data keysAndValuesDo: [:i :v | newInst instVarAt: i + 1 put: v].
	newInst]!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^1! !

!STBClassProxy class categoriesForMethods!
forClass:!instance creation!public! !
stbConvertFrom:!binary filing!public! !
stbVersion!binary filing!public! !
!


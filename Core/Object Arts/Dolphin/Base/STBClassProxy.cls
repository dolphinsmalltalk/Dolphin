"Filed out from Dolphin Smalltalk X6"!

STBProxy subclass: #STBClassProxy
	instanceVariableNames: 'packageName locatorKey'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBClassProxy guid: (GUID fromString: '{87B4C6EA-026E-11D3-9FD7-00A0CC3E4A32}')!
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
	^(Smalltalk at: #ClassStub ifAbsent: []) 
		ifNotNil: [:classStub | classStub withClassLocator: aClassLocator]! !
!STBClassProxy categoriesFor: #locatorKey:!accessing!private! !
!STBClassProxy categoriesFor: #packageName:!accessing!private! !
!STBClassProxy categoriesFor: #resolveWithClassLocator:!converting!private! !
!STBClassProxy categoriesFor: #stbFixup:at:!converting!public! !
!STBClassProxy categoriesFor: #withClassLocator:!converting!private! !

!STBClassProxy class methodsFor!

for: aClass 
	#deprecated.
	^self forClass: aClass!

forClass: aClass
	"Answer a new instance with its locator key representing aClass."

	^self basicNew
		locatorKey: aClass name asString;
		packageName: aClass owningPackage name;
		yourself!

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
!STBClassProxy class categoriesFor: #for:!instance creation!public! !
!STBClassProxy class categoriesFor: #forClass:!instance creation!public! !
!STBClassProxy class categoriesFor: #stbConvertFrom:!binary filing!public! !
!STBClassProxy class categoriesFor: #stbVersion!binary filing!public! !


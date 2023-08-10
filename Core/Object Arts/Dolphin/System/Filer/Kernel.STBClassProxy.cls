"Filed out from Dolphin Smalltalk"!

Kernel.STxProxy
	subclass: #'Kernel.STBClassProxy'
	instanceVariableNames: 'packageName locatorKey'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBClassProxy guid: (Core.GUID fromString: '{87b4c6ea-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.STBClassProxy comment: '`STBClassProxy` is an STB proxy class for wrapping reference to class objects in the serialised object stream. The proxy captures the class and package names. Historically the package name was used for loading binary class definitions in Dolphin Web Applets, although this use is obsolete.

The newer literal filer, STL, does not use `STBClassProxy` or `STBMetaclassProxy`, as it uses literal references to the class.'!
!Kernel.STBClassProxy categoriesForClass!System-Binary storage! !
!Kernel.STBClassProxy methodsFor!

locatorKey
	^locatorKey!

locatorKey: aString
	"Private - Set the receiver's locatorKey inst var to aString."

	locatorKey := aString!

packageName
	^packageName!

packageName: aString
	"Private - Set the receiver's package name inst var to aString."

	packageName := aString!

printOn: aStream
	super printOn: aStream.
	aStream nextPut: $(.
	packageName
		ifNotNil: 
			[aStream
				print: packageName;
				nextPutAll: ': '].
	aStream
		display: locatorKey;
		nextPut: $)!

resolveWithClassLocator: aClassLocator
	"Private - If the class represented by the <ClassLocator> argument is a resident class or a
	loaded imported class then answer the class. Otherwise answer a <ClassStub> representing the
	class which will be resolved when it is first used."

	^(aClassLocator findAvailableClass: locatorKey asQualifiedReference)
		ifNil: [self withClassLocator: aClassLocator]!

stbFixup: anSTBInFiler at: anInteger
	"Ask the STBInFiler to resolve the receiver to either the behaviour it represents or an appropriate stub class.
	Note that the first argument is not expected to be an STLInFiler that filer does not use class proxies."

	| behaviourOrStub |
	behaviourOrStub := self resolveWithClassLocator: anSTBInFiler classLocator.
	anSTBInFiler fixup: anInteger to: behaviourOrStub.
	^behaviourOrStub!

withClassLocator: aClassLocator
	^#{ClassStub} ifDefined: 
			[:stub |
			stub withClassLocator: (aClassLocator copyWithCodeBase
						key: locatorKey;
						packageName: packageName;
						yourself)]! !
!Kernel.STBClassProxy categoriesForMethods!
locatorKey!accessing!private! !
locatorKey:!accessing!private! !
packageName!accessing!private! !
packageName:!accessing!private! !
printOn:!printing!public! !
resolveWithClassLocator:!converting!private! !
stbFixup:at:!converting!public! !
withClassLocator:!converting!private! !
!

!Kernel.STBClassProxy class methodsFor!

locatorKey: aString package: aPackage
	^self basicNew
		locatorKey: aString;
		packageName: aPackage name asUtf8String;
		yourself!

stbConvertFrom: anSTBClassFormat
	"Convert from earlier version models.
	1: Added 'packageName' instance variable."

	^
	[:data |
	self basicNew
		locatorKey: (data at: 1);
		yourself]!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^1! !
!Kernel.STBClassProxy class categoriesForMethods!
locatorKey:package:!instance creation!public! !
stbConvertFrom:!binary filing!public! !
stbVersion!binary filing!public! !
!


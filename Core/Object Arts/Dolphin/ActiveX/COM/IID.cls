"Filed out from Dolphin Smalltalk 7"!

GUID variableByteSubclass: #IID
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IID guid: (GUID fromString: '{87b4c644-026e-11d3-9fd7-00a0cc3e4a32}')!
IID comment: 'IID is the class of 128-bit Globally Unique Identifiers (guids) which are specifically used to uniquely identify interfaces in COM.

Many interfaces are not recorded in the registry, but if they have marshalling support (a proxy/stub DLL) then they will be registered under HKCR\Interfaces. Registered IIDs will display with their registered name, otherwise the string representation of their GUID is printed.'!
!IID categoriesForClass!External-Data-Structured-COM! !
!IID methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	| ifName |
	ifName := self interfaceName.
	ifName isNil
		ifTrue: [super displayOn: aPuttableStream]
		ifFalse: [aPuttableStream nextPutAll: ifName]!

interfaceName
	"Answer the name of the interface associated with the receiver, or nil if it is
	not registered. This depends on the registry and is primarily included for
	development/debugging and tools, rather than for use in applications."

	^(((RegKey classesRoot: #read) at: 'Interface') at: self asString ifAbsent: [^nil]) value
! !
!IID categoriesFor: #displayOn:!displaying!public! !
!IID categoriesFor: #interfaceName!accessing!public! !

!IID class methodsFor!

fromString: aString
	"Answer a new instance of the receiver instantiated from the argument, aString, which is in Microsoft™ GUID format."

	| answer |
	answer := self newNull.
	OLELibrary default iidFromString: aString lpiid: answer.
	^answer!

initialize
	"Private - Initialize the receiver's class variables.
		IID initialize
	"

	self extraInstanceSpec: self byteSize! !
!IID class categoriesFor: #fromString:!instance creation!public! !
!IID class categoriesFor: #initialize!development!initializing!private! !


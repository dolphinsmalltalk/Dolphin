"Filed out from Dolphin Smalltalk 7"!

Core.GUID variableByteSubclass: #'OS.COM.IID'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IID guid: (Core.GUID fromString: '{87b4c644-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.COM.IID comment: '`OS.COM.IID` is the class of 128-bit Globally Unique Identifiers (guids) which are specifically used to uniquely identify interfaces in COM.

Many interfaces are not recorded in the registry, but if they have marshalling support (a proxy/stub DLL) then they will be registered under HKCR\Interfaces. Registered IIDs will display with their registered name, otherwise the string representation of their GUID is printed.'!
!OS.COM.IID categoriesForClass!External-Data-Structured-COM! !
!OS.COM.IID methodsFor!

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

	^(((RegKey classesRoot: #read) at: 'Interface') at: self asString ifAbsent: [^nil]) value! !
!OS.COM.IID categoriesFor: #displayOn:!displaying!public! !
!OS.COM.IID categoriesFor: #interfaceName!accessing!public! !

!OS.COM.IID class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		IID initialize
	"

	self extraInstanceSpec: ByteSize! !
!OS.COM.IID class categoriesFor: #initialize!development!initializing!private! !


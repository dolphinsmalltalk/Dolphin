"Filed out from Dolphin Smalltalk"!

Object subclass: #MethodVersion
	instanceVariableNames: 'methodClass selector source sourceDescriptor'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MethodVersion guid: (GUID fromString: '{86708dac-e70b-48ba-ab25-b32573c75cca}')!
MethodVersion comment: ''!
!MethodVersion categoriesForClass!Kernel-Objects! !
!MethodVersion methodsFor!

= aMethodVersionOrCompiledMethod

	^sourceDescriptor = aMethodVersionOrCompiledMethod sourceDescriptor!

displayOn: aStream 
	aStream
		print: self methodClass;
		nextPutAll: '>>';
		nextPutAll: self selector!

environment
	^(self loadedMethod ifNil: [self methodClass]) environment!

forCompiledMethod: aCompiledMethod

	selector := aCompiledMethod selector.
	methodClass := aCompiledMethod methodClass.
	sourceDescriptor := aCompiledMethod sourceDescriptor.
	source := aCompiledMethod getSource!

forSource: aString at: anInteger in: aSourceFiler

	source := aString.
	selector := (SelectorParser parse: aString) asSymbol.
	sourceDescriptor := aSourceFiler sourceDescriptorForPosition: anInteger!

getSource
	^source!

hash

	^sourceDescriptor hash!

hasSameSourceAs: aMethodOrVersion

	^self getSource = aMethodOrVersion getSource!

isFromChanges

	^self sourceFileIndex = SourceManager.ChangesIndex!

isFromSources

	^self sourceFileIndex = SourceManager.SourcesIndex!

isLoaded

	^self loadedMethod 
		ifNil: [false]
		ifNotNil: [ :method | method sourceDescriptor = self sourceDescriptor]!

load
	"Load the version of the method represented by the receiver without relogging the source.
	Return compilation result or nil on failure"

	| compiler |
	compiler := methodClass compilerClass.
	^(
	[compiler
		compileForMethod: self getSource
		in: methodClass
		environment: self environment
		flags: methodClass defaultCompilationFlags]
			on: compiler errorClass
			do: [:n | n return: nil])
			ifNotNil: 
				[:result |
				| method |
				method := result method.
				methodClass methodDictionary
					ifNotNil: 
						[:methodDictionary |
						| oldMethod |
						oldMethod := methodDictionary lookup: selector.
						result oldMethod: oldMethod.
						oldMethod ifNotNil: [method isPrivate: oldMethod isPrivate]].
				methodClass addSelector: selector withMethod: method.
				method
					sourceDescriptor: self sourceDescriptor;
					isImmutable: true.
				result fireSystemUpdateEvent.
				result]!

loadedMethod

	^self methodClass compiledMethodAt: self selector ifAbsent: [nil]!

methodClass
	^methodClass!

methodClass: aClass
	methodClass := aClass!

printOn: aStream

	super printOn: aStream.
	aStream nextPutAll: ' ('.
	self displayOn: aStream.
	aStream nextPut: $)!

selector
	^selector!

sourceDescriptor
	^sourceDescriptor!

sourceFileIndex
	^methodClass sourceManager sourceIndexFromDescriptor: sourceDescriptor! !
!MethodVersion categoriesForMethods!
=!comparing!public! !
displayOn:!printing!public! !
environment!accessing!public! !
forCompiledMethod:!initializing!public! !
forSource:at:in:!initializing!public! !
getSource!accessing!public! !
hash!comparing!public! !
hasSameSourceAs:!public!testing! !
isFromChanges!public!testing! !
isFromSources!public!testing! !
isLoaded!public!testing! !
load!operations!public! !
loadedMethod!accessing!public! !
methodClass!accessing!public! !
methodClass:!accessing!private! !
printOn:!printing!public! !
selector!accessing!public! !
sourceDescriptor!accessing!public! !
sourceFileIndex!accessing!public! !
!

!MethodVersion class methodsFor!

forCompiledMethod: aCompiledMethod

	^self new forCompiledMethod: aCompiledMethod!

forSource: aString at: anInteger in: aSourceFiler

	^self new forSource: aString at: anInteger in: aSourceFiler! !
!MethodVersion class categoriesForMethods!
forCompiledMethod:!instance creation!public! !
forSource:at:in:!instance creation!public! !
!


"Filed out from Dolphin Smalltalk 7"!

RegKeyAbstract variableSubclass: #RegKey
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RegKey guid: (GUID fromString: '{87b4c535-026e-11d3-9fd7-00a0cc3e4a32}')!
RegKey comment: 'RegKey is the class of objects which represent individual keys in the Windows Registration Database. The keys may themselves have sub-keys which are in turn represented by instances of RegKey. A RegKey is also a dictionary of registry values represented in Dolphin by instances of <RegKeyValues>.

RegKey implements the <abstractDictionary> protocol as operations against its sub-keys. In order to operate on the values under the key one must first acquire an instance of RegKeyValues using the #subValues message.'!
!RegKey categoriesForClass!System-Support! !
!RegKey methodsFor!

at: key ifAbsent: exceptionHandler
	"Answer the value named by the <readableString> argument, key.  If the key is not found,
	answer the result of evaluating the niladic valuable, exceptionHandler.
	May also raise a Win32Error exception if registry access fails for some reason."

	^(self includesKey: key)
		ifTrue: [self privateAt: key]
		ifFalse: [exceptionHandler value]!

at: key put: anObject
	"Store the argument anObject with the <readableString> 
	external key, key, in the receiver. Answer anObject.
	For a registry key, this translates to setting the default value
	of the subKey named, key, to anObject.
	Implementation Note: If anObject is nil, then any existing
	default value for the key must be removed (see #valueAt:put:)."

	| subKey |
	subKey := self privateCreateKey: key.
	subKey valueAt: nil put: anObject.
	subKey free.
	^anObject!

fileOutOn: aStream
	"File out the receiver in the regedit text representation to the <puttableStream> argument."

	aStream
		nextPut: $[;
		nextPutAll: self fullPath;
		nextPut: $];
		cr.
	self subValues fileOutOn: aStream.
	aStream cr.
	self do: [:sk | sk fileOutOn: aStream]!

includesKey: keyString
	"Answer whether the receiver has a key equal to the argument, key"

	| subKey dwErr lib |
	subKey := ExternalHandle new.
	lib := self registryLibrary.
	dwErr := lib
		regOpenKeyEx: self asParameter
			lpSubKey: keyString
			ulOptions: 0
			samDesired: KEY_READ
			phkResult: subKey.
	lib regCloseKey: subKey.
	self free.
	^dwErr = ERROR_SUCCESS!

keysAndValuesDo: operation
	"Evaluate the <dyadicValuable>, operation, for each key/value pair in the receiver."

	^self keysDo: [:k | operation value: k value: (self privateAt: k)]!

keysDo: operation
	"Evaluate the monadic valuable, operation, for each of the receiver's sub-keys."

	^self subKeyNamesDo: operation!

privateAt: aString 
	"Private - Answer the named sub-key of the receiver without error checking.
	The new key inherits the same access rights."

	^self newSubKey: aString sam: self sam!

removeKey: key ifAbsent: exceptionHandler
	"Remove the key (and its associated value), from the receiver. If key is
	not in the receiver, answer the result of evaluating the niladic valuable,
	exceptionHandler. Otherwise, answer the value named by key.
	N.B. At present we delete the entire sub-tree below the specified
	key, which Windows 95 does anyway."

	^self removeSubTree: key ifAbsent: exceptionHandler!

size
	"Answer the number of elements in the receiver.
	If insufficient access is available to determine the key info, then fill 
	it is filled out with sensible null values."

	^self keyInfo subKeyCount!

subKeys
	"Answer an <abstractDictionary> of sub-keys in the receiver (a RegKey)."

	^self!

subValues
	"Answer an <abstractDictionary> of sub-keys in the receiver (a RegKeyValues)."

	^(self subValueClass
		name: self name
		parentPath: self parentPath
		rootKey: self rootKey
		sam: self sam)
			handle: self handle;
			yourself
	! !
!RegKey categoriesFor: #at:ifAbsent:!accessing!public! !
!RegKey categoriesFor: #at:put:!accessing!public! !
!RegKey categoriesFor: #fileOutOn:!public!storing! !
!RegKey categoriesFor: #includesKey:!public!searching! !
!RegKey categoriesFor: #keysAndValuesDo:!enumerating!public! !
!RegKey categoriesFor: #keysDo:!enumerating!public! !
!RegKey categoriesFor: #privateAt:!accessing!private! !
!RegKey categoriesFor: #removeKey:ifAbsent:!public!removing! !
!RegKey categoriesFor: #size!accessing!public! !
!RegKey categoriesFor: #subKeys!accessing!public! !
!RegKey categoriesFor: #subValues!accessing!public! !

!RegKey class methodsFor!

icon
	"Answers an Icon that can be used to represent this class."

	^##(self) defaultIcon! !
!RegKey class categoriesFor: #icon!constants!public! !


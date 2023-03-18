"Filed out from Dolphin Smalltalk"!

OS.RegKeyAbstract
	variableSubclass: #'OS.RegKey'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.RegKey guid: (Core.GUID fromString: '{87b4c535-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.RegKey comment: '`RegKey` is the class of objects which represent individual keys in the Windows Registration Database. The keys may themselves have sub-keys which are in turn represented by instances of `RegKey`. A `RegKey` is also a dictionary of registry values represented in Dolphin by instances of `RegKeyValues`.

`RegKey` implements the `<abstractDictionary>` protocol as operations against its sub-keys. In order to operate on the values as if elements of a dictionary one must first acquire an instance of `RegKeyValues` using the `#subValues` message.'!
!OS.RegKey categoriesForClass!System-Support! !
!OS.RegKey methodsFor!

associationAt: aString ifAbsent: aNiladicValuable
	"Answer a new <association> between the key and value of the receiver at the <readableString> first argument.  If the specified key is not found, answer the result of evaluating the <niladicValuable> second argument."

	| subKey |
	subKey := self at: aString ifAbsent: AbsentCookie.
	^subKey == AbsentCookie ifTrue: [aNiladicValuable value] ifFalse: [subKey]!

at: aString ifAbsent: aNiladicValuable
	"Answer the value named by the <readableString> first argument.  If the key is not found, answer the result of evaluating the <niladicValuable> second argument.
	May also raise a Win32Error exception if registry access fails for some reason."

	| utf16 subHandle exists needsFree |
	aString ifNil: [^aNiladicValuable value].
	needsFree := self realize.
	exists := (AdvApi32
				regOpenKeyEx: handle
				lpSubKey: (utf16 := aString asUtf16String)
				ulOptions: 0
				samDesired: sam
				phkResult: (subHandle := Handle new)) == ERROR_SUCCESS.
	needsFree ifTrue: [self free].
	^exists
		ifTrue: 
			[(self newSubKey: utf16 sam: sam)
				handle: subHandle;
				beFinalizable;
				yourself]
		ifFalse: 
			[aNiladicValuable value]!

at: key put: anObject
	"Store the argument anObject with the <readableString> external key, key, in the receiver. Answer anObject.
	For a registry key, this translates to setting the default value of the subKey named, key, to anObject."

	"Implementation Note: If anObject is nil, then any existing default value for the key must be removed (see RegKeyAbstract>>#valueAt:put:type:)."

	| subKey |
	subKey := self createKey: key.
	subKey valueAt: nil put: anObject.
	subKey free.
	^anObject!

at: aString put: aByteObject type: aSymbol
	"Store the byte-object argument, aByteObject, as the default value of a sub-key named by the <readableString>, aString, with the registry value type specified by the <Symbol>, aSymbol. Answer anObject."

	(aString isNil and: [aSymbol == #none])
		ifTrue: 
			[self removeSubValue: aString ifAbsent: nil.
			^aByteObject].
	^self
		basicAt: aString
		put: aByteObject
		type: (ValueTypes at: aSymbol)!

basicAt: aString put: aByteObject type: anInteger
	"Store the argument, aByteObject, as the default value of a sub-key named by the <readableString>, aString, with the basic registry value type specified by the <integer>, anInteger. Answer anObject."

	| needsFree |
	needsFree := self realize.
	"Note that here we are using the higher-level RegSetKeyValue API that can create the key and set the value in one stroke."
	AdvApi32
		regSetKeyValue: handle
		lpSubKey: aString
		lpValueName: nil
		dwType: anInteger
		lpData: aByteObject
		cbData: aByteObject byteSize.
	needsFree ifTrue: [self free].
	keyInfo := nil.
	^aByteObject!

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

	| subKey err needsFree |
	keyString isNil ifTrue: [^false].
	subKey := Handle new.
	needsFree := self realize.
	err := AdvApi32
				regOpenKeyEx: handle
				lpSubKey: keyString
				ulOptions: 0
				samDesired: KEY_READ
				phkResult: subKey.
	AdvApi32 regCloseKey: subKey.
	needsFree ifTrue: [self free].
	^err == ERROR_SUCCESS!

keysAndValuesDo: aDyadicValuable
	"Evaluate the <dyadicValuable>, operation, for each key sub-key name and sub-key pair in the receiver."

	| path |
	path := self pathFromRoot.
	^self subKeyNamesDo: 
			[:each |
			aDyadicValuable value: each
				value: (RegKey
						tally: nil
						name: each
						parentPath: path
						rootKey: rootKey
						sam: sam)]!

keysDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's sub-key names."

	^self subKeyNamesDo: aMonadicValuable!

removeAssociationAt: anObject ifAbsent: aNiladicValuable
	"Remove the key and value association with the specified key from the receiver. If the key is not in the receiver, return the result of evaluating the <NiladicValuable>, aNiladicValuable. Otherwise, answer the removed <association>."

	^self removeKey: anObject ifAbsent: aNiladicValuable!

removeKey: aString ifAbsent: aNiladicValuable
	"Remove the specified key (and its associated value), from the receiver. If the key is not in the receiver, answer the result of evaluating the <niladicValuable> second argument. Otherwise, answer the value named by the key."

	^(self removeSubTree: aString)
		ifTrue: [self newSubKey: aString sam: sam]
		ifFalse: [aNiladicValuable value]!

size
	"Answer the number of elements in the receiver.
	If insufficient access is available to determine the key info, then fill 
	it is filled out with sensible null values."

	^self keyInfo subKeyCount!

subKeys
	"Answer an <abstractDictionary> of sub-keys in the receiver (a RegKey)."

	^self!

subValues
	"Answer an <abstractDictionary> of sub-values in the receiver (a RegKeyValues)."

	| values |
	values := RegKeyValues
				tally: nil
				name: name
				parentPath: parentPath
				rootKey: rootKey
				sam: sam.
	self isRoot ifTrue: [values handle: handle].
	^values! !
!OS.RegKey categoriesForMethods!
associationAt:ifAbsent:!accessing!public! !
at:ifAbsent:!accessing!public! !
at:put:!accessing!public! !
at:put:type:!public! !
basicAt:put:type:!public! !
fileOutOn:!public!storing! !
includesKey:!public!searching! !
keysAndValuesDo:!enumerating!public! !
keysDo:!enumerating!public! !
removeAssociationAt:ifAbsent:!public!removing! !
removeKey:ifAbsent:!public!removing! !
size!accessing!public! !
subKeys!accessing!public! !
subValues!accessing!public! !
!

!OS.RegKey class methodsFor!

icon
	"Answers an Icon that can be used to represent this class."

	^##(self) defaultIcon! !
!OS.RegKey class categoriesForMethods!
icon!constants!public! !
!


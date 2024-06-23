"Filed out from Dolphin Smalltalk"!

OS.RegKeyAbstract
	variableSubclass: #'OS.RegKeyValues'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.RegKeyValues guid: (Core.GUID fromString: '{87b4c536-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.RegKeyValues comment: '`RegKeyValues` is the class of objects which represent the dictionary of named values under a particular key in  the Windows Registration Database.

`RegKeyValues` implements the `<abstractDictionary>` protocol mapping value names to dictionary keys and the registry values to dictionary values.'!

!OS.RegKeyValues categoriesForClass!Collections-Unordered!System-Support! !

!OS.RegKeyValues methodsFor!

associationAt: aString ifAbsent: aNiladicValuable
	"Answer a new <association> between the key and value of the receiver at the <readableString> first argument.  If the specified key is not found, answer the result of evaluating the <niladicValuable> second argument."

	| value |
	value := self at: aString ifAbsent: AbsentCookie.
	^value == AbsentCookie
		ifTrue: [aNiladicValuable value]
		ifFalse: [self associationClass key: aString value: value]!

at: aString ifAbsent: aNiladicValuable
	"Answer the value named by the <String> argument.  If the key is not found, answer the result of evaluating the <niladicValuable> last argument.
	May also raise a Win32Error exception if registry access fails for some reason."

	^self valueAt: aString ifAbsent: aNiladicValuable!

at: aString put: anObject
	"Store the argument anObject as a named sub-value of the receiver. Throw an error if the object cannot be represented as a registry value. Answer anObject."

	^self valueAt: aString put: anObject!

changeKey: aString1 to: aString2
	| assoc |
	assoc := self associationAt: aString1.
	assoc key: aString2.
	self add: assoc.
	self removeKey: aString1.
	^assoc!

fileOutOn: aPuttableStream
	"File out the receiver in the regedit text representation to the <puttableStream> argument."

	self keysAndValuesDo: 
			[:k :v |
			| wrapAt |
			wrapAt := aPuttableStream position + 76.
			k isEmpty
				ifTrue: [aPuttableStream nextPut: $@]
				ifFalse: 
					[aPuttableStream
						nextPut: $";
						nextPutAll: k;
						nextPut: $"].
			aPuttableStream nextPut: $=.
			v isInteger
				ifTrue: 
					[aPuttableStream
						nextPutAll: 'dword:';
						nextPutAll: ('%08x' sprintfWith: v)]
				ifFalse: 
					[(v isKindOf: String)
						ifTrue: 
							[aPuttableStream
								nextPut: $";
								nextPutAll: v;
								nextPut: $"]
						ifFalse: 
							[aPuttableStream nextPutAll: 'hex:'.
							v do: 
									[:b |
									aPuttableStream position > wrapAt
										ifTrue: 
											[aPuttableStream
												nextPut: $\;
												cr;
												space;
												space.
											wrapAt := aPuttableStream position + 74].
									aPuttableStream nextPutAll: ('%02x' sprintfWith: b)]
								separatedBy: [aPuttableStream nextPut: $,]]].
			aPuttableStream cr]!

includesKey: aString
	"Answer whether the receiver has value with the specified name."

	self at: aString ifAbsent: [^false].
	^true!

keysAndValuesDo: aDyadicValuable
	"Evaluate the <dyadicValuable) argument for each of the receiver's names and values."

	^self subValueNamesAndValuesDo: aDyadicValuable!

keysDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's sub-keys."

	^self subValueNamesDo: aMonadicValuable!

removeAssociationAt: aString ifAbsent: aNiladicValuable
	"Remove the key and value association with the specified key from the receiver. If the key is not in the receiver, return the result of evaluating the <NiladicValuable>, aNiladicValuable. Otherwise, answer the removed <association>."

	| value |
	value := self removeSubValue: aString ifAbsent: AbsentCookie.
	^value == AbsentCookie
		ifTrue: [aNiladicValuable value]
		ifFalse: [self associationClass key: aString value: value]!

removeKey: aString ifAbsent: aNiladicValuable
	"Remove the key (and its associated value), from the receiver. If the key is not in the receiver, answer the result of evaluating the <niladicValuable> last argument. Otherwise, answer the value named by the key string."

	^self removeSubValue: aString ifAbsent: aNiladicValuable!

size
	"Answer the number of values under the registry key."

	^self keyInfo valueCount!

subKeys
	"Answer an <abstractDictionary> of sub-keys in the receiver (a RegKey)."

	| keys |
	keys := RegKey
				tally: nil
				name: name
				parentPath: self pathFromRoot
				rootKey: rootKey
				sam: sam.
	self isRoot ifTrue: [keys handle: handle].
	^keys!

subValues
	"Answer an <abstractDictionary> of sub-values in the receiver (a RegKeyValues)."

	^self! !

!OS.RegKeyValues categoriesForMethods!
associationAt:ifAbsent:!accessing!public! !
at:ifAbsent:!accessing!public! !
at:put:!accessing!public! !
changeKey:to:!accessing!private! !
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

!OS.RegKeyValues class methodsFor!

icon
	"Answers an Icon that can be used to represent this class."

	^##(self) defaultIcon! !

!OS.RegKeyValues class categoriesForMethods!
icon!constants!public! !
!


"Filed out from Dolphin Smalltalk"!

RegKeyAbstract variableSubclass: #RegKeyValues
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RegKeyValues guid: (GUID fromString: '{87b4c536-026e-11d3-9fd7-00a0cc3e4a32}')!
RegKeyValues comment: 'RegKeyValues is the class of objects which represent the dictionary of named values under a particular key in  the Windows Registration Database.

RegKeyValues implements the <abstractDictionary> protocol mapping value names to keys and the registry values to dictionary values.'!
!RegKeyValues categoriesForClass!Collections-Unordered!System-Support! !
!RegKeyValues methodsFor!

associationAt: key ifAbsent: exceptionHandler
	"Answer a new <association> between the key and value of
	the receiver at the argument, key.  If key is not found, answer the
	result of evaluating the <niladicValuable>, exceptionHandler."

	^self associationClass
		key: key
		value: (self at: key ifAbsent: [^exceptionHandler value])!

at: key ifAbsent: exceptionHandler
	"Answer the value named by the argument, key.  If keyString is not found,
	answer the result of evaluating the niladic valuable, exceptionHandler.
	May also raise a Win32Error exception if registry access fails for some
	reason."

	^self valueAt: key ifAbsent: exceptionHandler!

at: key put: anObject
	"Store the argument anObject with the external key, aKey,
	in the receiver. Answer anObject"

	^self valueAt: key put: anObject!

changeKey: key to: newKey
	"Private - Change the key of the element of the receiver with key, key, to
	newKey (e.g. rename a  registry value). Answer the value of the element
	whose key was changed."

	| assoc |
	assoc := self associationAt: key.
	assoc key: newKey.
	self add: assoc.
	self removeKey: key.
	^assoc!

fileOutOn: stream 
	"File out the receiver in the regedit text representation to the <puttableStream> argument, stream."

	self keysAndValuesDo: 
			[:k :v | 
			| wrapAt |
			wrapAt := stream position + 76.
			k isEmpty 
				ifTrue: [stream nextPut: $@]
				ifFalse: 
					[stream
						nextPut: $";
						nextPutAll: k;
						nextPut: $"].
			stream nextPut: $=.
			v isInteger 
				ifTrue: 
					[stream
						nextPutAll: 'dword:';
						nextPutAll: ('%08x' sprintfWith: v)]
				ifFalse: 
					[(v isKindOf: String) 
						ifTrue: 
							[stream
								nextPut: $";
								nextPutAll: v;
								nextPut: $"]
						ifFalse: 
							[stream nextPutAll: 'hex:'.
							v do: 
									[:b | 
									stream position > wrapAt 
										ifTrue: 
											[stream
												nextPut: $\;
												cr;
												space;
												space.
											wrapAt := stream position + 74].
									stream nextPutAll: ('%02x' sprintfWith: b)]
								separatedBy: [stream nextPut: $,]]].
			stream cr]!

includesKey: keyString
	"Answer whether the receiver has a key equal to the argument, key"

	self at: keyString ifAbsent: [^false].
	^true!

keysAndValuesDo: operation
	"Evaluate the monadic valuable, operation, for each of the receiver's names and values."

	^self subValueNamesAndValuesDo: operation!

keysDo: operation
	"Evaluate the monadic valuable, operation, for each of the receiver's sub-keys."

	^super subValueNamesDo: operation!

removeKey: key ifAbsent: exceptionHandler
	"Remove the key (and its associated value), from the receiver. If key is
	not in the receiver, answer the result of evaluating the niladic valuable,
	exceptionHandler. Otherwise, answer the value named by key.
	N.B. At present we use the delete the entire sub-tree below the specified
	key, which Windows 95 does anyway."

	^self removeSubValue: key ifAbsent: exceptionHandler!

size
	"Answer the number of elements in the receiver."

	^self keyInfo valueCount!

subKeys
	"Answer an <abstractDictionary> of sub-keys in the receiver (a RegKey)."

	^(self subKeyClass
		name: self name
		parentPath: self pathFromRoot
		rootKey: self rootKey
		sam: self sam)
			handle: self handle;
			yourself!

subValues
	"Answer an <abstractDictionary> of sub-keys in the receiver (a RegKeyValues)."

	^self! !
!RegKeyValues categoriesForMethods!
associationAt:ifAbsent:!accessing!public! !
at:ifAbsent:!accessing!public! !
at:put:!accessing!public! !
changeKey:to:!accessing!private! !
fileOutOn:!public!storing! !
includesKey:!public!searching! !
keysAndValuesDo:!enumerating!public! !
keysDo:!enumerating!public! !
removeKey:ifAbsent:!public!removing! !
size!accessing!public! !
subKeys!accessing!public! !
subValues!accessing!public! !
!

!RegKeyValues class methodsFor!

icon
	"Answers an Icon that can be used to represent this class."

	^##(self) defaultIcon! !
!RegKeyValues class categoriesForMethods!
icon!constants!public! !
!


"Filed out from Dolphin Smalltalk"!

Core.Dictionary
	variableSubclass: #'OS.RegKeyAbstract'
	instanceVariableNames: 'name parentPath rootKey sam handle keyInfo'
	classVariableNames: 'AccessModes ValueTypes'
	imports: #(#{OS.WinRegConstants} #{OS.Win32Errors})
	classInstanceVariableNames: ''
	classConstants: { 'PathSeparator' -> '\' }!
OS.RegKeyAbstract guid: (Core.GUID fromString: '{87b4c52b-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.RegKeyAbstract isNonInstantiable: true!
OS.RegKeyAbstract comment: '`RegKeyAbstract` is the abstract class of objects with concrete subclasses to represent keys in the Windows Registration Database. The keys may have sub-keys which are represented by instances of `RegKey`. A `RegKey` is also a dictionary of registry values represented in Dolphin by instances of `RegKeyValues`.

`RegKeyAbstract` implements the `<abstractDictionary>` protocol as operations against either the sub-keys (in the case of `RegKey`) or sub-values (in the case of `RegKeyValues`).

The handles for registry keys are Windows kernel handles and as such are a limited resource. As it is very easy to attempt to open a large number of such handles by enumerating over `RegKey`s. e.g. using the dictionary abstractions, some care is taken to avoid holding the keys open longer than might be necessary (i.e. with the instances in a _realized_ state). This is achieved by explicitly realizing and then free''ing any instance around any attempted access to registry data, with unrealised keys being realised lazily when required. Obviously this comes at some cost, especially as realizing the instances by calls on the registry APIs is quite expensive. To avoid incurring the cost of repeatedly re-realizing the same key, the keys can be realised in advance of any bulk operation. The individual operations will only free a key that they themselves opened. 

Note that the `RegKey` instances returned by `RegKey>>#at:ifAbsent:` and `RegKey>>#createKey:` will be in a realised state. The instances passed through collection enumerations such as `#do:`, `#keysAndValuesDo:`, etc, will not be in a realised state.

It is not necessary to explicitly free instances in Dolphin 8 and later, because they are now finalizable. Explicit free''ing is a best practice, however, if it helps avoid the accumulation of finalizable garbage. It also avoids the problem of building up a large backlog of instances awaiting finalization when the system is busy enough that there are no free cycles for the finalizer to run.'!
!OS.RegKeyAbstract categoriesForClass!System-Support! !
!OS.RegKeyAbstract methodsFor!

= anObject
	"Answer whether the receiver is considered equivalent to the argument."

	#todo.	"Generating the full path is a bit expensive, so maybe break down and compare root handle, path from root, and name - same applies to #hash"
	^self species == anObject species and: [self fullPath = anObject fullPath]!

add: anAssociation
	"Add anAssociation to the receiver. Answer anAssociation. As we are only
	simulating a <Dictionary>, we do not actually store <Association>s, therefore we must 
	reimplement this in terms of #at:put:."

	self at: anAssociation key put: anAssociation value.
	^anAssociation!

asParameter
	"Answer the receiver in a form suitable for passing to an external function primitive method (see ExternalLibrary and subclasses)."

	self realize.
	^handle!

associationAt: aString ifAbsent: aNiladicValuable
	"Answer a new <association> between the key and value of the receiver at the <readableString> first argument.  If the specified key is not found, answer the result of evaluating the <niladicValuable> second argument."

	^self subclassResponsibility!

associationsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument, for each of the receiver's key/value mappings."

	"Implementation Note: We must override because the receiver does not actually contain Associations."

	self keysAndValuesDo: [:k :v | aMonadicValuable value: (self associationClass key: k value: v)]!

at: aString ifAbsent: aNiladicValuable
	"Answer the value named by the <readableString> first argument. If the key is is not found answer the result of evaluating the <niladicValuable> second argument.
	May also raise a Win32Error exception if registry access fails for some reason."

	^self subclassResponsibility!

at: aString put: anObject
	"Store the argument anObject with the <readableString> external key, key,
	in the receiver. Answer anObject"

	^self subclassResponsibility!

basicFree
	"Private - Release external resources held by the receiver. Any errors closing the handle are ignored."

	^AdvApi32 regCloseKey: handle!

basicObjectAt: aString put: anObject
	^self requiresSerializer!

basicValueAt: aString put: anObject type: typeInteger size: anInteger
	| needsFree |
	needsFree := self realize.
	AdvApi32
		regSetValueEx: handle
		lpValueName: aString
		reserved: 0
		dwType: typeInteger
		lpData: anObject
		cbData: anInteger.
	needsFree ifTrue: [self free].
	"We may have added another value, or increased the maximum value length."
	keyInfo := nil!

binaryAt: aString put: aByteArray
	"Write a REG_BINARY value to the receiver with the <readableString> name, keyString, and <ByteArray> value, aByteArray. Answer the value written."

	self
		basicValueAt: aString
		put: aByteArray
		type: REG_BINARY
		size: aByteArray byteSize.
	^aByteArray!

bytesAt: aString put: aByteObject as: aClass
	self requiresSerializer!

copyingClass
	"Private - Answer the class of object expected when the receiver is copied in whole or in part."

	^Dictionary!

createKey: aString
	"Create or open a registry key under the receiver with the specified <readableString> relative path from here (note that this implies that more than one level can be created at once, and this is indeed the case, although only up to 32 levels can be created this way). Answers the new key."

	| utf16 subHandle needsFree |
	needsFree := self realize.
	"This FFI function is declared with errno return type, so will throw an exception automatically; we don't need to check the return value here"
	AdvApi32
		regCreateKeyEx: handle
		lpSubKey: (utf16 := aString asUtf16String)
		reserved: nil
		lpClass: nil
		dwOptions: REG_OPTION_NON_VOLATILE
		samDesired: sam
		lpSecurityAttributes: nil
		phkResult: (subHandle := Handle new)
		lpdwDisposition: nil.
	keyInfo := nil.	"keyInfo invalidated"
	needsFree ifTrue: [self free].
	^(self newSubKey: utf16 sam: sam)
		handle: subHandle;
		beFinalizable;
		yourself!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	name displayOn: aPuttableStream!

do: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the element of the receiver. Answer the receiver."

	self keysAndValuesDo: [:k :v | aMonadicValuable value: v]!

dwordAt: aString put: anInteger
	"Write a REG_DWORD value to the receiver with the <readableString> name, aString, and <integer> value, anInteger."

	| value |
	value := (ByteArray newFixed: 4)
				uint32AtOffset: 0 put: anInteger;
				yourself.
	self
		basicValueAt: aString
		put: value
		type: REG_DWORD
		size: 4.
	^value!

fileOutOn: aPuttableStream
	"File out the receiver in the regedit text representation to the <puttableStream> argument."

	^self subclassResponsibility!

free
	"Release external resources held by the receiver. The receiver is still valid after this call, and can be re-realized lazily (and transparently) on demand."

	handle ifNil: [^self].
	"Discard the key info as the key object may persist, and the underlying key could be changed through an alias, or by another program"
	keyInfo := nil.
	self beUnfinalizable.
	self isRoot
		ifFalse: 
			[self basicFree.
			handle := nil]!

fullPath
	"Answer the full path to the receiver."

	^self isRoot ifTrue: [name] ifFalse: [rootKey name , PathSeparator , self pathFromRoot]!

handle
	^handle!

handle: anIntegerOrHandle
	"Private - Set the receiver's handle to the specified registry key handle (either one of the predefined HKEY_XX constants, or a handle returned from RegOpenKeyEx())"

	handle := anIntegerOrHandle!

hash
	"Answer the positive <integer> hash value for the receiver."

	^self fullPath hash!

includesKey: aString
	"Answer whether the receiver has a key equal to the <readableString> argument."

	^self subclassResponsibility!

isRoot
	"Answer whether the receiver is a root key."

	^parentPath isNil!

isWriteable
	"Answer whether this key can be written to (i.e. create, update and delete operations on sub-keys and values are possible)."

	^sam allMask: KEY_WRITE!

key
	"Answer the lookup key of the receiver."

	^name!

key: aString
	"Set the lookup key of the receiver to the <readableString> argument."

	#todo.	"Implement registry key renaming"
	^Error notYetImplemented!

keyInfo
	"Answer a REGKEYINFO structure containing metadata about the receiver's registry key."

	^keyInfo ifNil: [keyInfo := self queryKeyInfo]!

keysAndValuesDo: aDyadicValuable
	"Evaluate the <dyadicValuable> argument for each key/value pair in the receiver."

	^self subclassResponsibility!

keysDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's sub-keys."

	^self subclassResponsibility!

lookup: anObject
	"Answer the value named by the <Object> argument, or nil if there is no such key in the receiver."

	^self at: anObject ifAbsent: nil!

mode: aSymbol
	"Set the access mode required of the receiver, e.g. #readWrite, or #read."

	self sam: (AccessModes at: aSymbol)!

name
	"Answer the name of the registry key represented by the receiver."

	^name!

name: aString
	name := aString!

newSubKey: aString sam: anInteger
	^(aString
		nextIdentityIndexOf: $\
		from: 1
		to: aString size) == 0
		ifTrue: 
			[RegKey
				tally: nil
				name: aString
				parentPath: self pathFromRoot
				rootKey: rootKey
				sam: anInteger]
		ifFalse: 
			[| path splits |
			path := self pathFromRoot.
			splits := self splitPath: (path isEmpty ifTrue: [aString] ifFalse: [path , PathSeparator , aString]).
			RegKey
				tally: nil
				name: (splits at: 2)
				parentPath: (splits at: 1)
				rootKey: rootKey
				sam: anInteger]!

noneAtPut: aString
	"Write a REG_NONE value to the receiver's registry key with the <readableString> name, aString. As a special case if the value name is nil, then the default value is removed."

	aString
		ifNil: [self removeSubValue: aString ifAbsent: nil]
		ifNotNil: 
			[self
				basicValueAt: aString
				put: nil
				type: REG_NONE
				size: 0].
	^nil!

objectFromValue: aByteArray type: typeInteger size: sizeInteger
	"Private - Instantiate an appropriate object to represent the registry value with the specified type, bytes, and size."

	^(##(| notImplemented |
		notImplemented := [:bytes :size | Error notYetImplemented].
		{
			"REG_NONE: 0"
			[:bytes :size | nil].
			"REG_SZ: 1"
			[:bytes :size |
			size == 0
				ifTrue: [Utf16String empty]
				ifFalse: [Utf16String fromByteArray: bytes length: (size bitShift: -1) - 1]].
			"REG_EXPAND_SZ: 2"
			[:bytes :size |
			Kernel32
				expandEnvironmentStrings: (Utf16String fromByteArray: bytes length: (size bitShift: -1) - 1)].
			"REG_BINARY: 3"
			[:bytes :size| bytes copyFrom: 1 to: size].
			"REG_DWORD: 4"
			[:bytes :size | bytes int32AtOffset: 0].
			"REG_DWORD_BIG_ENDIAN: 5"
			notImplemented.
			"REG_LINK: 6"
			notImplemented.
			"REG_MULTI_SZ: 7"
			[:bytes :size | RegKeyAbstract decodeMultiSz: bytes size: size].
			"REG_RESOURCE_LIST:8"
			notImplemented.
			"REG_FULL_RESOURCE_DESCRIPTOR: 9"
			notImplemented.
			"REG_RESOURCE_REQUIREMENTS_LIST: 10"
			notImplemented.
			"REG_QWORD: 11"
			[:bytes :size | bytes int64AtOffset: 0]})
		at: typeInteger + 1) value: aByteArray value: sizeInteger!

parentKey
	"Answer the parent key of the receiver, or nil if at a root."

	| splits |
	self isRoot ifTrue: [^nil].
	parentPath isEmpty ifTrue: [^rootKey].
	splits := self splitPath: parentPath.
	^RegKey
		tally: nil
		name: (splits at: 2)
		parentPath: (splits at: 1)
		rootKey: rootKey
		sam: sam!

parentPath
	"Answer the <readableString> path of the parent key of the receiver from a root key."

	^parentPath!

parentPath: aString
	parentPath := aString!

pathFromRoot
	"Answer the <readableString> path to the receiver from the root key. This does not include the hive such as HKEY_CLASSES_ROOT, but see #fullPath."

	^parentPath
		ifNil: [##(Utf16String empty)]
		ifNotNil: [parentPath isEmpty ifTrue: [name] ifFalse: [parentPath , PathSeparator , name]]!

postCopy
	"Apply any final flourish to the copy that may be required in order to ensure that the copy does not share any state with the original, apart from the elements."

	"Implementation note: We don't want to inherit the Dictionary implementation as this is a proxy for the registry."

	^self!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream 
		basicPrint: self; 
		nextPut: $(;
		nextPutAll: (handle isNull ifTrue: ['NULL'] ifFalse: [handle asInteger printStringRadix: 16]);
		nextPutAll: ' - ';
		print: self fullPath;
		nextPut: $)!

queryKeyInfo
	| buf base needsFree |
	buf := REGKEYINFO newBuffer.
	needsFree := self realize.
	base := buf yourAddress.
	AdvApi32
		regQueryInfoKey: handle
		lpClass: nil
		lpcchClass: nil
		lpReserved: nil
		lpcSubKeys: base + OS.REGKEYINFO._OffsetOf_subKeyCount
		lpcbMaxSubKeyLen: base + OS.REGKEYINFO._OffsetOf_maxSubKeyLen
		lpcbMaxClassLen: base + OS.REGKEYINFO._OffsetOf_maxClassLen
		lpcValues: base + OS.REGKEYINFO._OffsetOf_valueCount
		lpcbMaxValueNameLen: base + OS.REGKEYINFO._OffsetOf_maxValueNameLen
		lpcbMaxValueLen: base + OS.REGKEYINFO._OffsetOf_maxValueLen
		lpcbSecurityDescriptor: base + OS.REGKEYINFO._OffsetOf_securityDescriptorLen
		lpftLastWriteTime: base + OS.REGKEYINFO._OffsetOf_ftLastWriteTime.
	needsFree ifTrue: [self free].
	^buf!

qwordAt: aString put: anInteger
	"Write a REG_QWORD value to the receiver's registry key with the <readableString> name, aString, and <integer> value, anInteger."

	| value |
	value := UInt64Bytes fromInteger: anInteger.
	self
		basicValueAt: aString
		put: value
		type: REG_QWORD
		size: 8.
	^value!

realize
	"Realize (create) the external resource associated with the receiver, but only if not already realized."

	handle isNull ifFalse: [^false].
	(AdvApi32
		regOpenKeyEx: rootKey handle
		lpSubKey: self pathFromRoot
		ulOptions: 0
		samDesired: sam
		phkResult: (handle := Handle new)) == ERROR_SUCCESS
		ifFalse: [self errorNotFound: self].
	self beFinalizable.
	^true!

removeAssociationAt: anObject ifAbsent: aNiladicValuable
	"Remove the key and value association with the specified key from the receiver. If the key is not in the receiver, return the result of evaluating the <NiladicValuable>, aNiladicValuable. Otherwise, answer the removed <association>."

	^self subclassResponsibility!

removeKey: aString ifAbsent: aNiladicValuable
	"Remove the specified key (and its associated value), from the receiver. If the key is not in the receiver, answer the result of evaluating the <niladicValuable> second argument. Otherwise, answer the value named by the key."

	^self subclassResponsibility!

removeSubKey: aString ifAbsent: exceptionHandler
	"Remove the named sub-key, from the receiver. If there is no such sub-key, answer the result of evaluating the <niladicValuable> second argument. Otherwise, answer the key.
	The operation will throw a Win32Error (ERROR_ACCESS_DENIED) if the named sub-key has any sub-keys of its own, but see #removeSubTree:[ifAbsent:]"

	| dwErr needsFree |
	needsFree := self realize.
	dwErr := AdvApi32 regDeleteKey: handle lpSubKey: aString.
	needsFree ifTrue: [self free].
	^dwErr == ERROR_SUCCESS
		ifTrue: 
			[keyInfo := nil.
			aString]
		ifFalse: [exceptionHandler value]!

removeSubTree: aString
	"Recursively remove the specified sub-tree of the receiver. Answer true if the key existed and was removed, or false if it did not exist. Throw a Win32Error if any registry error (other than the key not existing) is encountered."

	| needsFree dwErr |
	needsFree := self realize.
	dwErr := AdvApi32 regDeleteTree: handle lpSubKey: aString.
	needsFree ifTrue: [self free].
	^dwErr == ERROR_SUCCESS!

removeSubTree: aString ifAbsent: aNiladicValuable
	"Recursively remove the specified sub-tree of the receiver."

	(self removeSubTree: aString) ifFalse: [aNiladicValuable value]!

removeSubValue: aString ifAbsent: aNiladicValuable
	"Remove the specified sub-value of the receiver."

	| value needsFree |
	needsFree := self realize.
	value := self valueAt: aString ifAbsent: AbsentCookie.
	value == AbsentCookie
		ifTrue: [value := aNiladicValuable value]
		ifFalse: 
			[keyInfo := nil.
			AdvApi32 regDeleteValue: handle lpValueName: aString].
	needsFree ifTrue: [self free].
	^value!

requiresSerializer
	self error: 'Requires RegistrySerializer'!

resize: anInteger
	"Private - Resize the receiver to have a capacity suitable for accommodating
	at least anInteger elements. Answer the receiver (resized). The receiver is
	rehashed regardless of whether it is already of the correct capacity (this
	is important).

	The Registry is an external dictionary, and it isn't really our business to be
	maintaining its internal structure!!"

	^self
!

rootHandle
	"Answer the handle of the receiver's registry hive."

	#deprecated.
	^rootKey handle!

rootKey
	"Answer the value of the receiver's instance variable rootKey."

	^rootKey!

rootKey: aRegKey
	rootKey := aRegKey!

sam
	"Answer an <Integer> representing the receiver's access right flags."

	^sam!

sam: anInteger
	"Set the security access mode to the argument. This controls what permissions are requested when opening the key. If the user does not have the required priviledges for the requested rights, then an error will be raised when an attempt is made to use the receiver."

	sam = anInteger ifFalse: [
		"SAM is being changed, need to reopen"
		sam := anInteger.
		self free]!

setSam: anInteger
	sam := anInteger!

shrink
	"Rebuild the collection with the optimal size for its current number of elements."

	"The Registry is an external dictionary, and it isn't really our business to be maintaining its internal structure!!"

	^self!

size
	"Answer the number of elements in the receiver."

	^self subclassResponsibility!

splitPath: aString
	| lastSlash |
	lastSlash := aString lastIndexOf: $\.
	^lastSlash == 0
		ifFalse: [{aString copyFrom: 1 to: lastSlash - 1. aString copyFrom: lastSlash + 1 to: aString size}]
		ifTrue: [{Utf16String empty. aString}]!

stringArrayAt: aString put: anArray
	"Write a REG_MULTISZ value to the receiver's registry key with the <readableString> name, keyString, and a null-separated list of string values encoded from the <Array>, anArray."

	| value |
	value := self class encodeMultiSz: anArray.
	self
		basicValueAt: aString
		put: value
		type: REG_MULTI_SZ
		size: value byteSize.
	^value!

stringAt: keyString put: valueString
	"Write a REG_SZ value to the receiver's registry key with the <readableString> name, keyString, and <readableString> value, valueString."

	| value |
	value := valueString asUtf16String.
	self
		basicValueAt: keyString
		put: value
		type: REG_SZ
		size: value byteSize.
	^value!

subKeyNamesDo: aMonadicValuable
	"Private - Evaluate the <monadicValuable> argument for each of the receiver's sub-key names."

	| needsFree info |
	needsFree := self realize.
	info := self keyInfo.
	info subKeyCount > 0
		ifTrue: 
			[| maxSize i keyName cbName |
			i := 0.
			"The sub-key name length is the size in UTF-16 code points, not including the terminating null"
			keyName := Utf16String newFixed: (maxSize := info maxSubKeyLen).
			maxSize := maxSize + 1.
			cbName := ByteArray newFixed: 4.
			
			[| dwErr |
			
			[cbName uint32AtOffset: 0 put: maxSize.
			(dwErr := AdvApi32
						regEnumKeyEx: handle
						dwIndex: i
						lpName: keyName
						lpcbName: cbName
						lpReserved: nil
						lpClass: nil
						lpcbClass: nil
						lpftLastWriteTime: nil) == ERROR_SUCCESS]
					whileTrue: 
						[aMonadicValuable value: (keyName copyFrom: 1 to: (cbName uint32AtOffset: 0)).
						i := i + 1].
			"The reported max sub-key length is a snapshot at a point in time, so may not remain accurate. If we find a longer key name appears, we loop doubling the buffer 'til we get it all. We can cut the cost of this check by making it the outer loop."
			dwErr == ERROR_MORE_DATA]
					whileTrue: 
						[maxSize := maxSize bitShift: 1.
						keyName resize: maxSize]].
	needsFree ifTrue: [self free]!

subKeys
	"Answer the collection of sub-keys under the receiver (a RegKey)."

	^self subclassResponsibility!

subValueNames
	"Answer a <sequencedReadableCollection> or <readableString>, being the names of the values under the registry key."

	| needsFree info names |
	needsFree := self realize.
	info := self keyInfo.
	"If the maximum value name length is zero, then there is at most the default value. This is a very common case in practice, so worth optimising."
	names := info maxValueNameLen == 0
				ifTrue: 
					["Even the default value may not be set."
					info valueCount == 0 ifTrue: [#()] ifFalse: [#('')]]
				ifFalse: 
					[| stream |
					stream := Array writeStream: info valueCount.
					self subValueNamesDo: [:each | stream nextPut: each].
					stream grabContents].
	needsFree ifTrue: [self free].
	^names!

subValueNamesAndValuesDo: aDyadicValuable
	"Evaluate the <dyadicValuable> argument for each of the receiver's sub-values, passing its name and an object corresponding to the registry entry as the first and second arguments respectively."

	| base maxNameSize info data valueName i needsFree maxDataSize metadata |
	needsFree := self realize.
	info := self keyInfo.
	maxNameSize := info maxValueNameLen.
	maxDataSize := info maxValueLen.
	valueName := Utf16String newFixed: maxNameSize.	"Strings automatically include space for null-term"
	data := ByteArray new: maxDataSize.
	metadata := ByteArray newFixed: 12.
	base := metadata yourAddress.
	i := 0.
	
	[| dwErr |
	
	["cbValueName must include Null terminator"
	metadata
		uint32AtOffset: 0 put: maxNameSize + 1;
		uint32AtOffset: 4 put: maxDataSize.
	(dwErr := AdvApi32
				regEnumValue: handle
				dwIndex: i
				lpValueName: valueName
				lpcbValueName: base
				lpReserved: nil
				lpType: base + 8
				lpData: data
				lpcbData: base + 4) == ERROR_SUCCESS]
			whileTrue: 
				[aDyadicValuable value: (valueName copyFrom: 1 to: (metadata uint32AtOffset: 0))
					value: (self
							objectFromValue: data
							type: (metadata uint32AtOffset: 8)
							size: (metadata uint32AtOffset: 4)).
				i := i + 1].
	dwErr == ERROR_MORE_DATA]
			whileTrue: 
				["We don't know which of the buffers is too small, so double both"
				data resize: (maxDataSize := maxDataSize bitShift: 1).
				valueName resize: (maxNameSize := maxNameSize bitShift: 1)].
	needsFree ifTrue: [self free]!

subValueNamesDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument, for each of the receiver's value names."

	| maxSize needsFree info |
	needsFree := self realize.
	info := self keyInfo.
	maxSize := info maxValueNameLen.
	"In practice most keys have just a default value, a condition we can distinguish from the maximum value name length being zero, so optimize for that."
	maxSize == 0
		ifTrue: [info valueCount == 0 ifFalse: [aMonadicValuable value: Utf16String empty]]
		ifFalse: 
			[| i valueName cbValueName |
			valueName := Utf16String newFixed: maxSize.	"Strings automatically include space for null-term"
			maxSize := maxSize + 1.
			cbValueName := ByteArray newFixed: 4.
			i := 0.
			
			[| dwErr |
			
			[cbValueName uint32AtOffset: 0 put: maxSize.
			(dwErr := AdvApi32
						regEnumValue: handle
						dwIndex: i
						lpValueName: valueName
						lpcbValueName: cbValueName
						lpReserved: nil
						lpType: nil
						lpData: nil
						lpcbData: nil) == ERROR_SUCCESS]
					whileTrue: 
						[aMonadicValuable value: (valueName copyFrom: 1 to: (cbValueName uint32AtOffset: 0)).
						i := i + 1].
			"The reported max value name length is a snapshot at a point in time, so may not remain accurate. If we find a longer name appears we double the buffer and try again 'til we get it all. We can cut the cost of this by making it the outer loop."
			dwErr == ERROR_MORE_DATA]
					whileTrue: [valueName resize: (maxSize := maxSize bitShift: 1)]].
	needsFree ifTrue: [self free]!

subValues
	"Answer the collection of sub-values under the receiver (a RegKeyValues)."

	^self subclassResponsibility!

value
	"Answer the default value for the receiver, or nil if none."

	^self valueAt: nil ifAbsent: nil!

value: anObject
	"Set the default value of the receiver to the <Object> argument, anObject, which will need to of a type that is directly representable as a registry value, e.g. a String, aByteArray, or an Integer within the 64-bit 2's complement range."

	self valueAt: nil put: anObject!

valueAt: aString
	"Answer the registry value subordinate to the receiver named by the <readableString> argument.  If the named value is not found, then raise a NotFoundError. May also raise a Win32Error exception if 
	registry access fails for some other reason."

	^self valueAt: aString ifAbsent: [self errorNotFound: aString]!

valueAt: aString ifAbsent: aNiladicValuable
	"Answer the value named by the <readableString> first argument.  If the key is not found, answer the result of evaluating the <niladicValuable> second argument. May raise a Win32Error exception if registry access fails for some reason."

	| metadata valueBuf needsFree size |
	needsFree := self realize.
	metadata := ByteArray newFixed: 8.
	(AdvApi32
		regQueryValueEx: handle
		lpValueName: aString
		lpReserved: nil
		lpType: nil
		lpData: nil
		lpcbData: metadata) == ERROR_SUCCESS
		ifFalse: [^aNiladicValuable value].
	size := metadata uint32AtOffset: 0.
	valueBuf := ByteArray newFixed: size.
	AdvApi32
		regQueryValueEx: handle
		lpValueName: aString
		lpReserved: nil
		lpType: metadata yourAddress + 4
		lpData: valueBuf
		lpcbData: metadata.
	needsFree ifTrue: [self free].
	^self
		objectFromValue: valueBuf
		type: (metadata uint32AtOffset: 4)
		size: size!

valueAt: aString put: anObject
	"Set the value in the receiver with the <readableString> name, aString, to the <Object>, anObject."

	anObject writeToRegistry: self name: aString.
	^anObject!

valueAt: aString put: anObject type: aSymbol
	"Set the value in the receiver with the <readableString> name, aString, to the <Object>, anObject, with the registry type named by the <Symbol>, aSymbol."

	| value |
	"Special case: If nil'ing the default value, remove it."
	(aString isNil and: [aSymbol == #none])
		ifTrue: 
			[self removeSubValue: nil ifAbsent: nil.
			^anObject].
	value := (#(#string #expandString #stringArray) identityIncludes: aSymbol)
				ifTrue: 
					["The string should include a terminating null after each element. The double terminating null is provided by the strings implicit null, which #byteSize accounts for."
					anObject asUtf16String]
				ifFalse: [anObject].
	"The size is always specified in bytes"
	self
		basicValueAt: aString
		put: value
		type: (ValueTypes at: aSymbol)
		size: value byteSize.
	^anObject!

writeCollection: aCollection at: aString
	self requiresSerializer! !
!OS.RegKeyAbstract categoriesForMethods!
=!comparing!public! !
add:!adding!public! !
asParameter!converting!public! !
associationAt:ifAbsent:!accessing!public! !
associationsDo:!enumerating!public! !
at:ifAbsent:!accessing!public! !
at:put:!accessing!public! !
basicFree!private!realizing/unrealizing! !
basicObjectAt:put:!public! !
basicValueAt:put:type:size:!accessing!public! !
binaryAt:put:!accessing!public! !
bytesAt:put:as:!public!serializing! !
copyingClass!copying!private! !
createKey:!adding!public! !
displayOn:!displaying!public! !
do:!enumerating!public! !
dwordAt:put:!accessing!public! !
fileOutOn:!public!storing! !
free!public!realizing/unrealizing! !
fullPath!accessing!public! !
handle!accessing!public! !
handle:!accessing!private! !
hash!comparing!public! !
includesKey:!public!searching! !
isRoot!public!testing! !
isWriteable!public!testing! !
key!accessing!public! !
key:!accessing!public! !
keyInfo!accessing!public! !
keysAndValuesDo:!enumerating!public! !
keysDo:!enumerating!public! !
lookup:!accessing!public! !
mode:!accessing!public! !
name!accessing!public! !
name:!initializing!private! !
newSubKey:sam:!helpers!private! !
noneAtPut:!accessing!public! !
objectFromValue:type:size:!helpers!private! !
parentKey!accessing!public! !
parentPath!accessing!public! !
parentPath:!initializing!private! !
pathFromRoot!accessing!public! !
postCopy!copying!public! !
printOn:!printing!public! !
queryKeyInfo!accessing!private! !
qwordAt:put:!accessing!public! !
realize!public!realizing/unrealizing! !
removeAssociationAt:ifAbsent:!public!removing! !
removeKey:ifAbsent:!public!removing! !
removeSubKey:ifAbsent:!public!removing! !
removeSubTree:!public!removing! !
removeSubTree:ifAbsent:!public!removing! !
removeSubValue:ifAbsent:!public!removing! !
requiresSerializer!public! !
resize:!mutating!private! !
rootHandle!accessing!public! !
rootKey!accessing!public! !
rootKey:!initializing!private! !
sam!accessing!public! !
sam:!accessing!public! !
setSam:!initializing!private! !
shrink!mutating!public! !
size!initializing!public! !
splitPath:!helpers!private! !
stringArrayAt:put:!accessing!public! !
stringAt:put:!accessing!public! !
subKeyNamesDo:!enumerating!private! !
subKeys!accessing!public! !
subValueNames!enumerating!public! !
subValueNamesAndValuesDo:!enumerating!public! !
subValueNamesDo:!enumerating!public! !
subValues!accessing!public! !
value!accessing!public! !
value:!accessing!public! !
valueAt:!accessing!public! !
valueAt:ifAbsent:!accessing!public! !
valueAt:put:!accessing!public! !
valueAt:put:type:!accessing!public! !
writeCollection:at:!public! !
!

OS.RegKeyAbstract methodProtocol: #association attributes: #(#ansi #readOnly) selectors: #(#key #key: #value #value:)!

!OS.RegKeyAbstract class methodsFor!

classesRoot
	"Answer a new instance of the receiver, rooted in HKEY_CLASSES_ROOT."

	^self
		hive: 'HKEY_CLASSES_ROOT'
		handle: HKEY_CLASSES_ROOT
		sam: KEY_READ!

classesRoot: aSymbol
	"Answer a new instance of the receiver, rooted in HKEY_CLASSES_ROOT, with the access rights specified by the <Symbol>, mode."

	^self
		hive: 'HKEY_CLASSES_ROOT'
		handle: HKEY_CLASSES_ROOT
		mode: aSymbol!

configRoot
	"Answer a new instance of the receiver, rooted in HKEY_CURRENT_CONFIG"

	^self
		hive: 'HKEY_CURRENT_CONFIG'
		handle: HKEY_CURRENT_CONFIG
		sam: KEY_READ!

decodeMultiSz: aByteArray size: anInteger
	"Private - Decode a REG_MULTISZ format registry value to an <Array> of <String> from a contiguous sequence of null-terminated UTF-16 strings that are terminated by two null characters.
	The Microsoft documentation is careful to point out that it should not be assumed that the value is correctly terminated with two nulls, so our implementation produces the same result whether there are one or two final nulls."

	| multisz strings byteSize |
	byteSize := anInteger - 2.
	multisz := Utf16String new: (byteSize bitShift: -1).
	aByteArray
		replaceBytesOf: multisz
		from: 1
		to: byteSize
		startingAt: 1.
	multisz := ReadStream on: multisz.
	strings := WriteStream on: (Array new: 2).
	[multisz atEnd] whileFalse: [strings nextPut: (multisz basicUpTo: $\0)].
	^strings grabContents!

defaultMode
	"Answer the default security access rights requested on registry keys."

	#deprecated.
	^#readWrite!

encodeMultiSz: aCollection
	"Private - Encode a collection in REG_MULTISZ registry format, i.e. a Utf16String composed from the displayStrings of the objects in the collection, separated by nulls. The string is terminated by two nulls (one of which is the implict null in the string that is not visible at the Smalltalk level)."

	| stream |
	stream := WriteStream on: (Utf16String new: 16).
	aCollection do: 
			[:each |
			each displayOn: stream.
			stream nextPut: $\0].
	^stream contents!

fromPredefinedKey: aString
	"Answer a new instance of the receiver, rooted in the specified root (predefined) key, one of HKEY_CLASSES_ROOT, HKEY_CURRENT_CONFIG, HKEY_CURRENT_USER, HKEY_LOCAL_MACHINE, HKEY_PERFORMANCE_DATA, or HKEY_USERS."

	#deprecated.
	^self fromPredefinedKey: aString mode: self defaultMode!

fromPredefinedKey: aString mode: aSymbol
	"Answer a new instance of the receiver, rooted in the specified root, predefined key."

	#deprecated.
	^self
		hive: aString
		handle: (WinRegConstants at: aString)
		sam: (AccessModes at: aSymbol)!

hive: aString handle: hiveInteger mode: aSymbol
	^self
		hive: aString
		handle: hiveInteger
		sam: (AccessModes at: aSymbol)!

hive: aString handle: hiveInteger sam: samInteger
	| rootKey |
	rootKey := RegKey new.
	^rootKey
		name: aString;
		rootKey: rootKey;
		setSam: samInteger;
		handle: hiveInteger;
		yourself!

icon
	"Answers an Icon that can be used to represent this class."

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		RegKeyAbstract initialize
	"

	AccessModes := ##((IdentityDictionary withAll: {#read -> KEY_READ.
						#readWrite -> (KEY_READ | KEY_WRITE).
						#all -> KEY_ALL_ACCESS.
						#write -> KEY_WRITE.
						#execute -> KEY_EXECUTE})
				isImmutable: true;
				yourself).
	"We retain the DWORD/QWORD terminology here, because these are the registry types"
	ValueTypes := ##((IdentityDictionary withAll: {#string -> REG_SZ.
						#dword -> REG_DWORD.
						#stringArray -> REG_MULTI_SZ.
						#qword -> REG_QWORD.
						#binary -> REG_BINARY.
						#expandString -> REG_EXPAND_SZ.
						#none -> REG_NONE})
				isImmutable: true;
				yourself).
	self addClassConstant: 'PathSeparator' value: '\' asUtf16String!

localMachineRoot
	"Answer a new instance of the receiver, rooted in HKEY_LOCAL_MACHINE, opened in #read mode (admin priviledges are required to open this key so #readWrite does not make sense as as default)."

	^self
		hive: 'HKEY_LOCAL_MACHINE'
		handle: HKEY_LOCAL_MACHINE
		sam: KEY_READ!

localMachineRoot: aSymbol
	"Answer a new instance of the receiver, rooted in HKEY_LOCAL_MACHINE"

	^self
		hive: 'HKEY_LOCAL_MACHINE'
		handle: HKEY_LOCAL_MACHINE
		mode: aSymbol!

myComputer
	"Answer a new instance of the receiver, rooted in this computers
	registry."

	^Error notYetImplemented!

new
	"Answer a new uninitialized instance of the receiver."

	^self basicNew: 0!

roots
	"Answer an array of the predefined registry roots."

	^{self classesRoot. self userRoot. self localMachineRoot. self usersRoot. self configRoot}!

tally: anInteger name: keyString parentPath: rootKeyString rootKey: aRegKey sam: samDesired
	"Private - Answer a new instance of the receiver initialized with the arguments."

	<primitive: 157>
	^self new
		name: keyString;
		parentPath: rootKeyString;
		rootKey: aRegKey;
		setSam: samDesired;
		yourself!

userRoot
	"Answer a new instance of the receiver, rooted in HKEY_CURRENT_USER. Should almost always have write access to this key."

	^self
		hive: 'HKEY_CURRENT_USER'
		handle: HKEY_CURRENT_USER
		sam: ##(KEY_READ | KEY_WRITE)!

usersRoot
	"Answer a new instance of the receiver, rooted in HKEY_USERS"

	^self
		hive: 'HKEY_USERS'
		handle: HKEY_USERS
		sam: KEY_READ!

usersRoot: aSymbol
	"Answer a new instance of the receiver, rooted in HKEY_USERS"

	^self
		hive: 'HKEY_USERS'
		handle: HKEY_USERS
		mode: aSymbol! !
!OS.RegKeyAbstract class categoriesForMethods!
classesRoot!instance creation!public! !
classesRoot:!instance creation!public! !
configRoot!instance creation!public! !
decodeMultiSz:size:!helpers!private! !
defaultMode!constants!public! !
encodeMultiSz:!helpers!private! !
fromPredefinedKey:!instance creation!public! !
fromPredefinedKey:mode:!instance creation!public! !
hive:handle:mode:!instance creation!public! !
hive:handle:sam:!instance creation!private! !
icon!constants!public! !
initialize!development!initializing!private! !
localMachineRoot!instance creation!public! !
localMachineRoot:!instance creation!public! !
myComputer!instance creation!public! !
new!instance creation!public! !
roots!instance creation!public! !
tally:name:parentPath:rootKey:sam:!instance creation!private! !
userRoot!instance creation!public! !
usersRoot!instance creation!public! !
usersRoot:!instance creation!public! !
!


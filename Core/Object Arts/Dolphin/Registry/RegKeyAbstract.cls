"Filed out from Dolphin Smalltalk 7"!

Dictionary variableSubclass: #RegKeyAbstract
	instanceVariableNames: 'handle name rootKey parentPath keyInfo sam'
	classVariableNames: 'AccessModes ValueTypes'
	poolDictionaries: 'Win32Errors WinRegConstants'
	classInstanceVariableNames: ''!
RegKeyAbstract guid: (GUID fromString: '{87b4c52b-026e-11d3-9fd7-00a0cc3e4a32}')!
RegKeyAbstract comment: ''!
!RegKeyAbstract categoriesForClass!System-Support! !
!RegKeyAbstract methodsFor!

= comperand
	"Answer whether the receiver is considered equivalent to the argument."

	#todo "Generating the full path is a bit expensive, so maybe break down and compare root handle, path from root, and name - same applies to #hash".
	^self species == comperand species and: [
		self fullPath = comperand fullPath]!

add: anAssociation
	"Add anAssociation to the receiver. Answer anAssociation. As we are only
	simulating a <Dictionary>, we do not actually store <Association>s, therefore we must 
	reimplement this in terms of #at:put:."

	self at: anAssociation key put: anAssociation value.
	^anAssociation!

asParameter
	"Answer the receiver in a form suitable for passing to an external function
	primitive method (see ExternalLibrary and subclasses)."

	self realize.
	^handle!

associationAt: key ifAbsent: exceptionHandler
	"Answer a new <association> between the key and value of
	the receiver at the argument, key.  If key is not found, answer the
	result of evaluating the <niladicValuable>, exceptionHandler."

	^self at: key ifAbsent: [^exceptionHandler value]!

associationsDo: operation
	"Evaluate the monadic valuable, operation, for each of the receiver's 
	key/value associations.
	Implemenation Note: We must override because the receiver does not 
	actually contain Associations."

	self keysAndValuesDo: [:k :v | 
		operation value: (self associationClass key: k value: v)]!

at: key ifAbsent: exceptionHandler
	"Answer the value named by the <readableString> argument, key. If the
	key is is not found answer the result of evaluating the <niladicValuable>, 
	exceptionHandler.
	May also raise a Win32Error exception if registry access fails for some
	reason."

	^self subclassResponsibility!

at: key put: anObject
	"Store the argument anObject with the <readableString> external key, key,
	in the receiver. Answer anObject"

	^self subclassResponsibility!

basicFree
	"Private - Release external resources held by the receiver.
	The receiver is invalid after this call.
	N.B. Any errors closing the handle are ignored."

	^self registryLibrary regCloseKey: handle!

basicRealize
	"Private - Open the receiver's associated registry key."

	| dwErr |
	handle := ExternalHandle new.
	dwErr := self registryLibrary
		regOpenKeyEx: self rootKey asParameter
			lpSubKey: self pathFromRoot
			ulOptions: 0
			samDesired: self sam
			phkResult: handle.
	^dwErr = ERROR_SUCCESS 
		ifTrue: [handle]
		ifFalse: [
			dwErr == ERROR_FILE_NOT_FOUND 
				ifTrue: [self errorNotFound: self]
				ifFalse: [self registryLibrary systemError: dwErr]]!

createKey: subPath
	"Create or open a registry key under the receiver with the specified
	<string> relative path from here (note that this implies that more than one level can
	be created at once, and this is indeed the case!!). Answers the new key."

	| subKey |
	subKey := self privateCreateKey: subPath.
	subKey free.
	^subKey!

displayOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream display: name!

do: operation
	"Evaluate monadic value argument, operation, for each of the element of the 
	receiver. Answer the receiver."

	self keysAndValuesDo: [:k :v | operation value: v]!

fileOutOn: stream
	"File out the receiver in the regedit text representation to the <puttableStream> argument, stream."

	^self subclassResponsibility!

free
	"Release external resources held by the receiver.
	The receiver is still valid after this call."

	self isRoot ifFalse: [
		self basicFree. 
		handle := nil]!

fullPath
	"Answer the full path to the receiver."

	^self isRoot
		ifTrue: [name]
		ifFalse: [rootKey name, '\', self pathFromRoot]!

handle
	"Answer the value of the receiver's instance variable handle.
	This method was automatically generated, but may be modified."

	^handle!

handle: aRegistryKeyHandle
	"Private - Set the receiver's handle to the specified registry
	key handle (either one of the predefined HKEY_XX constants,
	or a handle returned from RegOpenKeyEx())"

	handle := aRegistryKeyHandle!

hash
	"Answer the positive <integer> hash value for the receiver."

	^self fullPath hash!

includesKey: key
	"Answer whether the receiver has a key equal to the <readableString> 
	argument, key."

	^self subclassResponsibility!

isRoot
	"Answer whether the receiver is a root key."

	^handle = rootKey handle!

key
	"Answer the lookup key of the receiver."

	^self name!

key: newName
	"Set the lookup key of the receiver to the <readableString>, newName."

	#todo "Implement registry key renaming".
	^Error notYetImplemented!

keyInfo
	"Answer the value of the receiver's instance variable info."

	keyInfo isNil ifTrue: [keyInfo := self queryKeyInfo].
	^keyInfo!

keysAndValuesDo: operation 
	"Evaluate the <dyadicValuable>, operation, for each key/value pair in the receiver."

	^self subclassResponsibility!

keysDo: operation
	"Evaluate the <monadicValuable>, operation, for each of the receiver's sub-keys."

	^self subclassResponsibility!

lookup: keyObject
	"Answer the value named by the <Object> argument, keyObject, or nil if there is no such key in the receiver."

	^self at: keyObject ifAbsent: []!

mode: modeSymbol
	"Set the access mode required of the receiver, e.g. #readWrite, or #read."

	self sam: (AccessModes at: modeSymbol)
!

name
	"Answer the value of the receiver's instance variable name.
	This method was automatically generated, but may be modified."

	^name!

name: keyString parentPath: rootKeyString rootKey: aRegKey sam: samDesired
	"Private - Initialize the receiver's identity instance variables."

	name := keyString.
	parentPath := rootKeyString.
	rootKey := aRegKey.
	sam := samDesired!

newSubKey: aString sam: anInteger 
	| path splits |
	path := self pathFromRoot.
	splits := self splitPath: (path isEmpty ifTrue: [aString] ifFalse: [(path copyWith: $\) , aString]).
	^self subKeyClass 
		name: (splits at: 2)
		parentPath: (splits at: 1)
		rootKey: self rootKey
		sam: anInteger!

objectFromValue: bytes type: type size: size 
	"Private - Instantiate an appropriate object to represent the registry value with the
	specified type, content, and size."

	type == REG_SZ 
		ifTrue: 
			[^bytes 
				copy: String
				from: 1
				to: (size - 1 max: 0)].
	type == REG_DWORD ifTrue: [^bytes sdwordAtOffset: 0].
	type == REG_BINARY ifTrue: [^bytes copyFrom: 1 to: size].
	type == REG_MULTI_SZ 
		ifTrue: 
			["Array of null-terminated strings that are terminated by two null characters."
			| stream strings len |
			stream := bytes readStream.
			strings := OrderedCollection new.
			len := size - 1.	"Allow for extra null"
			[stream position >= len] whileFalse: [strings add: (stream upTo: 0) asString].
			^strings asArray].
	type == REG_NONE ifTrue: [^nil].
	type == REG_EXPAND_SZ 
		ifTrue: 
			[^KernelLibrary default expandEnvironmentStrings: (bytes 
						copy: String
						from: 1
						to: (size - 1 max: 0))].
	type == REG_QWORD ifTrue: [^bytes sqwordAtOffset: 0].
	Notification signal: 'Unrecognised registry value type treated as binary: ' , type printString.
	^bytes copyFrom: 1 to: size!

parentKey
	"Answer the parent key of the receiver, or nil if at a root."

	| path splits |
	self isRoot ifTrue: [^nil].
	path := self parentPath.
	path isEmpty ifTrue: [^self rootKey].
	splits := self splitPath: path.
	^self subKeyClass 
		name: (splits at: 2)
		parentPath: (splits at: 1)
		rootKey: self rootKey
		sam: self sam!

parentPath
	"Answer the value of the receiver's instance variable parentPath.
	This method was automatically generated, but may be modified."

	^parentPath!

pathFromRoot
	"Answer the full path to the receiver from the root key (N.B. doesn't include the hive such
	as HKEY_CLASSES_ROOT)."

	^self isRoot 
		ifTrue: ['']
		ifFalse: [parentPath isEmpty ifTrue: [name] ifFalse: [(parentPath copyWith: $\) , name]]!

postCopy
	"Apply any final flourish to the copy that may be required in order to ensure that the copy
	does not share any state with the original, apart from the elements."

	"Implementation note: We don't want to inherit the Dictionary implementation as this is a
	proxy for the registry."

	^self!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream 
		basicPrint: self; 
		nextPut: $(;
		nextPutAll: (handle isNil ifTrue: ['NULL'] ifFalse: [handle asInteger printStringRadix: 16]);
		nextPutAll: ' - ';
		print: self fullPath;
		nextPut: $)!

privateCreateKey: aString 
	"Private - Create or open a registry key under the receiver with the specified relative path
	from here (note that this implies that more than one level can be created at once, and this
	is indeed the case!!). Answers the new key. N.B. The new key is still open at this time, and
	MUST be freed."

	| subKey dwErr rights |
	subKey := ExternalHandle new.
	rights := self sam.
	dwErr := self registryLibrary 
				regCreateKeyEx: self asParameter
				lpSubKey: aString
				reserved: nil
				lpClass: ''
				dwOptions: REG_OPTION_NON_VOLATILE
				samDesired: self sam
				lpSecurityAttributes: nil
				phkResult: subKey
				lpdwDisposition: nil.
	dwErr == ERROR_SUCCESS ifFalse: [^Win32Error signalWith: dwErr].
	keyInfo := nil.	"keyInfo invalidated"
	self free.
	^(self newSubKey: aString sam: rights)
		handle: subKey;
		yourself!

queryKeyInfo
	"Answer a bunch of information about the receiver."

	| "classString cbClass" cSubKeys cbMaxSubKeyLen "cbMaxClassLen" cValues cbMaxValueNameLen
	cbMaxValueLen "cbSecurityDescriptor" ftLastWriteTime dwErr prevHandle |

	"classString := String new: 256.
	cbClass := DWORDBytes fromInteger: classString basicSize."

	cSubKeys := DWORDBytes new.
	cbMaxSubKeyLen := DWORDBytes new.
	"cbMaxClassLen := DWORDBytes new."
	cbMaxSubKeyLen := DWORDBytes new.
	cbMaxSubKeyLen := DWORDBytes new.
	cValues := DWORDBytes new.
	cbMaxValueNameLen := DWORDBytes new.
	cbMaxValueLen := DWORDBytes new.
	"cbSecurityDescriptor := DWORDBytes new."
	ftLastWriteTime := FILETIME new.

	prevHandle := self handle.

	dwErr := ERROR_SUCCESS.
	[dwErr := self registryLibrary regQueryInfoKey: self asParameter
		lpClass: nil"classString"
		lpcbClass: nil"cbClass "
		lpReserved: nil
		lpcSubKeys: cSubKeys
		lpcbMaxSubKeyLen: cbMaxSubKeyLen
		lpcbMaxClassLen: nil"cbMaxClassLen"
		lpcValues: cValues
		lpcbMaxValueNameLen: cbMaxValueNameLen
		lpcbMaxValueLen: cbMaxValueLen
		lpcbSecurityDescriptor: nil"cbSecurityDescriptor"
		lpftLastWriteTime: ftLastWriteTime]
	on: Win32Error do: [:e |
		e tag = ERROR_ACCESS_DENIED 
			ifTrue: [e notify]
			ifFalse: [e pass]]
	on: NotFoundError do: [:e | e notify].

	dwErr = ERROR_SUCCESS
		ifFalse: [^self registryLibrary systemError: dwErr].

	"We avoid keeping the key open just to query the info ..."
	prevHandle isNil ifTrue: [self free].

	"Why on earth isn't all this in a structure?"
	^RegQueryInfo new
		"keyClass: (classString copyFrom: 1 to: cbClass asInteger);"
		subKeyCount: cSubKeys asInteger;
		maxSubKeyLen: cbMaxSubKeyLen asInteger;
		"maxClassNameLen: cbMaxClassLen asInteger;"
		valueCount: cValues asInteger;
		maxValueNameLen: cbMaxValueNameLen asInteger;
		maxValueLen: cbMaxValueLen asInteger;
		"securityDescriptorLen: cbSecurityDescriptor asInteger;"
		lastWriteTime: ftLastWriteTime!

realize
	"Realize (create) the external resource associated with the receiver,
	but only if not already realized."

	handle isNil ifTrue: [self basicRealize]!

registryLibrary
	"Private - Answer the host system shared DLL used
	to access the registry."

	^AdvApiLibrary default!

removeKey: key ifAbsent: exceptionHandler
	"Remove the key (and its associated value), from the receiver. If key is
	not in the receiver, answer the result of evaluating the <niladicValuable>,
	exceptionHandler. Otherwise, answer the value named by key."

	^self subclassResponsibility!

removeSubKey: aString ifAbsent: exceptionHandler
	"Remove the specified sub-key of the receiver.
	N.B. This behaves differently between NT and 95: On the former this fails
	if the key has sub-keys, on the latter all the sub-keys are deleted too."

	| dwErr |
	dwErr := self registryLibrary
		regDeleteKey: self asParameter
		lpSubKey: aString.
	self free.
	^dwErr = ERROR_SUCCESS
		ifTrue: [aString]
		ifFalse: [
			dwErr = ERROR_FILE_NOT_FOUND
				ifTrue: [exceptionHandler value]
				ifFalse: [self registryLibrary systemError: dwErr]]!

removeSubTree: aString ifAbsent: exceptionHandler
	"Recursively remove the specified sub-tree of the receiver."

	| subKey |
	aString isNil ifTrue: [^exceptionHandler value].
	subKey := self at: aString ifAbsent: [^exceptionHandler value].
	subKey keys do: [:s | subKey removeSubTree: s ifAbsent: []].
	self removeSubKey: aString ifAbsent: exceptionHandler.
	^subKey!

removeSubValue: aString ifAbsent: exceptionHandler
	"Remove the specified sub-value of the receiver."

	| dwErr |
	dwErr := self registryLibrary
		regDeleteValue: self asParameter
		lpValueName: aString.
	self free.
	^dwErr = ERROR_SUCCESS
		ifTrue: [aString]
		ifFalse: [
			dwErr = ERROR_FILE_NOT_FOUND
				ifTrue: [exceptionHandler value]
				ifFalse: [self registryLibrary systemError: dwErr]]!

resize: anInteger
	"Private - Resize the receiver to have a capacity suitable for accomodating
	at least anInteger elements. Answer the receiver (resized). The receiver is
	rehashed regardless of whether it is already of the correct capacity (this
	is important).

	The Registry is an external dictionary, and it isn't really our business to be
	maintaining its internal structure!!"

	^self
!

rootHandle
	"Answer the handle of the receiver's registry hive."

	^rootKey handle!

rootKey
	"Answer the value of the receiver's instance variable rootKey.
	This method was automatically generated, but may be modified."

	^rootKey!

sam
	"Answer an <Integer> representing the receiver's access right flags."

	^sam!

sam: anInteger
	"Set the security access mode to the argument. This controls what security rights
	are requested when opening the key. If the user does not have significant priviledges
	for the requested rights, then an error will be raised when an attempt is made to
	use the receiver."

	sam = anInteger ifFalse: [
		"SAM is being changed, need to reopen"
		sam := anInteger.
		self free]!

shrink
	"Rebuild the collection with the optimal size for its current number of elements.
	The Registry is an external dictionary, and it isn't really our business to be
	maintaining its internal structure!!"

	^self!

size
	"Answer the number of elements in the receiver."

	^self subclassResponsibility!

species
	"Answer the class of object to be used when copying the receiver. 
	We override to answer <Dictionary>, since any collection of registry keys
	constructed by select:/collect: &c is no longer directly related to the actual
	registry hierarchy."

	^Dictionary!

splitPath: path 
	| stem lastSlash superPath |
	lastSlash := path lastIndexOf: $\.
	lastSlash == 0 
		ifTrue: 
			[superPath := ''.
			stem := path]
		ifFalse: 
			[superPath := path leftString: lastSlash - 1.
			stem := path rightString: path size - lastSlash].
	^Array with: superPath with: stem!

subKeyClass
	"Private - Answer the class of association to be used for holding
	key-value pairs in the receiver. Must respond to the Association protocol."
	
	^RegKey!

subKeyNamesDo: operation
	"Private - Evaluate the monadic valuable, operation, for each of the receiver's sub-keys."

	| maxSize i lib keyName dwErr cbName hKey |
	hKey := self asParameter.	"ensure realized at start so not closed by queryKeyInfo"
	maxSize := self keyInfo maxSubKeyLen+1.
	i := 0.
	keyName := String new: maxSize.
	cbName := DWORDBytes new.
	lib := self registryLibrary.
	[
		[cbName value: maxSize+1.
		(dwErr := lib
	        		regEnumKeyEx: hKey
			dwIndex: i
			lpName: keyName
			lpcbName: cbName
			lpReserved: nil
			lpClass: nil
			lpcbClass: nil
			lpftLastWriteTime: nil) = 16rEA] whileTrue: [
				maxSize := maxSize bitShift: 1.
				keyName resize: maxSize].
		dwErr = ERROR_SUCCESS]
        whileTrue: [
		operation value: (keyName copyFrom: 1 to: cbName asInteger).
		i := i + 1].
	self free.
	dwErr = ERROR_NO_MORE_ITEMS 
		ifFalse: [^self registryLibrary systemError: dwErr].!

subKeys
	"Answer the collection of sub-keys under the receiver (a RegKey)."

	^self subclassResponsibility!

subValueClass
	"Private - Answer the class of association to be used for holding
	key-value pairs in the receiver. Must respond to the Association protocol."
	
	^RegKeyValues!

subValueNamesAndValuesDo: operation
	"Evaluate the dyadic valuable, operation, for each of the receiver's
	sub-values, passing its name and an object corresponding to the
	registry entry as the first and second arguments respectively."

	|  valueName i lib cbValueName dwErr maxNameSize maxDataSize info data cbData type hKey |
	i := 0.
	hKey := self asParameter.
	info := self keyInfo.
	maxNameSize := info maxValueNameLen.
	maxDataSize := info maxValueLen.
	valueName := String new: maxNameSize.					"Strings automatically include space for null-term"
	data := ByteArray new: maxDataSize.
	cbValueName := DWORDBytes new.
	cbData := DWORDBytes new.
	type := DWORDBytes new.
	lib := self registryLibrary.
	[
		cbValueName value: maxNameSize +1.					"must include Null terminator"
		cbData value: maxDataSize.
		dwErr := (lib
				regEnumValue: hKey
				dwIndex: i
				lpValueName: valueName
				lpcbValueName: cbValueName
				lpReserved: nil 
				lpType: type 
				lpData: data 
				lpcbData: cbData).
		dwErr = ERROR_SUCCESS]
        whileTrue: [
		operation 
			value: (valueName copyFrom: 1 to: cbValueName asInteger)
			value: (self objectFromValue: data type: type asInteger size: cbData asInteger).
		i := i + 1].
	self free.
	dwErr = ERROR_NO_MORE_ITEMS
		ifFalse: [lib systemError: dwErr]!

subValueNamesDo: operation
	"Evaluate the monadic valuable, operation, for each of the receiver's
	value names."

	|  valueName i lib cbValueName dwErr maxSize hKey |
	i := 0.
	hKey := self asParameter.
	maxSize := self keyInfo maxValueNameLen.
	valueName := String new: maxSize.					"Strings automatically include space for null-term"
	cbValueName := DWORDBytes new.	
	lib := self registryLibrary.
	[
		cbValueName value: maxSize +1.					"must include Null terminator"
		dwErr := (lib
				regEnumValue: hKey
				dwIndex: i
				lpValueName: valueName
				lpcbValueName: cbValueName
				lpReserved: nil 
				lpType: nil 
				lpData: nil 
				lpcbData: nil).
		dwErr = ERROR_SUCCESS]
        whileTrue: [
		operation value: (valueName copyFrom: 1 to: cbValueName asInteger).
		i := i + 1].
	self free.
	dwErr = ERROR_NO_MORE_ITEMS
		ifFalse: [lib systemError: dwErr].
!

subValues
	"Answer the collection of sub-values under the receiver (a RegKeyValues)."

	^self subclassResponsibility!

value
	"Answer the default value for the receiver, or nil if none."

	^self valueAt: '' ifAbsent: []!

value: aValue
	"Set the default value of the receiver to the registry compatible 
	<Object>, aValue."

	self valueAt: '' put: aValue!

valueAt: key
	"Answer the registry value subordinate to the receiver named by the 
	<readableString> argument, key.  If the named value is not found,
	then raise a NotFoundError. May also raise a Win32Error exception if 
	registry access fails for some other reason."

	^self valueAt: key ifAbsent: [self errorNotFound: key]!

valueAt: key ifAbsent: exceptionHandler 
	"Answer the value named by the argument, key.  If keyString is not found,
	answer the result of evaluating the niladic valuable, exceptionHandler.
	May raise a Win32Error exception if registry access fails for some
	reason."

	| size type valueBuf dwErr hKey |
	type := DWORDBytes new.
	hKey := self asParameter.
	size := self keyInfo maxValueLen.
	valueBuf := ByteArray newFixed: size.
	size := DWORDBytes fromInteger: size.
	dwErr := self registryLibrary 
				regQueryValueEx: hKey
				lpValueName: key
				lpReserved: nil
				lpType: type
				lpData: valueBuf
				lpcbData: size.
	self free.
	^dwErr = ERROR_SUCCESS 
		ifTrue: 
			[self 
				objectFromValue: valueBuf
				type: type asInteger
				size: size asInteger]
		ifFalse: 
			[dwErr = ERROR_FILE_NOT_FOUND 
				ifTrue: [exceptionHandler value]
				ifFalse: [self registryLibrary systemError: dwErr]]!

valueAt: aString put: anObject 
	"Set the value in the receiver with the <readableString> name, aString, to the <Object>,
	anObject."

	| assoc |
	assoc := self valueFromObject: anObject.
	self 
		valueAt: aString
		put: assoc value
		type: assoc key.
	^anObject!

valueAt: aString put: anObject type: aSymbol 
	| size result info |
	(aString isNil and: [aSymbol == #none]) 
		ifTrue: 
			[self removeSubValue: aString ifAbsent: [].
			^anObject].
	size := anObject byteSize.
	result := AdvApiLibrary default 
				regSetValueEx: self asParameter
				lpValueName: aString
				reserved: 0
				dwType: (ValueTypes at: aSymbol)
				lpData: anObject
				cbData: size.
	result == ERROR_SUCCESS ifFalse: [^Win32Error signalWith: result].
	info := self keyInfo.
	size > info maxValueLen ifTrue: [info maxValueLen: size].
	^anObject!

valueFromObject: value
	"Private - This is nasty, but we don't want to modify the base classes to support a
	conversion function..."

	value isNil ifTrue: [^#none -> #[]].
	value isInteger
		ifTrue: 
			[(value between: ##(-2 ** 31) and: ##(2 ** 31 - 1))
				ifTrue: [^#dword -> (DWORD fromInteger: value)]
				ifFalse: 
					[(value between: ##(-2 ** 63) and: ##(2 ** 63 - 1))
						ifTrue: [^#qword -> (LARGE_INTEGER fromInteger: value)]]].
	(value isKindOf: String) ifTrue: [^#string -> value].
	(value isKindOf: Array)
		ifTrue: 
			["Assume its an array of strings"
			| stream |
			stream := String writeStream.
			value do: 
					[:each |
					stream
						display: each;
						nextPut: Character null].
			^#stringArray -> stream contents].
	^#binary -> value asByteArray! !
!RegKeyAbstract categoriesFor: #=!comparing!public! !
!RegKeyAbstract categoriesFor: #add:!adding!public! !
!RegKeyAbstract categoriesFor: #asParameter!converting!public! !
!RegKeyAbstract categoriesFor: #associationAt:ifAbsent:!accessing!public! !
!RegKeyAbstract categoriesFor: #associationsDo:!enumerating!public! !
!RegKeyAbstract categoriesFor: #at:ifAbsent:!accessing!public! !
!RegKeyAbstract categoriesFor: #at:put:!accessing!public! !
!RegKeyAbstract categoriesFor: #basicFree!private!realizing/unrealizing! !
!RegKeyAbstract categoriesFor: #basicRealize!private!realizing/unrealizing! !
!RegKeyAbstract categoriesFor: #createKey:!adding!public! !
!RegKeyAbstract categoriesFor: #displayOn:!displaying!public! !
!RegKeyAbstract categoriesFor: #do:!enumerating!public! !
!RegKeyAbstract categoriesFor: #fileOutOn:!public!source filing! !
!RegKeyAbstract categoriesFor: #free!public!realizing/unrealizing! !
!RegKeyAbstract categoriesFor: #fullPath!accessing!public! !
!RegKeyAbstract categoriesFor: #handle!accessing!public! !
!RegKeyAbstract categoriesFor: #handle:!accessing!private! !
!RegKeyAbstract categoriesFor: #hash!comparing!public! !
!RegKeyAbstract categoriesFor: #includesKey:!public!searching! !
!RegKeyAbstract categoriesFor: #isRoot!public!testing! !
!RegKeyAbstract categoriesFor: #key!accessing!public! !
!RegKeyAbstract categoriesFor: #key:!accessing!public! !
!RegKeyAbstract categoriesFor: #keyInfo!accessing!public! !
!RegKeyAbstract categoriesFor: #keysAndValuesDo:!enumerating!public! !
!RegKeyAbstract categoriesFor: #keysDo:!enumerating!public! !
!RegKeyAbstract categoriesFor: #lookup:!accessing!public! !
!RegKeyAbstract categoriesFor: #mode:!accessing!public! !
!RegKeyAbstract categoriesFor: #name!accessing!public! !
!RegKeyAbstract categoriesFor: #name:parentPath:rootKey:sam:!initializing!private! !
!RegKeyAbstract categoriesFor: #newSubKey:sam:!helpers!private! !
!RegKeyAbstract categoriesFor: #objectFromValue:type:size:!helpers!private! !
!RegKeyAbstract categoriesFor: #parentKey!accessing!public! !
!RegKeyAbstract categoriesFor: #parentPath!accessing!public! !
!RegKeyAbstract categoriesFor: #pathFromRoot!accessing!public! !
!RegKeyAbstract categoriesFor: #postCopy!copying!public! !
!RegKeyAbstract categoriesFor: #printOn:!printing!public! !
!RegKeyAbstract categoriesFor: #privateCreateKey:!helpers!private! !
!RegKeyAbstract categoriesFor: #queryKeyInfo!accessing!public! !
!RegKeyAbstract categoriesFor: #realize!public!realizing/unrealizing! !
!RegKeyAbstract categoriesFor: #registryLibrary!constants!private! !
!RegKeyAbstract categoriesFor: #removeKey:ifAbsent:!public!removing! !
!RegKeyAbstract categoriesFor: #removeSubKey:ifAbsent:!public!removing! !
!RegKeyAbstract categoriesFor: #removeSubTree:ifAbsent:!public!removing! !
!RegKeyAbstract categoriesFor: #removeSubValue:ifAbsent:!public!removing! !
!RegKeyAbstract categoriesFor: #resize:!mutating!private! !
!RegKeyAbstract categoriesFor: #rootHandle!accessing!public! !
!RegKeyAbstract categoriesFor: #rootKey!accessing!public! !
!RegKeyAbstract categoriesFor: #sam!accessing!public! !
!RegKeyAbstract categoriesFor: #sam:!accessing!public! !
!RegKeyAbstract categoriesFor: #shrink!mutating!public! !
!RegKeyAbstract categoriesFor: #size!accessing!public! !
!RegKeyAbstract categoriesFor: #species!accessing!public! !
!RegKeyAbstract categoriesFor: #splitPath:!helpers!private! !
!RegKeyAbstract categoriesFor: #subKeyClass!constants!private! !
!RegKeyAbstract categoriesFor: #subKeyNamesDo:!enumerating!private! !
!RegKeyAbstract categoriesFor: #subKeys!accessing!public! !
!RegKeyAbstract categoriesFor: #subValueClass!constants!private! !
!RegKeyAbstract categoriesFor: #subValueNamesAndValuesDo:!enumerating!public! !
!RegKeyAbstract categoriesFor: #subValueNamesDo:!enumerating!public! !
!RegKeyAbstract categoriesFor: #subValues!accessing!public! !
!RegKeyAbstract categoriesFor: #value!accessing!public! !
!RegKeyAbstract categoriesFor: #value:!accessing!public! !
!RegKeyAbstract categoriesFor: #valueAt:!accessing!public! !
!RegKeyAbstract categoriesFor: #valueAt:ifAbsent:!accessing!public! !
!RegKeyAbstract categoriesFor: #valueAt:put:!accessing!public! !
!RegKeyAbstract categoriesFor: #valueAt:put:type:!accessing!public! !
!RegKeyAbstract categoriesFor: #valueFromObject:!helpers!private! !

RegKeyAbstract methodProtocol: #association attributes: #(#ansi #readOnly) selectors: #(#key #key: #value #value:)!

!RegKeyAbstract class methodsFor!

branchClass
	"Answer the class of object to use for branches of the registry tree."

	^RegKey!

classesRoot
	"Answer a new instance of the receiver, rooted in HKEY_CLASSES_ROOT.
	Read/Write should be sufficient for registering new classes."

	^self classesRoot: self defaultMode!

classesRoot: mode
	"Answer a new instance of the receiver, rooted in HKEY_CLASSES_ROOT,
	with the access rights specified by the <Symbol>, mode."

	^self fromPredefinedKey: 'HKEY_CLASSES_ROOT' mode: mode!

configRoot
	"Answer a new instance of the receiver, rooted in HKEY_CURRENT_CONFIG"

	^self fromPredefinedKey: 'HKEY_CURRENT_CONFIG' mode: #read!

defaultMode
	"Answer the default security access rights requested on registry keys."

	^#readWrite!

fromPredefinedKey: key
	"Answer a new instance of the receiver, rooted in the specified root, predefined key."

	^self fromPredefinedKey: key mode: self defaultMode!

fromPredefinedKey: key mode: mode
	"Answer a new instance of the receiver, rooted in the specified root, predefined key."

	^self fromPredefinedKey: key 
		sam: (AccessModes at: mode)!

fromPredefinedKey: key sam: samDesired
	"Private - Answer a new instance of the receiver, rooted in the specified root, predefined key."

	| answer |
	answer := self branchClass new.
	^answer 
		name: key
		parentPath: nil
		rootKey: answer
		sam: samDesired;
		handle: (WinRegConstants at: key);
		yourself!

icon
	"Answers an Icon that can be used to represent this class.
	Use the one from the real Windows Registry Editor for fun."

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		RegKeyAbstract initialize
	"

	AccessModes := ##((IdentityDictionary new)
				at: #read put: KEY_READ;
				at: #all put: KEY_ALL_ACCESS;
				at: #readWrite put: KEY_READ | KEY_WRITE;
				at: #write put: KEY_WRITE;
				at: #execute put: KEY_EXECUTE;
				shrink;
				yourself).
	ValueTypes := ##((IdentityDictionary new)
				at: #dword put: REG_DWORD;
				at: #binary put: REG_BINARY;
				at: #string put: REG_SZ;
				at: #none put: REG_NONE;
				at: #qword put: REG_QWORD;
				at: #stringArray put: REG_MULTI_SZ;
				at: #expandString put: REG_EXPAND_SZ;
				shrink;
				yourself)!

localMachineRoot
	"Answer a new instance of the receiver, rooted in HKEY_LOCAL_MACHINE"

	^self localMachineRoot: self defaultMode!

localMachineRoot: mode
	"Answer a new instance of the receiver, rooted in HKEY_LOCAL_MACHINE"

	^self fromPredefinedKey: 'HKEY_LOCAL_MACHINE' mode: mode!

myComputer
	"Answer a new instance of the receiver, rooted in this computers
	registry."

	^Error notYetImplemented!

name: keyString parentPath: rootKeyString rootKey: aRegKey sam: samDesired
	"Private - Answer a new instance of the receiver initialized
	with the arguments."

	^self new
		name: keyString
		parentPath: rootKeyString
		rootKey: aRegKey
		sam: samDesired!

new
	"Answer a new initialized instance of the receiver."

	^(self basicNew: 0) initialize!

roots
	"Answer an array of the predefined registry roots."

	^Array 
		with: self classesRoot
		with: self userRoot
		with: self localMachineRoot
		with: self usersRoot
		with: self configRoot!

userRoot
	"Answer a new instance of the receiver, rooted in HKEY_CURRENT_USER.
	Should almost always have write access to this key."

	^self fromPredefinedKey: 'HKEY_CURRENT_USER' mode: self defaultMode!

usersRoot
	"Answer a new instance of the receiver, rooted in HKEY_USERS"

	^self usersRoot: #read!

usersRoot: mode
	"Answer a new instance of the receiver, rooted in HKEY_USERS"

	^self fromPredefinedKey: 'HKEY_USERS' mode: mode! !
!RegKeyAbstract class categoriesFor: #branchClass!constants!public! !
!RegKeyAbstract class categoriesFor: #classesRoot!instance creation!public! !
!RegKeyAbstract class categoriesFor: #classesRoot:!instance creation!public! !
!RegKeyAbstract class categoriesFor: #configRoot!instance creation!public! !
!RegKeyAbstract class categoriesFor: #defaultMode!constants!public! !
!RegKeyAbstract class categoriesFor: #fromPredefinedKey:!instance creation!public! !
!RegKeyAbstract class categoriesFor: #fromPredefinedKey:mode:!instance creation!public! !
!RegKeyAbstract class categoriesFor: #fromPredefinedKey:sam:!instance creation!private! !
!RegKeyAbstract class categoriesFor: #icon!constants!public! !
!RegKeyAbstract class categoriesFor: #initialize!development!initializing!private! !
!RegKeyAbstract class categoriesFor: #localMachineRoot!instance creation!public! !
!RegKeyAbstract class categoriesFor: #localMachineRoot:!instance creation!public! !
!RegKeyAbstract class categoriesFor: #myComputer!instance creation!public! !
!RegKeyAbstract class categoriesFor: #name:parentPath:rootKey:sam:!instance creation!private! !
!RegKeyAbstract class categoriesFor: #new!instance creation!public! !
!RegKeyAbstract class categoriesFor: #roots!instance creation!public! !
!RegKeyAbstract class categoriesFor: #userRoot!instance creation!public! !
!RegKeyAbstract class categoriesFor: #usersRoot!instance creation!public! !
!RegKeyAbstract class categoriesFor: #usersRoot:!instance creation!public! !


"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'OS.RegistrySerializer'
	instanceVariableNames: 'objects currentKey instVarsCache classNames'
	classVariableNames: ''
	imports: #(#{OS.WinRegConstants private})
	classInstanceVariableNames: ''
	classConstants: {
		'BytesValueName' -> 'bytes'.
		'ReferencePrefix' -> '@'.
		'ValueSeparator' -> ':'
	}!
OS.RegistrySerializer guid: (Core.GUID fromString: '{da611471-9e5f-4743-a322-503ebcf1ed71}')!
OS.RegistrySerializer comment: '`OS.RegistrySerializer` is a simple object serialiser for storing object graphs in the Windows Registry. The graphs can be reconstructed from the registry using `OS.RegistryDeserializer`.

The general format for pointer objects is that they are written under a registry key (known as the _class key_) where the default value of that key is a `REG_MULTI_SZ` value containing at least the short name of the class as the first string, and any additional metadata as subsequent strings. The additional metadata depends on the class of object, but for indexable objects it will typically include additional parameter that is the number of indexed fields. The named instance variables are written as sub-keys **or** sub-values* using the same serialization format, where the sub-keys are named after the instance variables. The indexable fields of pointer objects are serialized to integer numbered sub-keys/sub-values. The numbering starts from one. In order to enumerate all the named or numbered instasnce variables it is necessary to enumerate all the sub-keys and all the sub-values.

Where the value of an instance variable is of a class that can be represented by one of the native registry value types, then a named registry sub-value is written instead of the general object format under a _class key_*:
  - `String`s are written as `REG_SZ` values
  - `Integer`s are written as `REG_DWORD` values if in the 32-bit 2''s complement range, `REG_QWORD` if in the 64-bit 2''s complement range, or using the binary object format otherwise (under a _class key_).
  - `nil`s are not written (optimised out)
  - `ByteArray`s are written as `REG_BINARY` values
  - `Array`s of `String`s are written as `REG_MULTISZ` values

Byte objects (which always indexable, and do not have named instance variables) are written are a class key with the same `REG_MULTI_SZ` default-valued _class-key_ format as for indexable pointer objects. The indexable bytes of the object are written as a `REG_BINARY` sub-value named `bytes`.

*The optimisation of serialising some special types using values rather than always using the class key format does result in some irregularity in the representation and a little more complexity in the implementation. This is less than ideal, but:
  - Reading/writing registry values is faster obviously faster than reading/writing a key with a value. Even with the optimisation, the serialisation (in particular) and deserialisation are quite slow. For comparison the ClassBrowserShell settings dictionary can be deserialised from STL form in ~80 microseconds, or from STON in ~500 microseconds, but takes ~1.5 milliseconds to deserialize from the registry, i.e. the registry serialisation is around 20x slower than STL even with the value optimisation.
  - Registry values consume ["much less registry space than a key"](https://docs.microsoft.com/en-us/windows/win32/sysinfo/registry-storage-space), whatever "much less" might mean. 
  - Registry values are easier to manually edit for the kind of simple settings that the registry serialisation is intended to support that the full _class-key_ format. 
Even disregarding speed, the registry is not a suitable storage location for large and complex object graphs anyway. See Microsoft''s documentation on [Registry Element Size Limits]( https://docs.microsoft.com/en-us/windows/win32/sysinfo/registry-element-size-limits) and [Registry Storage Space](https://docs.microsoft.com/en-us/windows/win32/sysinfo/registry-storage-space) for details. 

Some classes may have requirements for custom serialisation formats. To implement custom serialization for a particular class, the `writeToRegistry:name:` method can be defined on the instance side of the class for serialization, and the `readFromRegistry:params:` method on the class side for deserialization. There are examples in the `Dolphin Registry Serialization` package that demonstrate a range of different customisation scenarios. One common case is where each value of a class is represented by a unique instance - i.e. where equal instances are identical. An example is `Symbol`s, which are represented using just the class key, with the string equivalent of the symbol written as the 2nd element of the class key default value. Another slightly more complex example is `Color`, where there are named and unnamed values. Named `Color`s are written as just a _class-key_ with the name as the 2nd element of the default value, and unnamed `Color`s are written in the full _class-key_ format. Singleton classes, where the class can only ever have one instance such as `True` and `False`, are written as a _class key_ only. 

Where an object appears more than once in the graph being serialised, and is not of some value type (e.g. strings, integers), it is written as a _reference key_ on second and subsequent encounters. _Reference keys_ are named sub-keys of a similar format to _class keys_, but with a default `REG_MULTISZ` value that encodes a reference rather than the class name and metadata. The reference format is a string of the form `@<relative-path>`, expressing a relative path to the key (and possibly named value, following a colon separator) that encodes the referenced object. The relative path form is the same as a Windows file system relative path, e.g. `..\..\Abc`, which might be interpreted as "The key named ''Abc'' under my grandparent key". This mechanism also allows the object graph to contain cyclic references, however some care is needed when writing custom (de)serialization methods to ensure that the references are correctly maintained.

Examples of use of registry serialization for save/restore of application settings can be found in the IDE and samples, e.g:
  - `SmalltalkTookShell`s save and restore the class-side published aspects that are presented in the Tools/Options dialog for that tool.  To browse the implementation starting with the `SmalltalkToolShell class` `#persistOptions` and `#loadOptions` methods.
  - The `XmlPad` sample application explicitly saves and restores some settings such as the text styles used for the Scintilla editor view. The approach taken should be suitable for most GUI aplications. See instance-side `#saveUserSettings` and `#restoreUserSettings` methods.

If saving/restoring settings from the user hive of the registry, you do need to consider that this presents an attack surface for a malicious actor. Any application running as the user can write to this area, so the data should be treated as unvalidated user input. To mitigate this the deserializer has a mechanism to restrict the objects it will load and created. By default it will only recognise a limited set of classes (see `OS.RegistryDeserializer>>#defaultSafeClasses`), although it will also allow any metaclass reference. It can be configured to accept more (or fewer) classes, and if necessary a validation block can be specified to filter candidate class references (passed to the block as `BindingReference`s).



	'!
!OS.RegistrySerializer categoriesForClass!Kernel-Objects! !
!OS.RegistrySerializer methodsFor!

basicObjectAt: aString put: anObject
	"Serialize the <Object>, anObject, under the receiver's current RegKey with the <readableString> name, aString. See the class comment for details of the representation."

	(objects lookup: anObject)
		ifNil: 
			[self registerObject: anObject key: aString.
			anObject class isPointers
				ifTrue: [self writePointerObject: anObject at: aString]
				ifFalse: 
					[self
						bytesAt: aString
						put: anObject
						as: anObject class]]
		ifNotNil: [:ref | self writeReference: ref key: aString]!

basicWriteCollection: aCollection key: aString
	| parentKey size |
	size := aCollection size.
	parentKey := currentKey.
	currentKey := self
				createClassKey: aCollection class
				name: aString
				with: (size > 0 ifTrue: [size]).
	aCollection inject: 1
		into: 
			[:i :each |
			each writeToRegistry: self name: i printString.
			i + 1].
	currentKey free.
	currentKey := parentKey!

binaryAt: aString put: aByteArray
	"Write a REG_BINARY value to the receiver's current RegKey with the <readableString> name, keyString, and <ByteArray> value, aByteArray. Answer the value written.
	If aByteArray has been previously serialised, then write a reference key instead."

	^(objects lookup: aByteArray)
		ifNil: 
			[self registerObject: aByteArray value: aString.
			currentKey binaryAt: aString put: aByteArray]
		ifNotNil: [:ref | self writeReference: ref key: aString]!

bytesAt: aString put: aByteObject as: aClass
	"Write a class sub-key for the <ClassDescription>, aClass, under the receiver's current RegKey with the <readableString> name, keyString, to represent the byte <Object> aByteObject. The object is encoded as a REG_BINARY value named 'bytes' of the sub-key. The byte object is assumed to be an immutable value object, so is never written as a reference."

	(self
		createClassKey: aClass
		name: aString
		with: aByteObject basicSize)
		basicValueAt: BytesValueName
			put: aByteObject
			type: REG_BINARY
			size: aByteObject byteSize;
		free!

classAt: aString put: aClass with: parameterObject
	"Write a class sub-key describing the <Object>, anObject, under the receiver's current key with the <readableString> name, aString. The default value of the sub-key is a REG_MULTISZ, the first element of which is the class short name (i.e. a name that can be used to bind the class in the context of the Smalltalk namespace). The final argument, parameterObject, represents optional additional  metadata and it's display string is stored as the 2nd element of the REG_MULTISZ default value. If parameterObject is nil, then only the class name is written. Typically parameterObject is the indexable size of anObject, but it may be an identifier that uniquely identifies anObject in its class in order that it can be deserialised to the same instance. Answer the REG_MULTISZ <Utf16String> value written as the default value of the key."

	^currentKey
		basicAt: aString
		put: (parameterObject
				ifNil: [self nameForClass: aClass]
				ifNotNil: [RegKey encodeMultiSz: {self nameForClass: aClass. parameterObject}])
		type: REG_MULTI_SZ!

createClassKey: aClassDescription name: aString with: parameterObject
	| key multiSz |
	key := currentKey createKey: aString.
	multiSz := parameterObject
				ifNil: [self nameForClass: aClassDescription]
				ifNotNil: [RegKey encodeMultiSz: {self nameForClass: aClassDescription. parameterObject}].
	key
		basicValueAt: nil
		put: multiSz
		type: REG_MULTI_SZ
		size: multiSz byteSize.
	^key!

dwordAt: aString put: anInteger
	"Write a REG_DWORD value to the receiver's current RegKey with the <readableString> name, aString, and <integer> value, anInteger."

	^currentKey dwordAt: aString put: anInteger!

instVarsOfClass: aClass
	^(instVarsCache lookup: aClass) ifNil: [instVarsCache at: aClass put: aClass allInstanceVariableNames]!

nameForClass: aClassDescription
	^(classNames lookup: aClassDescription)
		ifNil: [classNames at: aClassDescription put: aClassDescription shortName asUtf16String]!

noneAtPut: aString
	"Write a REG_NONE value to the receiver's current RegKey with the <readableString> name, aString."

	"Implementation Note: We don't need to store anything for nil's when performing serialisation to the registry."

	^nil!

objectAt: aString put: anObject
	"Serialize the <Object>, anObject, under the receiver's current RegKey with the <readableString> name, aString. See the class comment for details of the representation."

	anObject writeToRegistry: self name: aString!

qwordAt: aString put: anInteger
	"Write a REG_QWORD value to the receiver's current RegKey with the <readableString> name, aString, and <integer> value, anInteger."

	^currentKey qwordAt: aString put: anInteger!

registerObject: anObject key: aString
	| keyString |
	keyString := currentKey pathFromRoot , RegKeyAbstract.PathSeparator , aString.
	keyString size > 255 ifTrue: [self error: 'Registry path is too long (> 255 characters)'].
	objects at: anObject put: keyString!

registerObject: aValueObject value: aString
	objects at: aValueObject put: currentKey pathFromRoot , ValueSeparator , aString!

setRegKey: aRegKey 
	currentKey := aRegKey.
	objects := IdentityDictionary new: 16.
	instVarsCache := IdentityDictionary new: 8.
	classNames := IdentityDictionary new: 8!

stringArrayAt: aString put: anArray
	"Write a REG_MULTISZ value to the receiver's current RegKey with the <readableString> name, keyString, and a null-separated list of string values encoded from the <Array>, anArray."

	^(objects lookup: anArray)
		ifNil: 
			[self registerObject: anArray value: aString.
			currentKey stringArrayAt: aString put: anArray]
		ifNotNil: [:ref | self writeReference: ref key: aString]!

stringAt: keyString put: valueString
	"Write a REG_SZ value to the receiver's current RegKey with the <readableString> name, keyString, and <readableString> value, valueString."

	^currentKey stringAt: keyString put: valueString!

valueAt: aString put: anObject type: aSymbol
	"Write a value to the receiver's current RegKey with the <readableString> name, aString, <Object> value, anObject, encoded as the registry value type corresponding to the <Symbol>, aSymbol, which must be one of #dword (REG_DWORD), #qword (REG_QWORD), #string (REG_SZ), #expandString (REG_EXPAND_SZ), #stringArray (REG_MULTISZ), #none (REG_NONE)."

	currentKey
		valueAt: aString
		put: anObject
		type: aSymbol!

write: anObject name: aString
	| needsFree |
	needsFree := currentKey realize.
	currentKey removeSubTree: aString.
	anObject writeToRegistry: self name: aString.
	needsFree ifTrue: [currentKey free]!

writeCollection: aCollection at: aString
	"Write a <collection> of objects as a class key named, aString, under the current key."

	(objects lookup: aCollection)
		ifNil: 
			[self registerObject: aCollection key: aString.
			self basicWriteCollection: aCollection key: aString]
		ifNotNil: [:ref | self writeReference: ref key: aString]!

writeObject: anObject name: aString parameter: parameterObject do: aMonadicValuable
	(objects lookup: anObject)
		ifNil: 
			[| parentKey |
			self registerObject: anObject key: aString.
			parentKey := currentKey.
			currentKey := self
						createClassKey: anObject class
						name: aString
						with: parameterObject.
			aMonadicValuable cull: self cull: anObject.
			currentKey free.
			currentKey := parentKey]
		ifNotNil: [:ref | self writeReference: ref key: aString]!

writePointerObject: anObject at: aString
	| parentKey instVars size |
	size := anObject basicSize.
	parentKey := currentKey.
	currentKey := self
				createClassKey: anObject class
				name: aString
				with: (size > 0 ifTrue: [size]).
	instVars := self instVarsOfClass: anObject class.
	1 to: instVars size
		do: 
			[:i |
			| each |
			each := instVars at: i.
			(each at: 1) == $_ ifFalse: [(anObject instVarAt: i) writeToRegistry: self name: each]].
	1 to: size do: [:i | (anObject basicAt: i) writeToRegistry: self name: i printString].
	currentKey free.
	currentKey := parentKey!

writeReference: pathString key: nameString
	"Private - Emit a reference-key from the sub-key of the current key named, nameString, to the target registry key path, pathString."

	| relPath |
	"Registry key paths look like unrooted file system paths, so we can use file system APIs to manipulate them. The maximum length of a key path is 255, which is < MAX_PATH (260)"
	relPath := Utf16String newFixed: Win32Constants.MAX_PATH.
	Shlwapi
		pathRelativePathTo: relPath
		pszFrom: currentKey pathFromRoot , RegKey.PathSeparator , nameString
		dwAttrFrom: Win32Constants.FILE_ATTRIBUTE_DIRECTORY
		pszTo: pathString
		dwAttrTo: Win32Constants.FILE_ATTRIBUTE_DIRECTORY.
	currentKey
		basicAt: nameString
		put: ReferencePrefix , relPath trimNulls
		type: OS.WinRegConstants.REG_MULTI_SZ! !
!OS.RegistrySerializer categoriesForMethods!
basicObjectAt:put:!accessing!public! !
basicWriteCollection:key:!helpers!private! !
binaryAt:put:!accessing!public! !
bytesAt:put:as:!accessing!public! !
classAt:put:with:!accessing!public! !
createClassKey:name:with:!helpers!private! !
dwordAt:put:!accessing!public! !
instVarsOfClass:!helpers!private! !
nameForClass:!helpers!private! !
noneAtPut:!accessing!public! !
objectAt:put:!accessing!public! !
qwordAt:put:!accessing!public! !
registerObject:key:!accessing!private! !
registerObject:value:!accessing!private! !
setRegKey:!initializing!private! !
stringArrayAt:put:!accessing!public! !
stringAt:put:!accessing!public! !
valueAt:put:type:!public!serializing! !
write:name:!public!serializing! !
writeCollection:at:!public!serializing! !
writeObject:name:parameter:do:!public!serializing! !
writePointerObject:at:!helpers!private! !
writeReference:key:!helpers!private! !
!

OS.RegistrySerializer methodProtocol: #registryWriter attributes: #() selectors: #(#binaryAt:put: #bytesAt:put:as: #classAt:put:with: #dwordAt:put: #noneAtPut: #objectAt:put: #qwordAt:put: #stringArrayAt:put: #stringAt:put: #writeCollection:at:)!

!OS.RegistrySerializer class methodsFor!

icon
	^RegKeyAbstract icon!

initialize
	self addClassConstant: 'BytesValueName' value: 'bytes' asUtf16String.
	self addClassConstant: 'ValueSeparator' value: ':' asUtf16String.
	self addClassConstant: 'ReferencePrefix' value: '@' asUtf16String!

regKey: aRegKey
	^self new
		setRegKey: aRegKey;
		yourself!

write: anObject to: aRegKey
	self
		write: anObject
		to: aRegKey parentKey
		name: aRegKey name!

write: anObject to: aRegKey name: aString
	(self regKey: aRegKey) write: anObject name: aString! !
!OS.RegistrySerializer class categoriesForMethods!
icon!constants!public! !
initialize!class initialization!public! !
regKey:!public! !
write:to:!public! !
write:to:name:!public! !
!


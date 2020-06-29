"Filed out from Dolphin Smalltalk 7"!

IniFileAbstract subclass: #IniFileSection
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IniFileSection guid: (GUID fromString: '{958fca51-c92d-44e7-bba0-cfb419fa5b11}')!
IniFileSection comment: 'Implements <abstractDictionary> over a named section of a Windows .ini file'!
!IniFileSection categoriesForClass!Unclassified! !
!IniFileSection methodsFor!

= comparand
	"Answer whether the receiver and the <Object>, comparand, are considered equivalent."

	^super = comparand and: [comparand name sameAs: name]!

at: aString ifAbsent: aNiladicValuable
	"Answer the value of the receiver named by the key argument, aString.  If the key is not found, 
	answer the result of evaluating the <niladicValuable> argument."

	| value |
	aString isNil ifTrue: [^self errorNilKey].
	^(value := self lookup: aString) isNil ifTrue: [aNiladicValuable value] ifFalse: [value]!

at: keyString put: valueObject
	| value |
	keyString isNil ifTrue: [self errorNilKey].
	value := valueObject displayString.
	^(KernelLibrary default
		writePrivateProfileString: name
		lpKeyName: keyString asUtf16String shallowCopy
		lpString: value
		lpFileName: filename) == 0
		ifTrue: [Win32Error signal]
		ifFalse: [valueObject]!

errorNilKey
	self error: 'nil is not a valid key'!

getValue: key
	| lib buf count |
	buf := Utf16String newFixed: 128.
	lib := KernelLibrary default.
	
	[count := lib
				getPrivateProfileString: name
				lpKeyName: key
				lpDefault: nil
				lpReturnedString: buf
				nSize: buf size
				lpFileName: filename.
	(count == 0 and: [lib getLastError ~~ 0])
		ifTrue: 
			["Not found"
			^nil].
	count = (buf size - 2)]
			whileTrue: [buf := Utf16String newFixed: buf size * 2].
	^(buf resize: count) asUtf8String!

hash
	^super hash bitXor: name hash !

keysClass
	"Private - Answer the class of Collection to be used for collecting the keys of the receiver"
	
	^Set!

keysDo: operation
	"Evaluate the <monadicValuable>, operation, for each of the receiver's <String> keys."

	| buf start size end |
	buf := self getValue: nil.
	size := buf size.
	start := 1.
	
	[end := buf
				nextIndexOf: $\0
				from: start
				to: size.
	end == 0] whileFalse: 
				[operation value: (buf copyFrom: start to: end - 1).
				start := end + 1]!

name
	^name!

printPrefixOn: aStream
	super printPrefixOn: aStream.
	aStream
		nextPut: $[;
		nextPutAll: name;
		nextPut: $];
		space!

removeKey: aString ifAbsent: aNiladicValuable
	"Remove the <String> key (and its associated value), from the receiver. If key is
	not in the receiver, answer the result of evaluating the <niladicValuable>,
	operation. Otherwise, answer the value named by key."

	| value key |
	aString isNil ifTrue: [^self errorNilKey].
	key := aString asUtf16String shallowCopy.
	value := self getValue: key.
	value isNil ifTrue: [^aNiladicValuable value].
	^(KernelLibrary default
		writePrivateProfileString: name
		lpKeyName: key
		lpString: nil
		lpFileName: filename) == 0
		ifTrue: [Win32Error signal]
		ifFalse: [value]!

setFilename: filenameString section: sectionNameString
	filename := filenameString asUtf16String.
	name := sectionNameString asUtf16String shallowCopy! !
!IniFileSection categoriesFor: #=!comparing!public! !
!IniFileSection categoriesFor: #at:ifAbsent:!adding!public! !
!IniFileSection categoriesFor: #at:put:!adding!public! !
!IniFileSection categoriesFor: #errorNilKey!exceptions!private! !
!IniFileSection categoriesFor: #getValue:!accessing!public! !
!IniFileSection categoriesFor: #hash!comparing!public! !
!IniFileSection categoriesFor: #keysClass!constants!private! !
!IniFileSection categoriesFor: #keysDo:!enumerating!public! !
!IniFileSection categoriesFor: #name!accessing!public! !
!IniFileSection categoriesFor: #printPrefixOn:!printing!private! !
!IniFileSection categoriesFor: #removeKey:ifAbsent:!public!removing! !
!IniFileSection categoriesFor: #setFilename:section:!initializing!private! !

!IniFileSection class methodsFor!

open: filenameString section: sectionNameString
	^self new
		setFilename: filenameString section: sectionNameString! !
!IniFileSection class categoriesFor: #open:section:!public! !


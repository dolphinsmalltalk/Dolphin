"Filed out from Dolphin Smalltalk"!

OS.IniFileAbstract
	subclass: #'OS.IniFileSection'
	instanceVariableNames: 'name'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.IniFileSection guid: (Core.GUID fromString: '{958fca51-c92d-44e7-bba0-cfb419fa5b11}')!

OS.IniFileSection comment: 'Implements <abstractDictionary> over a named section of a Windows .ini file'!

!OS.IniFileSection methodsFor!

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
	^(Kernel32
		writePrivateProfileString: name
		lpKeyName: keyString asUtf16String shallowCopy
		lpString: value
		lpFileName: filename) == 0
		ifTrue: [Win32Error signal]
		ifFalse: [valueObject]!

errorNilKey
	self error: 'nil is not a valid key'!

getValue: key
	| buf count |
	buf := Utf16String newFixed: 128.
	
	[count := Kernel32
				getPrivateProfileString: name
				lpKeyName: key
				lpDefault: nil
				lpReturnedString: buf
				nSize: buf size
				lpFileName: filename.
	(count == 0 and: [Kernel32 getLastError ~~ 0])
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

printOn: aStream
	"Print a string representation of self on aStream. This method suffices for 
	most collections, and is able to handle cyclic references."

	aStream
		basicPrint: self;
		nextPut: $(;
		nextPut: $[;
		nextPutAll: name;
		nextPut: $];
		space.
	self do: [:each | each printOn: aStream] separatedBy: [aStream space].
	aStream nextPut: $)!

removeKey: aString ifAbsent: aNiladicValuable
	"Remove the <String> key (and its associated value), from the receiver. If key is
	not in the receiver, answer the result of evaluating the <niladicValuable>,
	operation. Otherwise, answer the value named by key."

	| value key |
	aString isNil ifTrue: [^self errorNilKey].
	key := aString asUtf16String shallowCopy.
	value := self getValue: key.
	value isNil ifTrue: [^aNiladicValuable value].
	^(Kernel32
		writePrivateProfileString: name
		lpKeyName: key
		lpString: nil
		lpFileName: filename) == 0
		ifTrue: [Win32Error signal]
		ifFalse: [value]!

setFilename: filenameString section: sectionNameString
	filename := filenameString asUtf16String.
	name := sectionNameString asUtf16String shallowCopy! !

!OS.IniFileSection categoriesForMethods!
=!comparing!public! !
at:ifAbsent:!adding!public! !
at:put:!adding!public! !
errorNilKey!exceptions!private! !
getValue:!accessing!public! !
hash!comparing!public! !
keysClass!constants!private! !
keysDo:!enumerating!public! !
name!accessing!public! !
printOn:!printing!public! !
removeKey:ifAbsent:!public!removing! !
setFilename:section:!initializing!private! !
!

!OS.IniFileSection class methodsFor!

open: filenameString section: sectionNameString
	^self new
		setFilename: filenameString section: sectionNameString! !

!OS.IniFileSection class categoriesForMethods!
open:section:!public! !
!


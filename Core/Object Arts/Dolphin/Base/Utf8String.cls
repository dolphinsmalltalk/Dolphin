"Filed out from Dolphin Smalltalk 7"!

String variableByteSubclass: #Utf8String
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Utf8String guid: (GUID fromString: '{c5ab1b05-241f-4955-8b44-0c80b93bafbb}')!
Utf8String isNullTerminated: true!
Utf8String comment: 'Utf8String is a nascent class to support UTF8 encoded byte character strings.'!
!Utf8String categoriesForClass!Collections-Text! !
!Utf8String methodsFor!

asLowercase
	#todo.	"Provide a more efficient implementation"
	^self asUtf16String asLowercase asUtf8String!

asString
	"Answer a <readableString> containing the same characters as the receiver,
	i.e. the receiver."

	"For historical reasons, this is always an ANSI-encoded byte string."

	| utf16 bytes buf size kernel |
	#todo.	"Provide a more efficient implementation that does not have to convert to utf16 first"
	(size := self size) == 0 ifTrue: [^String empty].	"Avoid 'The Parameter is Incorrect' error"
	utf16 := self class utf16Class new: size.
	((kernel := KernelLibrary default)
		multiByteToWideChar: self codePage
		dwFlags: 0
		lpMultiByteStr: self
		cchMultiByte: -1
		lpWideCharStr: utf16
		cchWideChar: size + 1) == 0
		ifTrue: [kernel systemError].
	buf := self class ansiClass new: size * 4.
	(bytes := kernel
				wideCharToMultiByte: buf codePage
				dwFlags: 0
				lpWideCharStr: utf16
				cchWideChar: -1
				lpMultiByteStr: buf
				cchMultiByte: buf size + 1
				lpDefaultChar: nil
				lpUsedDefaultChar: nil) == 0
		ifTrue: [^kernel systemError].
	buf resize: bytes - 1.
	^buf!

asUppercase
	#todo.	"Provide a more efficient implementation"
	^self asUtf16String asUppercase asUtf8String!

asUtf8String
	"Answer a UTF8 encoded string representation of the receiver."

	^self! !
!Utf8String categoriesFor: #asLowercase!converting!public! !
!Utf8String categoriesFor: #asString!converting!public! !
!Utf8String categoriesFor: #asUppercase!converting!public! !
!Utf8String categoriesFor: #asUtf8String!converting!public! !

!Utf8String class methodsFor!

codePage
	^Win32Constants.CP_UTF8!

fromByteArray: aByteArray
	| size answer |
	size := aByteArray size.
	answer := self basicNew: size.
	aByteArray
		replaceBytesOf: answer
		from: 1
		to: size
		startingAt: 1.
	^answer!

initialize
	empty := self new
				isImmutable: true;
				yourself.
	VMLibrary default registryAt: #Utf8String put: self! !
!Utf8String class categoriesFor: #codePage!instance creation!public! !
!Utf8String class categoriesFor: #fromByteArray:!public! !
!Utf8String class categoriesFor: #initialize!development!initializing!public! !


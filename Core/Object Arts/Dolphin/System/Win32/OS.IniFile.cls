"Filed out from Dolphin Smalltalk"!

OS.IniFileAbstract
	subclass: #'OS.IniFile'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.IniFile guid: (Core.GUID fromString: '{c373c097-bfde-42ca-968c-28008b7eff49}')!

OS.IniFile comment: 'Implements <abstractDictionary> over a Windows .ini file'!

!OS.IniFile methodsFor!

at: aString ifAbsent: aNiladicValuable
	"Answer the <IniFileSection> in the received named by the <String> argument.  If there is no such section,
	answer the result of evaluating the <niladicValuable> argument."

	| key |
	key := aString shallowCopy.
	^(self hasSectionNamed: key) ifTrue: [self getValue: key] ifFalse: [aNiladicValuable value]!

at: keyString put: valueDictionary
	"Store the key-value pairs in the <abstractDictionary> argument as a named section of the initialization file."

	| kvps |
	kvps := Utf16String writeStream.
	valueDictionary keysAndValuesDo: 
			[:eachKey :eachValue |
			kvps
				display: eachKey;
				nextPut: $=;
				display: eachValue;
				nextPut: $\0].
	kvps nextPut: $\0.
	kvps := kvps contents.
	(Kernel32
		writePrivateProfileSection: keyString asUtf16String shallowCopy
		lpString: kvps
		lpFileName: filename) == 0
		ifTrue: [Win32Error signal].
	^valueDictionary!

getValue: aString
	"Private - Answer the <IniFileSection> named by the <String> argument. Note that the section may not
	currently exist in the ini-file, but can be added to, which will then cause the section to
	be added to the ini-file."

	^IniFileSection open: filename section: aString!

hasSectionNamed: aString
	^(Kernel32
		getPrivateProfileSection: aString
		lpReturnedString: (Utf16String newFixed: 3)
		nSize: 3
		lpFileName: filename) ~~ 0
		or: 
			["Special case of empty section is OK"
			Kernel32 getLastError == 0]!

includesKey: aString
	"Answer whether the receiver has a section with the specified name."

	"The API has a bug whereby it writes a null term to the string. This fails if the key is in read-only memory, so we always make a copy."

	^self hasSectionNamed: aString shallowCopy!

keysDo: operation
	"Evaluate the <monadicValuable>, operation, for each of the receiver's section names."

	| buf count start end |
	buf := Utf16String newFixed: 512.
	
	[count := Kernel32
				getPrivateProfileSectionNames: buf
				nSize: buf size
				lpFileName: filename.
	count = (buf size - 2)]
			whileTrue: [buf := Utf16String newFixed: buf size * 2].
	start := 1.
	buf := buf asUtf8String.
	
	[end := buf
				nextIndexOf: $\0
				from: start
				to: count.
	end == 0] whileFalse: 
				[operation value: (buf copyFrom: start to: end - 1).
				start := end + 1]!

removeKey: aString ifAbsent: aNiladicValuable
	"Remove the section named by the <String> argument from the initialization file. If there is no such section,
	answer the result of evaluating the <niladicValuable>, operation. Otherwise, answer the named <IniFileSection>."

	| value key |
	"The APIs write to the key, even though they shouldn't"
	key := aString asUtf16String shallowCopy.
	(self hasSectionNamed: key) ifFalse: [^aNiladicValuable value].
	value := self getValue: key.
	^(Kernel32
		writePrivateProfileSection: key
		lpString: nil
		lpFileName: filename) ifTrue: [value] ifFalse: [Win32Error signal]! !

!OS.IniFile categoriesForMethods!
at:ifAbsent:!accessing!public! !
at:put:!adding!public! !
getValue:!accessing!private! !
hasSectionNamed:!accessing!private! !
includesKey:!accessing!public! !
keysDo:!enumerating!public! !
removeKey:ifAbsent:!public!removing! !
!


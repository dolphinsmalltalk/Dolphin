!Utf8String methodsFor!

decodeAt: anInteger
	"Private - Read the <Character> with code point in the receiver's encoding starting with the code unit at the specified index. Raise an error if the indexed code unit is not the first in a character. If the character encoding is invalid or incomplete, return the replacement character. Intolerance of indexing errors is intended to help detect logic errors in algorithms working with multi-byte strings, although this may also occur in incorrectly encoded data which is otherwise tolerated by returning the replacement character."

	| c c2 size codePoint min |
	c := self basicAt: anInteger.
	c < 16r80
		ifTrue: 
			["Ascii char"
			^Character.CharacterSet at: c + 1].
	"Lead byte?"
	c >= 16rC0
		ifFalse: 
			["On a continution byte so in the middle of a character, which is invalid"
			^self errorIntraCharacterIndex: anInteger].
	"At least 2 byte character"
	size := self size.
	anInteger < size ifFalse: [^Character.Utf8Default].
	c2 := self basicAt: anInteger + 1.
	(c2 bitAnd: 16rC0) == 16r80
		ifTrue: 
			[codePoint := (c bitAnd: 16r1F) << 6 bitOr: (c2 bitAnd: 16r3F).
			min := 16r80]
		ifFalse: 
			["Invalid 1st continuation"
			^Character.Utf8Default].
	c >= 16rE0
		ifTrue: 
			[| c3 |
			"At least a 3-byte character"
			anInteger + 2 > size ifTrue: [^Character.Utf8Default].
			c3 := self basicAt: anInteger + 2.
			(c3 bitAnd: 16rC0) == 16r80
				ifTrue: 
					[codePoint := (codePoint bitAnd: 16r3FF) << 6 bitOr: (c3 bitAnd: 16r3F).
					min := 16r800]
				ifFalse: 
					["Invalid 2nd continuation"
					^Character.Utf8Default].
			c >= 16rF0
				ifTrue: 
					[| c4 |
					"4-byte character"
					anInteger + 3 > size ifTrue: [^Character.Utf8Default].
					c4 := self basicAt: anInteger + 3.
					(c4 bitAnd: 16rC0) == 16r80
						ifTrue: 
							[codePoint := (codePoint bitAnd: 16r7FFF) << 6 bitOr: (c4 bitAnd: 16r3F).
							min := 16r10000]
						ifFalse: 
							["Invalid 3rd continuation"
							^Character.Utf8Default].
					c >= 16rF8
						ifTrue: 
							["5 or 6-byte character (not currently possible - only 4 bytes required for max Unicode char"
							^Character.Utf8Default]]].
	codePoint < min
		ifTrue: 
			["Overlong encoding"
			^Character.Utf8Default].
	^Character codePoint: codePoint ifInvalid: [Character.Utf8Default]! !

Float addClassVariable: 'DefaultDecimalExponents' value: (-3 to: 6)!

#(#thousandSeparator #thousandSeparator:) do: [:each | NUMBERFMTW removeSelector: each]!

!ClassDescription methodsFor!

categoriesForMethods
	^ChunkReader
		do: [:selector :filer | (self categoriesFor: selector asSymbol) fileInFrom: filer]
		inContext: self
		atEnd: []! !
		
!ChunkReader methodsFor!

fileInFrom: aSourceFiler
	| chunk |
	[aSourceFiler atEnd or: [(chunk := aSourceFiler nextChunk) isEmpty]]
		whileFalse: [chunkBlock cull: chunk cull: aSourceFiler].
	^endAction value! !

#(#initialize #fromString:) do: [:each | ExternalDescriptor class removeSelector: each]!

ExternalLibrary subclass: #PathCchLibrary
	instanceVariableNames: ''
	classVariableNames: 'PATHCCH_ALLOW_LONG_PATHS PATHCCH_MAX_CCH'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

!PathCchLibrary class methodsFor!

fileName
	"Answer the host system file name for the library"

	^'api-ms-win-core-path-l1-1-0'! !

!PathCchLibrary methodsFor!

pathAllocCombine: pszPathIn pszMore: pszMore dwFlags: dwFlags ppszPathOut: ppszPathOut
	"Private - Invoke the PathAllocCombine() function of the module wrapped by the receiver.
	Helpstring: Concatenates two path fragments into a single path. This function also canonicalizes any relative path elements, replacing path elements such as '.' and '..'.

		HRESULT __stdcall PathAllocCombine(
			LPCWSTR pszPathIn,
			LPCWSTR pszMore,
			ULONG dwFlags,
			LPWSTR* ppszPathOut);"

	<stdcall: hresult PathAllocCombine lpwstr lpwstr dword lpwstr*>
	^self invalidCall: _failureCode!

pathCombine: pszPathIn pszMore: pszMore dwFlags: dwFlags
	| pszPathOut result |
	pszPathOut := ExternalAddress new.
	self
		pathAllocCombine: pszPathIn
		pszMore: pszMore
		dwFlags: dwFlags
		ppszPathOut: pszPathOut.
	result := Utf16String fromAddress: pszPathOut.
	KernelLibrary default localFree: pszPathOut.
	^result! !

!KernelLibrary methodsFor!

getFullPathName: aPathnameString
	| buffer path bufferSize pathLength |
	"The 'A' version of the API is limited to paths up to MAX_PATH - it errors on long filenames - so even if the system code page is CP_UTF8, we have to use the 'W' version of the function."
	path := aPathnameString asUtf16String.
	(bufferSize := self
				getFullPathName: path
				nBufferLength: 0
				lpBuffer: nil
				lpFilePart: nil) == 0
		ifTrue: [^self systemError].
	"The API is a bit asymmetric. If the buffer is large enough, it returns the number of characters copied to the buffer. If the buffer is too small, it returns the required size of buffer required, including null terminator (i.e. characters + 1). Also the API has a bug that if the path to be expanded starts with .\, then the buffer size returned includes space for the leading .\, even though these will be removed, so the buffer is too large and will have two extra nulls at its end. In this case the returned size written will be 3 less than the buffer size reported (rather than 1)."
	buffer := Utf16String newFixed: bufferSize - 1.
	^(pathLength := self
				getFullPathName: path
				nBufferLength: bufferSize
				lpBuffer: buffer
				lpFilePart: nil) + 1
		== bufferSize
			ifTrue: [buffer]
			ifFalse: [pathLength == 0 ifTrue: [self systemError] ifFalse: [buffer copyFrom: 1 to: pathLength]]! !

!FileStream methodsFor!

primitiveNextPutAll: aCollection
	<primitive: 173>
	^aCollection appendToStream: self! !

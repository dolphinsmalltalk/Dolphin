ClassBuilder addClassConstant: 'FixedName' value: #(#Smalltalk #Root)!
DateAndTime addClassConstant: 'UnixEpochSeconds' value: 16r81C94B00!

!OS.CRTLibrary methodsFor!

wcslen: aString
	<cdecl: sdword wcslen lpvoid>
	^self invalidCall: _failureCode! !
!OS.CRTLibrary categoriesForMethods!

StdioFileStream classPool removeKey: 'ClassForEncoding'!

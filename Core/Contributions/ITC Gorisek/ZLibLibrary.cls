"Filed out from Dolphin Smalltalk 7"!

ExternalLibrary subclass: #ZLibLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ZLibLibrary guid: (GUID fromString: '{A7DE047E-8AA5-4394-8359-A45FB6A5CC84}')!
ZLibLibrary comment: ''!
!ZLibLibrary categoriesForClass!Unclassified! !
!ZLibLibrary methodsFor!

compress2: outData outLen: outLen inData: inData inLen: inLen level: level
	<cdecl: dword compress2 lpvoid lpvoid lpvoid dword dword>
	^self invalidCall!

uncompress: outData outLen: outLen inData: inData inLen: inLen
	<cdecl: dword uncompress lpvoid lpvoid lpvoid dword>
	^self invalidCall! !
!ZLibLibrary categoriesFor: #compress2:outLen:inData:inLen:level:!public! !
!ZLibLibrary categoriesFor: #uncompress:outLen:inData:inLen:!public! !

!ZLibLibrary class methodsFor!

fileName
	"Answer the host system file name for the external library the 
	receiver represents."

	^File splitStemFrom: (self default fileName)!

open
	"Answer a new instance of the receiver to represent the CRT DLL."

	^(self fromHandle: VMLibrary default handle) initialize! !
!ZLibLibrary class categoriesFor: #fileName!constants!public! !
!ZLibLibrary class categoriesFor: #open!instance creation!public! !


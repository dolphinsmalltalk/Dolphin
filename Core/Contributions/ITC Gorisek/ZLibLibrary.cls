"Filed out from Dolphin Smalltalk 7"!

ExternalLibrary subclass: #ZLibLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ZLibLibrary guid: (GUID fromString: '{a7de047e-8aa5-4394-8359-a45fb6a5cc84}')!
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
	"Answer the host system file name of the external library which the 
	receiver represents"

	^'ZLIB_DLL'
! !
!ZLibLibrary class categoriesFor: #fileName!constants!public! !


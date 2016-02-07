"Filed out from Dolphin Smalltalk X6"!

ExternalLibrary subclass: #ScintillaLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaLibrary guid: (GUID fromString: '{846BC1F2-AD71-411E-8C63-C99780A5A626}')!
ScintillaLibrary comment: 'ExternalLibrary class to wrap the Scintilla DLL (SciLexer.dll).'!
!ScintillaLibrary categoriesForClass!External-Libraries! !
!ScintillaLibrary methodsFor!

directFunction: sciThis msg: msg wParam: wParam lParam: lParam 
	<stdcall: sdword '_Scintilla_DirectFunction@16' dword dword dword dword>
	^self invalidCall!

versionFormatString
	"Private - Answer a String containing the version format used by the receiver.
	The arguments than can be inserted into the string are:
		1) Product name
		2) Product major high word
		3) Product major low word
		4) Product minor high word
		5) Product minor low word
	"

	^'%2!!d!!.%3!!d!!.%4!!d!!.%5!!d!!'! !
!ScintillaLibrary categoriesFor: #directFunction:msg:wParam:lParam:!operations!private! !
!ScintillaLibrary categoriesFor: #versionFormatString!constants!private! !

!ScintillaLibrary class methodsFor!

default
	"Answer the default instance of the receiver."

	"Implementation Note: Override for optimum performance (assume always open like a permanent library)."

	^default!

fileName
	"Answer the host system file name of the external library which the receiver represents"

	^'SciLexer'!

realize
	super default! !
!ScintillaLibrary class categoriesFor: #default!accessing!public! !
!ScintillaLibrary class categoriesFor: #fileName!constants!public! !
!ScintillaLibrary class categoriesFor: #realize!public!realizing/unrealizing! !


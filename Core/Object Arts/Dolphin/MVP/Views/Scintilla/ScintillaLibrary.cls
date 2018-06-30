"Filed out from Dolphin Smalltalk 7"!

ExternalLibrary subclass: #ScintillaLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaLibrary guid: (GUID fromString: '{846bc1f2-ad71-411e-8c63-c99780a5a626}')!
ScintillaLibrary comment: 'ExternalLibrary class to wrap the Scintilla DLL (SciLexer.dll).'!
!ScintillaLibrary categoriesForClass!External-Libraries! !
!ScintillaLibrary methodsFor!

directFunction: sciThis msg: msg wParam: wParam lParam: lParam 
	<stdcall: intptr Scintilla_DirectFunction handle dword uintptr uintptr>
	^self invalidCall!

directFunction: sciThis msg: msg wParam: wParam lpParam: lpParam 
	<stdcall: intptr Scintilla_DirectFunction handle dword uintptr void*>
	^self invalidCall!

directFunction: sciThis msg: msg wpParam: wParam lParam: lpParam
	<stdcall: intptr Scintilla_DirectFunction handle dword void* uintptr>
	^self invalidCall!

directFunction: sciThis msg: msg wpParam: wParam lpParam: lpParam 
	<stdcall: intptr Scintilla_DirectFunction handle dword void* void*>
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

	^'%2!!d!!.%3!!d!!.%4!!d!!'! !
!ScintillaLibrary categoriesFor: #directFunction:msg:wParam:lParam:!operations!private! !
!ScintillaLibrary categoriesFor: #directFunction:msg:wParam:lpParam:!operations!private! !
!ScintillaLibrary categoriesFor: #directFunction:msg:wpParam:lParam:!operations!private! !
!ScintillaLibrary categoriesFor: #directFunction:msg:wpParam:lpParam:!operations!private! !
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
	super default!

versionString
	"Answer the version of the Scintilla control for which this library was generated."

	^'4.1.0'! !
!ScintillaLibrary class categoriesFor: #default!accessing!public!realizing/unrealizing! !
!ScintillaLibrary class categoriesFor: #fileName!constants!public! !
!ScintillaLibrary class categoriesFor: #realize!public!realizing/unrealizing! !
!ScintillaLibrary class categoriesFor: #versionString!**auto generated**!constants!public!scintilla interface! !


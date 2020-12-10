"Filed out from Dolphin Smalltalk 7"!

External.DynamicLinkLibrary subclass: #'UI.Scintilla.ScintillaLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.ScintillaLibrary guid: (Core.GUID fromString: '{846bc1f2-ad71-411e-8c63-c99780a5a626}')!
UI.Scintilla.ScintillaLibrary comment: 'ExternalLibrary class to wrap the Scintilla DLL (SciLexer.dll).'!
!UI.Scintilla.ScintillaLibrary categoriesForClass!External-Libraries! !
!UI.Scintilla.ScintillaLibrary methodsFor!

directFunction: sciThis msg: msg wParam: wParam lParam: lParam
	<stdcall: intptr Scintilla_DirectFunction handle dword uintptr uintptr>
	^self invalidCall: _failureCode!

directFunction: sciThis msg: msg wParam: wParam lpParam: lpParam
	<stdcall: intptr Scintilla_DirectFunction handle dword uintptr void*>
	^self invalidCall: _failureCode!

directFunction: sciThis msg: msg wpParam: wParam lParam: lpParam
	<stdcall: intptr Scintilla_DirectFunction handle dword void* uintptr>
	^self invalidCall: _failureCode!

directFunction: sciThis msg: msg wpParam: wParam lpParam: lpParam
	<stdcall: intptr Scintilla_DirectFunction handle dword void* void*>
	^self invalidCall: _failureCode!

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
!UI.Scintilla.ScintillaLibrary categoriesFor: #directFunction:msg:wParam:lParam:!operations!private! !
!UI.Scintilla.ScintillaLibrary categoriesFor: #directFunction:msg:wParam:lpParam:!operations!private! !
!UI.Scintilla.ScintillaLibrary categoriesFor: #directFunction:msg:wpParam:lParam:!operations!private! !
!UI.Scintilla.ScintillaLibrary categoriesFor: #directFunction:msg:wpParam:lpParam:!operations!private! !
!UI.Scintilla.ScintillaLibrary categoriesFor: #versionFormatString!constants!private! !

!UI.Scintilla.ScintillaLibrary class methodsFor!

fileName
	"Answer the host system file name of the external library which the receiver represents"

	^'SciLexer'!

versionString
	"Answer the version of the Scintilla control for which this library was generated."

	^'4.4.5'! !
!UI.Scintilla.ScintillaLibrary class categoriesFor: #fileName!constants!public! !
!UI.Scintilla.ScintillaLibrary class categoriesFor: #versionString!**auto generated**!constants!public!scintilla interface! !


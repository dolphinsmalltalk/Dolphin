"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMTTDISPINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CommCtrlConstants'
	classInstanceVariableNames: ''!
NMTTDISPINFO guid: (GUID fromString: '{fd2f4864-6901-4633-8b54-accb5c28a265}')!
NMTTDISPINFO comment: ''!
!NMTTDISPINFO categoriesForClass!External-Data-Structured-Win32! !
!NMTTDISPINFO methodsFor!

idIsHandle
	"Answer true if id stored in the receiver's header is a window handle, or false
	if it is a tool id (e.g. for a toolbar button)."

	^self uFlags anyMask: 1"TTF_IDISHWND"!

text: aString 
	"Private - Set the receiver's tip text to the appropriate form (ANSI or Unicode) of the 
	<readableString> argument, and answer that."

	^self subclassResponsibility!

uFlags
	^self subclassResponsibility! !
!NMTTDISPINFO categoriesFor: #idIsHandle!private!testing! !
!NMTTDISPINFO categoriesFor: #text:!accessing!private! !
!NMTTDISPINFO categoriesFor: #uFlags!accessing!public! !


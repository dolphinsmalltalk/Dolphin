"Filed out from Dolphin Smalltalk"!

Tools.Scintilla.IntTypeReference subclass: #'Tools.Scintilla.EnumTypeReference'
	instanceVariableNames: 'name'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Scintilla.EnumTypeReference guid: (Core.GUID fromString: '{c17866ae-91b7-4037-9b4a-edab9627dbe9}')!
Tools.Scintilla.EnumTypeReference comment: ''!
!Tools.Scintilla.EnumTypeReference categoriesForClass!Development! !
!Tools.Scintilla.EnumTypeReference methodsFor!

name
	^name!

name: aString
	name := aString! !
!Tools.Scintilla.EnumTypeReference categoriesFor: #name!accessing!public! !
!Tools.Scintilla.EnumTypeReference categoriesFor: #name:!accessing!private! !

!Tools.Scintilla.EnumTypeReference class methodsFor!

name: aString
	^self new 
		name: aString;
		yourself! !
!Tools.Scintilla.EnumTypeReference class categoriesFor: #name:!public! !


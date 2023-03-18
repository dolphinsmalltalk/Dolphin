"Filed out from Dolphin Smalltalk"!

Tools.Scintilla.IntTypeReference
	subclass: #'Tools.Scintilla.EnumTypeReference'
	instanceVariableNames: 'name prefix values defaultValueName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Scintilla.EnumTypeReference guid: (Core.GUID fromString: '{c17866ae-91b7-4037-9b4a-edab9627dbe9}')!
Tools.Scintilla.EnumTypeReference comment: ''!
!Tools.Scintilla.EnumTypeReference categoriesForClass!Development! !
!Tools.Scintilla.EnumTypeReference methodsFor!

addConst: aString value: anInteger
	values add: aString -> anInteger!

defaultValue
	^defaultValueName ifNil: [values first key]!

defaultValueName: aString
	defaultValueName := aString!

name
	^name!

name: aString
	name := aString.
	values := SortedCollection sortBlock: [:a :b | a value < b value]!

prefix
	^prefix!

prefix: anObject
	prefix := anObject! !
!Tools.Scintilla.EnumTypeReference categoriesForMethods!
addConst:value:!accessing!public! !
defaultValue!accessing!public! !
defaultValueName:!accessing!public! !
name!accessing!public! !
name:!accessing!private! !
prefix!accessing!public! !
prefix:!accessing!private! !
!

!Tools.Scintilla.EnumTypeReference class methodsFor!

name: aString prefix: prefixString
	^self new
		name: aString;
		prefix: prefixString;
		yourself! !
!Tools.Scintilla.EnumTypeReference class categoriesForMethods!
name:prefix:!public! !
!


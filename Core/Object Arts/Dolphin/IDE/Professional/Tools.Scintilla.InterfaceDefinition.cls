"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Tools.Scintilla.InterfaceDefinition'
	instanceVariableNames: 'id name isDeprecated comment selector constName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.Scintilla.InterfaceDefinition guid: (Core.GUID fromString: '{5d1763e5-2a8b-42e5-9a1c-c1973b7e2d8b}')!

Tools.Scintilla.InterfaceDefinition isNonInstantiable: true!

Tools.Scintilla.InterfaceDefinition comment: ''!

!Tools.Scintilla.InterfaceDefinition categoriesForClass!Development! !

!Tools.Scintilla.InterfaceDefinition methodsFor!

comment
	^comment!

comment: aString 
	comment := aString!

constName
	^constName!

constPrefix
	^self subclassResponsibility!

id
	^id!

id: idString name: nameString retType: retString 
	id := idString.
	name := nameString.
	isDeprecated := false.
	constName := self constPrefix , name asUppercase.
	self retType: retString.
!

isDeprecated
	^isDeprecated!

isDeprecated: aBoolean 
	isDeprecated := aBoolean!

retType: aString 
	^self subclassResponsibility!

selector
	^selector! !

!Tools.Scintilla.InterfaceDefinition categoriesForMethods!
comment!accessing!public! !
comment:!accessing!private! !
constName!helpers!public! !
constPrefix!constants!private! !
id!accessing!public! !
id:name:retType:!initializing!private! !
isDeprecated!accessing!public!testing! !
isDeprecated:!accessing!private! !
retType:!accessing!private! !
selector!accessing!private! !
!

!Tools.Scintilla.InterfaceDefinition class methodsFor!

icon
	^UI.Scintilla.ScintillaView icon!

id: anInteger name: nameString retType: retString
	^self new
		id: anInteger
		name: nameString
		retType: retString!

tokens: anArray 
	^self 
		id: (anArray at: 3)
		name: (anArray at: 2)
		retType: (anArray at: 1)! !

!Tools.Scintilla.InterfaceDefinition class categoriesForMethods!
icon!constants!development!public! !
id:name:retType:!initializing!public! !
tokens:!instance creation!public! !
!


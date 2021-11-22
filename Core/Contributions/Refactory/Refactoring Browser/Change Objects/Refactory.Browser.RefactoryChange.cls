"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Refactory.Browser.RefactoryChange'
	instanceVariableNames: 'name'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RefactoryChange guid: (Core.GUID fromString: '{2e46050f-612f-4e62-a0cf-281408d71404}')!
Refactory.Browser.RefactoryChange isNonInstantiable: true!
Refactory.Browser.RefactoryChange comment: 'RefactoryChange is an abstract class that represent some change to a class or method. They are used in combination with RefactoryBuilders to give transaction-like behavior.

Subclasses must implement the following messages:
	accessing
		doIt

Instance Variables:
	class	<Behavior>	the class that is to be changed'!
!Refactory.Browser.RefactoryChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.RefactoryChange methodsFor!

addClassChangeClass
	^AddClassChange!

addMethodChangeClass
	^AddMethodChange!

afterText
	^self changeString!

beforeText
	^''!

changeClass
	^nil!

changeForClass: aRBClass selector: aSelector 
	^nil!

changeForMetaclass: aSymbol selector: aSelector 
	^nil!

changes
	^{self}!

changesSize
	^1!

changeString
	^self class name!

displayClassName
	^''!

displayString
	^name isNil ifTrue: [self changeString] ifFalse: [name]!

execute
	^self executeNotifying: []!

executeNotifying: aBlock 
	self subclassResponsibility!

flattenedChanges
	| changes |
	changes := OrderedCollection new.
	self flattenOnto: changes.
	^changes!

flattenOnto: aCollection 
	aCollection add: self!

initialize!

name
	^name isNil ifTrue: [self changeString] ifFalse: [name]!

name: aString
	name := aString!

renameChangesForClass: aClassName to: newClassName 
	"We're in the middle of performing a rename operation. If we stored 
	the class name, we need to change the class name to the new 
	name to perform the compiles."

	"No action required for most changes."!

selector
	^nil! !
!Refactory.Browser.RefactoryChange categoriesForMethods!
addClassChangeClass!constants!public! !
addMethodChangeClass!constants!public! !
afterText!printing!public! !
beforeText!printing!public! !
changeClass!public! !
changeForClass:selector:!accessing!public! !
changeForMetaclass:selector:!accessing!public! !
changes!accessing!public! !
changesSize!accessing!public! !
changeString!printing!public! !
displayClassName!public! !
displayString!printing!public! !
execute!performing/changes!public! !
executeNotifying:!private! !
flattenedChanges!accessing!private! !
flattenOnto:!private! !
initialize!initialize/release!public! !
name!accessing!public! !
name:!initialize/release!public! !
renameChangesForClass:to:!accessing!public! !
selector!public! !
!

!Refactory.Browser.RefactoryChange class methodsFor!

new
	^super new initialize! !
!Refactory.Browser.RefactoryChange class categoriesForMethods!
new!instance creation!public! !
!


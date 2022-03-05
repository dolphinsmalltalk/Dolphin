"Filed out from Dolphin Smalltalk"!

Object subclass: #RefactoryChange
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RefactoryChange guid: (GUID fromString: '{2e46050f-612f-4e62-a0cf-281408d71404}')!
RefactoryChange isAbstract: true!
RefactoryChange comment: 'RefactoryChange is an abstract class that represent some change to a class or method. They are used in combination with RefactoryBuilders to give transaction-like behavior.

Subclasses must implement the following messages:
	accessing
		doIt

Instance Variables:
	class	<Behavior>	the class that is to be changed'!
!RefactoryChange categoriesForClass!Refactory-Change Objects! !
!RefactoryChange methodsFor!

addMethodChangeClass
	#rbFix. "Replace hard refs to AddMethodChange with sends of this message, and use Dolphin specific subclass"
	^DolphinAddMethodChange!

changeForClass: aRBClass selector: aSelector 
	^nil!

changeForMetaclass: aSymbol selector: aSelector 
	^nil!

changes
	^Array with: self!

changesSize
	^1!

changeString
	^self class name!

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

	self subclassResponsibility! !
!RefactoryChange categoriesForMethods!
addMethodChangeClass!constants!public! !
changeForClass:selector:!accessing!public! !
changeForMetaclass:selector:!accessing!public! !
changes!accessing!public! !
changesSize!accessing!public! !
changeString!printing!public! !
displayString!printing!public! !
execute!performing/changes!public! !
executeNotifying:!private! !
flattenedChanges!accessing!private! !
flattenOnto:!private! !
initialize!initialize/release!public! !
name!accessing!public! !
name:!initialize/release!public! !
renameChangesForClass:to:!accessing!public! !
!

!RefactoryChange class methodsFor!

new
	^super new initialize! !
!RefactoryChange class categoriesForMethods!
new!instance creation!public! !
!


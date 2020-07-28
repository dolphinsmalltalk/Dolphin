"Filed out from Dolphin Smalltalk 7"!

Object subclass: #RefactoryChange
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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

addClassChangeClass
	#rbFix. "Replace hard refs to AddClassChange with sends of this message, and use Dolphin specific subclass"
	^DolphinAddClassChange!

addMethodChangeClass
	#rbFix. "Replace hard refs to AddMethodChange with sends of this message, and use Dolphin specific subclass"
	^DolphinAddMethodChange!

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
!RefactoryChange categoriesFor: #addClassChangeClass!constants!public! !
!RefactoryChange categoriesFor: #addMethodChangeClass!constants!public! !
!RefactoryChange categoriesFor: #changeForClass:selector:!accessing!public! !
!RefactoryChange categoriesFor: #changeForMetaclass:selector:!accessing!public! !
!RefactoryChange categoriesFor: #changes!accessing!public! !
!RefactoryChange categoriesFor: #changesSize!accessing!public! !
!RefactoryChange categoriesFor: #changeString!printing!public! !
!RefactoryChange categoriesFor: #displayString!printing!public! !
!RefactoryChange categoriesFor: #execute!performing/changes!public! !
!RefactoryChange categoriesFor: #executeNotifying:!private! !
!RefactoryChange categoriesFor: #flattenedChanges!accessing!private! !
!RefactoryChange categoriesFor: #flattenOnto:!private! !
!RefactoryChange categoriesFor: #initialize!initialize/release!public! !
!RefactoryChange categoriesFor: #name!accessing!public! !
!RefactoryChange categoriesFor: #name:!initialize/release!public! !
!RefactoryChange categoriesFor: #renameChangesForClass:to:!accessing!public! !

!RefactoryChange class methodsFor!

new
	^super new initialize! !
!RefactoryChange class categoriesFor: #new!instance creation!public! !


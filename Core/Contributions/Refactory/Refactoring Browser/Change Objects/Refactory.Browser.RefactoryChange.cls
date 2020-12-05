"Filed out from Dolphin Smalltalk 7"!

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
	#rbFix.	"Replace hard refs to AddMethodChange with sends of this message, and use Dolphin specific subclass"
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
!Refactory.Browser.RefactoryChange categoriesFor: #addClassChangeClass!constants!public! !
!Refactory.Browser.RefactoryChange categoriesFor: #addMethodChangeClass!constants!public! !
!Refactory.Browser.RefactoryChange categoriesFor: #changeForClass:selector:!accessing!public! !
!Refactory.Browser.RefactoryChange categoriesFor: #changeForMetaclass:selector:!accessing!public! !
!Refactory.Browser.RefactoryChange categoriesFor: #changes!accessing!public! !
!Refactory.Browser.RefactoryChange categoriesFor: #changesSize!accessing!public! !
!Refactory.Browser.RefactoryChange categoriesFor: #changeString!printing!public! !
!Refactory.Browser.RefactoryChange categoriesFor: #displayString!printing!public! !
!Refactory.Browser.RefactoryChange categoriesFor: #execute!performing/changes!public! !
!Refactory.Browser.RefactoryChange categoriesFor: #executeNotifying:!private! !
!Refactory.Browser.RefactoryChange categoriesFor: #flattenedChanges!accessing!private! !
!Refactory.Browser.RefactoryChange categoriesFor: #flattenOnto:!private! !
!Refactory.Browser.RefactoryChange categoriesFor: #initialize!initialize/release!public! !
!Refactory.Browser.RefactoryChange categoriesFor: #name!accessing!public! !
!Refactory.Browser.RefactoryChange categoriesFor: #name:!initialize/release!public! !
!Refactory.Browser.RefactoryChange categoriesFor: #renameChangesForClass:to:!accessing!public! !

!Refactory.Browser.RefactoryChange class methodsFor!

new
	^super new initialize! !
!Refactory.Browser.RefactoryChange class categoriesFor: #new!instance creation!public! !


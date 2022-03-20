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

afterText
	^self changeString!

beforeText
	^''!

changeClass
	^nil!

changeForClassNamed: aBindingReference selector: aSelector
	^nil!

changeForMetaclass: aSymbol selector: aSelector 
	^nil!

changes
	^{self}!

changesDo: aMonadicValuable
	aMonadicValuable value: self!

changesSize
	^1!

changeString
	^self class name!

classReference
	^nil!

displayString
	^self name!

execute
	^self executeNotifying: []!

executeNotifying: aBlock 
	self subclassResponsibility!

lastChangeMatching: aMonadicValuable
	^(aMonadicValuable value: self) ifTrue: [self]!

name
	^name isNil ifTrue: [self changeString] ifFalse: [name]!

name: aString
	name := aString!

package
	"Answer the affected <Package>, or nil if none."

	^nil!

renameChangesForClass: aClassName to: newClassName 
	"Private - We're in the middle of performing a rename operation. If we stored 
	the class name, we need to change the class name to the new 
	name to perform the compiles."

	"No action required for most changes."!

selector
	"Answer the selector of the affected method, or nil if none."

	^nil! !
!Refactory.Browser.RefactoryChange categoriesForMethods!
afterText!printing!public! !
beforeText!printing!public! !
changeClass!accessing!public! !
changeForClassNamed:selector:!public!searching! !
changeForMetaclass:selector:!public!searching! !
changes!accessing!public! !
changesDo:!enumerating!public! !
changesSize!accessing!public! !
changeString!printing!public! !
classReference!accessing!public! !
displayString!printing!public! !
execute!applying!public! !
executeNotifying:!applying!private! !
lastChangeMatching:!public!searching! !
name!accessing!public! !
name:!initializing!public! !
package!accessing!public! !
renameChangesForClass:to:!helpers!private! !
selector!accessing!public! !
!

!Refactory.Browser.RefactoryChange class methodsFor!

new
	^super new initialize! !
!Refactory.Browser.RefactoryChange class categoriesForMethods!
new!instance creation!public! !
!


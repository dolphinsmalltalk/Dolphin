"Filed out from Dolphin Smalltalk"!

Refactory.Browser.CreateAccessorsForVariableRefactoring
	subclass: #'Refactory.Browser.RenameAccessorsForVariableRefactoring'
	instanceVariableNames: 'newName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RenameAccessorsForVariableRefactoring guid: (Core.GUID fromString: '{9e8e6c09-efcb-4259-82e5-b37dde861a8c}')!
Refactory.Browser.RenameAccessorsForVariableRefactoring comment: ''!
!Refactory.Browser.RenameAccessorsForVariableRefactoring methodsFor!

createGetterAccessor
	"Currently, if we fail to find a getter to rename, we do nothing.  An option to ask the user if they want to create one, reverting to the superclass' behaviour, could be added."

	self setGetterMethod.
	getterMethod isNil ifFalse:
		[| refactoring | refactoring := self renameGetterRefactoring.
		self performComponentRefactoring: refactoring.
		getterMethod :=  refactoring newSelector]

"$QA Ignore:Direct state variable access(getterMethod)$"
			!

createSetterAccessor
	"Currently, if we fail to find a setter to rename, we do nothing.  An option to ask the user if they want to create one, reverting to the superclass' behaviour, could be added."

	self setSetterMethod.
	setterMethod isNil ifFalse:
		[| refactoring | refactoring := self renameSetterRefactoring.
		self performComponentRefactoring: refactoring.
		setterMethod := refactoring newSelector]

"$QA Ignore:Direct state variable access(setterMethod)$"
			!

newName: aString
	newName := aString
			!

preconditions
	"I do nothing if I fail to find any candidate accessors.  My rename*MethodRefactorings' preconditions protect the renaming of any I find.  Thus I do not need preconditions.  (My superclass' precondition can be inappropriate when this refactoring is used in a composite which e.g. starts by checking the instvar is there and then renames it before calling me.)"

	^RBCondition empty
			!

renameGetterRefactoring
	^RenameMethodRefactoring 
		model: self model
		renameMethod: getterMethod
		in: self definingClass
		to: (self safeMethodNameFor: self definingClass basedOn: newName)
		permutation: OrderedCollection new
			!

renameSetterRefactoring
	^RenameMethodRefactoring
		model: self model
		renameMethod: setterMethod
		in: self definingClass
		to: (self safeMethodNameFor: self definingClass basedOn: newName , ':')
		permutation: (OrderedCollection with: 1)
			!

setGetterMethod
	"If I haven't already found a getter candidate, see if I can find one.  If I already have, it is probably because a composite refactoring using me called this method earlier, before making changes that render the getter harder to identify."

	getterMethod isNil ifTrue: [getterMethod := self findGetterMethod]
			!

setSetterMethod
	"If I haven't already found a getter candidate, see if I can find one.  If I already have, it is probably because a composite refactoring using me called this method earlier, before making changes that would render the setter harder to find."

	setterMethod isNil ifTrue: [setterMethod := self findSetterMethod]
			! !
!Refactory.Browser.RenameAccessorsForVariableRefactoring categoriesForMethods!
createGetterAccessor!public!transforming! !
createSetterAccessor!public!transforming! !
newName:!accessing!public! !
preconditions!preconditions!public! !
renameGetterRefactoring!public!transforming! !
renameSetterRefactoring!public!transforming! !
setGetterMethod!composite-accessing!public! !
setSetterMethod!composite-accessing!public! !
!


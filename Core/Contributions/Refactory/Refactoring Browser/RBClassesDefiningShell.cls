"Filed out from Dolphin Smalltalk 2000 release 4.01"!

SmalltalkToolShell subclass: #RBClassesDefiningShell
	instanceVariableNames: 'classesPresenter sourcePresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBClassesDefiningShell comment: ''!

RBClassesDefiningShell guid: (GUID fromString: '{0ED3F285-0F4C-11D5-BA96-444553540000}')!

!RBClassesDefiningShell categoriesForClass!Unclassified! !
!RBClassesDefiningShell methodsFor!

browseClasses
	"Private - Open a browser on the currently selected class."

	self method isNil
		ifTrue: [self browseClass]!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.

	classesPresenter := (self add: ListPresenter new name: 'classes') beSorted.
	sourcePresenter := self add: SmalltalkWorkspace new name: 'source'.	

!

createSchematicWiring
	"Create the trigger wiring for the receiver"
	
	super createSchematicWiring. 
	classesPresenter
		when: #selectionChanged send: #onClassSelected to: self;
		when: #actionPerformed send: #browseClass to: self.	
	!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^OrderedCollection new asValue
!

disableSourcePane
	"Private - Clear and disable the source pane."

	sourcePresenter clear; view disable
!

onClassSelected
	"Private - A class has been selected. Fill and show the source view with a
	definition of the class."

	| class |
	
	class := self selectedClass. 
	class notNil
		ifTrue: [
			self source: class coloredDefinition.
			sourcePresenter view disable]
		ifFalse: [self disableSourcePane]
!

onViewOpened

	super onViewOpened.


!

selectedClass
	"Answer the currently selected class if there is exactly one selection, otherwise answer nil."

	^classesPresenter selectionOrNil
	!

selectedClasses
	!

source: text
	"Private - Set the text of the receivers sourcePresenter to the argument,
	text (either plain or rich text)."

	sourcePresenter text: text
!

updateClasses: anOrderedCollection
	"Private - Update the classes list for this package."

	classesPresenter list: anOrderedCollection.
	classesPresenter	selection: anOrderedCollection first.! !
!RBClassesDefiningShell categoriesFor: #browseClasses!*-unclassified!public! !
!RBClassesDefiningShell categoriesFor: #createComponents!*-unclassified!public! !
!RBClassesDefiningShell categoriesFor: #createSchematicWiring!*-unclassified!public! !
!RBClassesDefiningShell categoriesFor: #defaultModel!*-unclassified!public! !
!RBClassesDefiningShell categoriesFor: #disableSourcePane!*-unclassified!public! !
!RBClassesDefiningShell categoriesFor: #onClassSelected!*-unclassified!public! !
!RBClassesDefiningShell categoriesFor: #onViewOpened!*-unclassified!public! !
!RBClassesDefiningShell categoriesFor: #selectedClass!*-unclassified!public! !
!RBClassesDefiningShell categoriesFor: #selectedClasses!*-unclassified!public! !
!RBClassesDefiningShell categoriesFor: #source:!*-unclassified!public! !
!RBClassesDefiningShell categoriesFor: #updateClasses:!*-unclassified!public! !

!RBClassesDefiningShell class methodsFor!

defaultView

	^'defaultView'! !
!RBClassesDefiningShell class categoriesFor: #defaultView!*-unclassified!public! !


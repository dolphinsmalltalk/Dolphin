"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ClassRefactoring
	subclass: #'Refactory.Browser.CopyClassRefactoring'
	instanceVariableNames: 'newName addClass commonSuperclass superclass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.CopyClassRefactoring guid: (Core.GUID fromString: '{c6843969-c4d4-4f0f-8de1-ceae5725b831}')!
Refactory.Browser.CopyClassRefactoring comment: ''!
!Refactory.Browser.CopyClassRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.CopyClassRefactoring methodsFor!

buildClassDetails: superClass
	| details progenitor classVarNames instVarNames classConstants classInstVarNames |
	details := (ClassDetails fromClass: self progenitor)
				superclass: superClass;
				className: newName;
				yourself.
	instVarNames := Array writeStream.
	classVarNames := Array writeStream.
	classInstVarNames := Array writeStream.
	classConstants := Array writeStream.
	progenitor := self progenitor.
	"Copy over any superclass variables that might be referenced"
	(progenitor allSuperclasses upTo: self commonSuperclass) reverseDo: 
			[:each |
			instVarNames
				nextPutAll: (each instanceVariableNames select: [:iv | progenitor refersToInstanceVariable: iv]).
			classVarNames nextPutAll: (each classVariableNames
						select: [:cv | (progenitor refersToClassVariable: cv) or: [progenitor metaclass refersToClassVariable: cv]]).
			classConstants
				nextPutAll: (each classConstants select: [:cc | progenitor refersToClassVariable: cc key]).
			classInstVarNames nextPutAll: (each metaclass instanceVariableNames
						select: [:iv | progenitor metaclass refersToInstanceVariable: iv])].
	"Copy over the directly defined variables, whether referenced or not"
	instVarNames nextPutAll: progenitor instanceVariableNames.
	classVarNames nextPutAll: progenitor classVariableNames.
	classConstants nextPutAll: progenitor classConstants.
	classInstVarNames nextPutAll: progenitor metaclass instanceVariableNames.
	details
		instanceVariableNames: instVarNames grabContents;
		classVariableNames: classVarNames grabContents;
		classConstants: classConstants grabContents;
		classInstanceVariableNames: classInstVarNames grabContents.
	^details!

className: progenitorName newName: aNewName superclass: aClass
	| details classRef |
	"We need to set the superclass name and new name before doing anything that might lazily instantiate the model, as these are part of the displayString used to generate a model name"
	classRef := BindingReference fullPathString: progenitorName.
	newName := ((BindingReference isQualifiedName: aNewName)
				ifTrue: [aNewName]
				ifFalse: 
					[| parts |
					parts := classRef path copy.
					parts at: parts size put: aNewName.
					BindingReference.PathSeparator join: parts])
					asSymbol.
	self classReference: classRef.
	superclass := self classObjectFor: aClass.
	details := self buildClassDetails: superclass.
	addClass := AddClassRefactoring
				model: self model
				details: details
				subclasses: #().
	^self!

cloneClass
	self performComponentRefactoring: addClass.
	^self model classNamed: self newName!

commonSuperclass
	^superclass
		ifNotNil: [:targetSuper | (targetSuper withAllSuperclasses intersection: self progenitor allSuperclasses) lookup: 1]!

copyMethodsFrom: aRBAbstractClass to: cloneClass
	aRBAbstractClass selectors do: 
			[:each |
			| method |
			method := aRBAbstractClass methodFor: each.
			(cloneClass compile: method source categories: (aRBAbstractClass protocolsFor: each))
				package: method method owningPackageIfLoose]!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		nextPutAll: 'Clone class ';
		display: className;
		nextPutAll: ' as ';
		display: self newName!

newName
	^newName!

preconditions
	^addClass preconditions!

progenitor
	^className value!

storeOn: aStream
	aStream
		nextPut: $(;
		store: self class;
		nextPutAll: ' clone: ';
		store: self progenitor;
		nextPutAll: ' as: ';
		store: self newName;
		nextPutAll: ' superclass: ';
		store: superclass;
		nextPut: $)!

transform
	| clone source |
	clone := self cloneClass.
	source := self progenitor.
	self copyMethodsFrom: source to: clone.
	self copyMethodsFrom: source metaclass to: clone metaclass! !
!Refactory.Browser.CopyClassRefactoring categoriesForMethods!
buildClassDetails:!initializing!private! !
className:newName:superclass:!initializing!private! !
cloneClass!private!transforming! !
commonSuperclass!accessing!private! !
copyMethodsFrom:to:!private!transforming! !
displayOn:!displaying!public! !
newName!public!transforming! !
preconditions!preconditions!public! !
progenitor!accessing!private! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!Refactory.Browser.CopyClassRefactoring class methodsFor!

clone: aClass as: aNewName superclass: superClass
	^self new className: aClass fullName newName: aNewName superclass: superClass!

model: aRBModel clone: aClass as: aNewName superclass: superClass
	^self new
		model: aRBModel;
		className: aClass fullName
			newName: aNewName
			superclass: superClass! !
!Refactory.Browser.CopyClassRefactoring class categoriesForMethods!
clone:as:superclass:!instance creation!public! !
model:clone:as:superclass:!instance creation!public! !
!


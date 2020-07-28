"Filed out from Dolphin Smalltalk 7"!

CompiledCode variableSubclass: #CompiledMethod
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CompiledMethod guid: (GUID fromString: '{87b4c544-026e-11d3-9fd7-00a0cc3e4a32}')!
CompiledMethod comment: 'CompiledMethod is the class of CompiledCode objects representing actual methods of objects, as opposed to unbound expressions (see CompiledExpression).

'!
!CompiledMethod categoriesForClass!Kernel-Methods! !
!CompiledMethod methodsFor!

<= aCompiledMethod
	^methodClass name < aCompiledMethod methodClass name
		or: [methodClass == aCompiledMethod methodClass and: [selector < aCompiledMethod selector]]!

categories
	"Answer a <Collection> of all the method categories in which the receiver is
	included."

	^self methodClass categoriesOfMethod: self!

categories: categories
	"Private - Set the categories of the receiver to the <Collection> of
	<methodCategory>s, categories. Remove the receiver from any method 
	categories it is currently associated with. If the set of method categories
	has changed, then triggers a #methodCategorized: event.
	Implementation Note: The receiver has no knowledge of categories, so fires
	this request straight off to the category system."

	(MethodCategory setMethod: self categories: categories)
		ifTrue: [Smalltalk trigger: #methodCategorized: with: self]!

changeManager
	"Private - Answer the receiver's change manager.
	At present change management is purely change log based."

	^self class sourceManager!

changePosition
	"Private - Answer the position in the change log of the receiver's source. N.B. This is a
	logical indication of the time at which the receiver was changed, it it not used for
	accessing the source but merely to determine whether the receiver has been changed relative
	to a particular point. The answer is only valid for instances that answer true to
	#isChanged."

	^self changeManager changePositionOf: self!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		display: self methodClass;
		nextPutAll: '>>';
		display: self selector!

getDebugInfo
	"Private - Invoke the compiler to answer a compilation result containing a 
	recompilation of the receiver, a map between IP ranges and expressions 
	in the source, and a map between IP ranges and an OrderedCollection of 
	Associations between IP positions and temporaries up to that position in 
	the receiver, ordered by IP."

	^self compilerClass 
		debugInfoFor: self getSource 
		in: self methodClass 
		debug: self isDebugMethod!

getSource
	"Answer the source of the receiver.
	This task is delegated to the SourceManager."

	^self class sourceManager getSourceOfMethod: self!

hasChanged
	"Private - Answer whether the receiver has been 'changed' (i.e. it has source in
	the change log)."

	^self changeManager hasMethodChanged: self!

isChanged
	"Private - Answer whether the receiver is 'changed' (i.e. its class has unsaved changes)."

	^self changeManager isMethodChanged: self!

isClassMethod	
	"Answer true if the receiver is a class method."

	^self methodClass isMeta!

isExpression
	"Private - Answer whether the receiver is a standalone (unbound) expression as opposed to 
	a method."

	^false!

isExternalCall
	"Private - Answer whether the receiver is an external library call (foreign function invocation)."

	^false!

isGetter
	"Answer true if the receiver is an instance variable getter method."

	^self extraIndex == 6!

isLoose
	"Answer whether the receiver is owned by a package different from that of its class."

	^Package manager isLooseMethod: self!

isOverridden
	"Answer whether the receiver is overridden in a subclass."

	| sel |
	sel := self selector.
	self methodClass allSubclassesDo: [:sub | (sub includesSelector: sel) ifTrue: [^true]].
	^false!

isOverride
	"Answer whether the receiver is overriding a method in a superclass."

	| methodSuper |
	methodSuper := self methodClass superclass.
	^methodSuper notNil and: [methodSuper canUnderstand: self selector]
!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^true!

isUnbound
	"Answer whether the receiver is unbound (i.e. not linked into a class' method dictionary)."

	^(self methodClass compiledMethodAt: self selector ifAbsent: [^true])	
		sourceDescriptor ~= self sourceDescriptor!

loseSource
	"Private - Set the source object of the receiver to a suitable message informing
	that the source data for the receiver has been lost. This is typically from saving
	an image from an executable, as the executable will have no associated .sml
	file."

	self sourceDescriptor: '"Source unavailable for this method"' !

name
	^MethodName method: self!

owningPackage
	"Answers the package that owns the receiver or nil if it is not yet owned
	by any package"

	^Package manager packageOfMethodOrItsClass: self!

owningPackage: aPackage
	"Set the receiver's <Package> to be the argument. Any current package association is lost."

	aPackage addMethod: self!

owningPackageIfLoose
	"Answers the package that owns the receiver as a loose method,
	or nil if it is not loose."

	^Package manager packageOfMethod: self!

printOn: aPuttableStream
	aPuttableStream
		print: self methodClass;
		nextPutAll: '>>';
		print: self selector!

privacyCategory
	^(self isPrivate ifTrue: ['private'] ifFalse: ['public']) asMethodCategory!

protocols
	"Answer a <Collection> of all the method protocols in which the receiver is included."

	^self methodClass allProtocols select: [:p | p includesSelector: self selector]
!

realCategories
	"Answer a <Collection> of all the 'real' (i.e. non-virtual) method categories in which 
	the receiver is included. Note that this does include the public/private categories."

	^self methodClass whichCategoriesIncludeSelector: self selector!

recompile
	"Private - Recompile the receiver."

	self methodClass recompile: self selector!

storeSourceString: aString
	"Private - Record aString as the source for the receiver. Delegate to the receiver's source manager"

	self class sourceManager storeSourceString: aString forMethod: self! !
!CompiledMethod categoriesFor: #<=!comparing!public! !
!CompiledMethod categoriesFor: #categories!categories-accessing!development!public! !
!CompiledMethod categoriesFor: #categories:!categories-accessing!private! !
!CompiledMethod categoriesFor: #changeManager!development!private! !
!CompiledMethod categoriesFor: #changePosition!development!private!testing! !
!CompiledMethod categoriesFor: #displayOn:!printing!public! !
!CompiledMethod categoriesFor: #getDebugInfo!development!private! !
!CompiledMethod categoriesFor: #getSource!accessing!development!public! !
!CompiledMethod categoriesFor: #hasChanged!development!private!testing! !
!CompiledMethod categoriesFor: #isChanged!development!private!testing! !
!CompiledMethod categoriesFor: #isClassMethod!public!testing! !
!CompiledMethod categoriesFor: #isExpression!private!testing! !
!CompiledMethod categoriesFor: #isExternalCall!private!testing! !
!CompiledMethod categoriesFor: #isGetter!public!testing! !
!CompiledMethod categoriesFor: #isLoose!development!public!testing! !
!CompiledMethod categoriesFor: #isOverridden!public!testing! !
!CompiledMethod categoriesFor: #isOverride!public!testing! !
!CompiledMethod categoriesFor: #isSelfEvaluating!public!testing! !
!CompiledMethod categoriesFor: #isUnbound!public!testing! !
!CompiledMethod categoriesFor: #loseSource!private!source filing-methods! !
!CompiledMethod categoriesFor: #name!accessing!public! !
!CompiledMethod categoriesFor: #owningPackage!accessing!development!public! !
!CompiledMethod categoriesFor: #owningPackage:!accessing!development!public! !
!CompiledMethod categoriesFor: #owningPackageIfLoose!accessing!development!public! !
!CompiledMethod categoriesFor: #printOn:!printing!public! !
!CompiledMethod categoriesFor: #privacyCategory!categories-accessing!private! !
!CompiledMethod categoriesFor: #protocols!categories-accessing!development!public! !
!CompiledMethod categoriesFor: #realCategories!categories-accessing!public! !
!CompiledMethod categoriesFor: #recompile!compiling!development!private! !
!CompiledMethod categoriesFor: #storeSourceString:!private!source filing-methods! !

!CompiledMethod class methodsFor!

defaultSortBlock
	"Private - Answer a dyadic valuable (sort block) suitable for comparing two instances
	of the receiver"

	^[:x :y | (x methodClass==y methodClass)
		ifTrue: [x selector <= y selector]
		ifFalse: [x methodClass <= y methodClass]] !

fromString: aString
	"Answers the CompiledMethod identified by aString or nil if none is found."

	| className stream |
	stream := aString readStream.
	className := stream upToAll: '>>'.
	stream atEnd ifTrue: [^nil].
	(className endsWith: ' class')
		ifTrue: [className := (className allButLast: 6) asQualifiedReference meta]
		ifFalse: [className := className asQualifiedReference].
	^className valueOrNil
		ifNotNil: 
			[:theClass |
			| selector |
			selector := stream upToEnd asSymbol.
			theClass compiledMethodAt: selector ifAbsent: []]! !
!CompiledMethod class categoriesFor: #defaultSortBlock!private!sorting! !
!CompiledMethod class categoriesFor: #fromString:!converting!development!public! !


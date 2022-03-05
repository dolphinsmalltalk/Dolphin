"Filed out from Dolphin Smalltalk"!

CompiledCode variableSubclass: #CompiledMethod
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
		ifTrue: [self methodClass environment trigger: #methodCategorized: with: self]!

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

displayOn: aStream 
	aStream
		print: self methodClass;
		nextPutAll: '>>';
		nextPutAll: self selector!

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
	^Association key: self methodClass name value: self selector!

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

printOn: aStream 
	"Append a textual description of the receiver to aStream."

	self displayOn: aStream!

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
!CompiledMethod categoriesForMethods!
<=!comparing!public! !
categories!categories-accessing!development!public! !
categories:!categories-accessing!private! !
changeManager!development!private! !
changePosition!development!private!testing! !
displayOn:!printing!public! !
getDebugInfo!development!private! !
getSource!accessing!development!public! !
hasChanged!development!private!testing! !
isChanged!development!private!testing! !
isClassMethod!public!testing! !
isExpression!private!testing! !
isExternalCall!private!testing! !
isGetter!public!testing! !
isLoose!development!public!testing! !
isOverridden!public!testing! !
isOverride!public!testing! !
isUnbound!public!testing! !
loseSource!private!source filing-methods! !
name!accessing!public! !
owningPackage!accessing!development!public! !
owningPackage:!accessing!development!public! !
owningPackageIfLoose!accessing!development!public! !
printOn:!printing!public! !
privacyCategory!categories-accessing!private! !
protocols!categories-accessing!development!public! !
realCategories!categories-accessing!public! !
recompile!compiling!development!private! !
storeSourceString:!private!source filing-methods! !
!

!CompiledMethod class methodsFor!

defaultSortBlock
	"Private - Answer a dyadic valuable (sort block) suitable for comparing two instances
	of the receiver"

	^[:x :y | (x methodClass==y methodClass)
		ifTrue: [x selector <= y selector]
		ifFalse: [x methodClass <= y methodClass]] !

fromString: aString
	"Answers the CompiledMethod identified by aString or nil if none is found."

	| className selector stream theClass isMeta |
	stream := aString readStream.
	className := stream upToAll: '>>'.
	stream atEnd ifTrue: [^nil].
	(isMeta := className endsWith: ' class') 
		ifTrue: [className := className allButLast: ' class' size].
	theClass := self environment at: className ifAbsent: [^nil].
	isMeta ifTrue: [theClass := theClass class].
	selector := stream upToEnd asSymbol.
	^theClass compiledMethodAt: selector ifAbsent: []! !
!CompiledMethod class categoriesForMethods!
defaultSortBlock!private!sorting! !
fromString:!converting!development!public! !
!


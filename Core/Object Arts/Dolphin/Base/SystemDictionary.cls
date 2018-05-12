"Filed out from Dolphin Smalltalk 7"!

Dictionary variableSubclass: #SystemDictionary
	instanceVariableNames: 'events allClasses allRoots'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SystemDictionary guid: (GUID fromString: '{87b4c52c-026e-11d3-9fd7-00a0cc3e4a32}')!
SystemDictionary comment: 'Class of the root of the system. SystemDictionary''s single instance (Smalltalk) 
provides associative access to all global objects in the system.'!
!SystemDictionary categoriesForClass!Collections-Unordered! !
!SystemDictionary methodsFor!

add: anAssociation
	"Add anAssociation to the receiver. Answer anAssociation.
	Although very similar to at:put:, we store the actual association passed
	as an argument here in order to maintain its references.
	The keys of associations stored in pool dictionaries must be strings."

	((anAssociation key isKindOf: Symbol) and: [anAssociation key notEmpty])
		ifFalse: [self error: 'SystemDictionaries are keyed with non-empty Symbols'].
	^super add: anAssociation!

allBehaviors
	"Private - Answer a <sequencedReadableCollection> of all of the Behaviors 
	contained in the system in breadth first order, with instance classes preceeding
	metaclasses."

	| answer |
	answer := OrderedCollection new: 5000.
	self allBehaviorsDo: [:behavior | answer addLast: behavior].
	^answer!

allBehaviorsDo: operation
	"Private - Evaluate the monadic valuable, operation, for each of the Behaviors in the system.
	N.B. No guarantee is made about ordering, except that the operation is evaluated
	for a subclass after its superclass."

	self allClasses do: [ :class |
		operation value: class.
		operation value: class class]!

allClasses
	"Answer a <sequencedReadableCollection> of all of the classes in the system, in breadth-first order.
	There is no particular ordering at a particular depth."

	allClasses isNil
		ifTrue: 
			[allClasses := (Class allClasses)
						isImmutable: true;
						yourself].
	^allClasses!

allRoots
	"Answer a <sequencedReadableCollection> of all global root classes - ie. those that are subclasses of nil."

	allRoots isNil ifTrue: [allRoots := Class allRoots].
	^allRoots!

associationAt: key ifAbsent: exceptionHandler
	"Answer the association named by the argument, key. If key is not found,
	answer the result of evaluating the niladic valuable, exceptionHandler."

	^(self basicAt: (self findKeyOrNil: key asSymbol)) ifNil: [exceptionHandler value]!

associationClass
	"Private - Answer the class of association to be used for holding
	key-value pairs in the receiver. Must respond to the Association protocol."
	
	^VariableBinding!

at: key ifAbsent: exceptionHandler
	"Answer the value named by the argument, key.  If key is not found,
	answer the result of evaluating the niladic valuable, exceptionHandler.
	The keys of pools are Strings."

	^super at: key asSymbol ifAbsent: exceptionHandler!

at: key put: anObject
	"Store the argument anObject with the external key, aKey,
	in the receiver. Answer anObject. Ensure the key is a String."

	key isEmpty ifTrue: [self error: 'Invalid global name'].
	^super at: key asSymbol put: anObject!

bindingFor: aString 
	"Answer the association whose key is equal to the argument in
	the receiver, or nil if the key is not present. Used by the Compiler."

	^super bindingFor: aString asSymbol!

classAdded: class
	"Private - The new <Class>, class, has been added to the receiver.
	Clear down the all class cache and inform observers."

	self clearCachedClasses.
	^self trigger: #classAdded: with: class.
!

classRemoved: aClass
	"Private - The <Class> argument has been removed from the system.
	Clear down the class caches and inform observers."

	self clearCachedClasses.
	self trigger: #classRemoved: with: aClass!

classUpdated: aClass
	"Private - The <Class>, aClass, has been updated. 
	Clear down the class caches and inform observers."

	self clearCachedClasses.
	^self trigger: #classUpdated: with: aClass!

clearCachedClasses
	"Private - Clear down the all class cache."

	allRoots := allClasses := nil!

developmentSystem
	"Answer the current instance of <SmalltalkSystem> if installed, otherwise 
	a <DeafObject>."

	| devSys |
	devSys := self at: #SmalltalkSystem ifPresent: [:c | c current].
	^devSys ifNil: [DeafObject current]!

getEvents
	"Private - Answer the EventsCollection belonging to the receiver, or nil if the receiver
	has no events registered for it"

	^events!

includesKey: key
	"Answer whether the receiver has a key equal to the argument, key.
	Override superclass to permit symbolic/string keys."

	^super includesKey: key asSymbol!

isAtomic
	"Answer whether or not the receiver is the single unique instance of its class that can
	represents its value."

	"There can only be one ProcessorScheduler instance."

	^true!

lookup: keyObject
	"Answer the value named by the <Object> argument, keyObject, or nil if there is no such key in the receiver."

	^super lookup: keyObject asSymbol!

postResize: oldMe
	"Private - This message is sent by the receiver when resizing, after the
	receiver's elements have been added to a new collection and the
	receiver has become that collection. It is a chance for the receiver
	to perform any final state changes needed."

	self setEvents: oldMe getEvents!

removeClass: aClass
	"Private - Remove aClass from the receiver. Report an error if there are any subclasses or
	instances of the receiver, or if the class is a standard system class."

	self removeKey: aClass name asSymbol ifAbsent: [].
	aClass removeFromSuper.
	"At this point it would be a good idea to make the class become:
	a special error reporting class"
	self classRemoved: aClass!

removeGlobalNamed: aSymbol
	"Remove the global identified by the <Symbol> argument 
	from this system dictionary."

	^self removeKey: aSymbol!

removeKey: key ifAbsent: exceptionHandler
	"Remove the key (and its associated value), from the receiver. If key is
	not in the receiver, answer the result of evaluating the niladic valuable,
	exceptionHandler. Otherwise, answer the value named by key.
	Implementation Note:  	Override in order to accept Symbols/Strings,
	and to trigger an event so that observers know that the global has been
	removed. Also #unitialize it if it directly implements #uninitialize and
	is not a class (or alias for a class)."

	| index element globalName |
	globalName := key asSymbol.
	index := self findKeyOrNil: globalName.
	^(element := self basicAt: index) isNil 
		ifTrue: [exceptionHandler value]
		ifFalse: 
			[| global isClass |
			self removeIndex: index.
			global := element value.
			isClass := global class isMeta.
			(isClass not or: [global name ~~ globalName]) 
				ifTrue: 
					[self trigger: #globalRemoved: with: element.
					"Uninitialize any global which is not a class name alias"
					(isClass not and: [global respondsTo: #uninitialize]) ifTrue: [global uninitialize]].
			global]!

renameGlobal: oldName to: newName
	"Rename the global, informing the system of the change."

	| oldSymbol binding |
	oldSymbol := oldName asSymbol.
	self noEventsDo: [binding := self changeKey: oldSymbol to: newName asSymbol].
	self triggerGlobalRenamed: binding from: oldSymbol!

setEvents: anEventsCollectionOrNil
	"Private - Set the EventsCollection of the receiver to be anEventsCollectionOrNil.
	Answer the receiver."

	events := anEventsCollectionOrNil!

triggerGlobalRenamed: anAssociation from: oldSymbol
	"Private - Inform observers that a  system global object has been renamed."

	self 
		trigger: #globalRenamed:from:
		with: anAssociation
		with: oldSymbol! !
!SystemDictionary categoriesFor: #add:!adding!public! !
!SystemDictionary categoriesFor: #allBehaviors!class hierarchy-accessing!private! !
!SystemDictionary categoriesFor: #allBehaviorsDo:!enumerating!private! !
!SystemDictionary categoriesFor: #allClasses!accessing!public! !
!SystemDictionary categoriesFor: #allRoots!accessing!public! !
!SystemDictionary categoriesFor: #associationAt:ifAbsent:!accessing!public! !
!SystemDictionary categoriesFor: #associationClass!constants!private! !
!SystemDictionary categoriesFor: #at:ifAbsent:!accessing!public! !
!SystemDictionary categoriesFor: #at:put:!accessing!public! !
!SystemDictionary categoriesFor: #bindingFor:!compiling!public! !
!SystemDictionary categoriesFor: #classAdded:!event handling!private! !
!SystemDictionary categoriesFor: #classRemoved:!private!removing! !
!SystemDictionary categoriesFor: #classUpdated:!event handling!private! !
!SystemDictionary categoriesFor: #clearCachedClasses!accessing!private! !
!SystemDictionary categoriesFor: #developmentSystem!accessing!public! !
!SystemDictionary categoriesFor: #getEvents!events!private! !
!SystemDictionary categoriesFor: #includesKey:!public!searching! !
!SystemDictionary categoriesFor: #isAtomic!public!testing! !
!SystemDictionary categoriesFor: #lookup:!accessing!public! !
!SystemDictionary categoriesFor: #postResize:!adding!private! !
!SystemDictionary categoriesFor: #removeClass:!private!removing! !
!SystemDictionary categoriesFor: #removeGlobalNamed:!operations!public! !
!SystemDictionary categoriesFor: #removeKey:ifAbsent:!public!removing! !
!SystemDictionary categoriesFor: #renameGlobal:to:!operations!public! !
!SystemDictionary categoriesFor: #setEvents:!events!private! !
!SystemDictionary categoriesFor: #triggerGlobalRenamed:from:!events!private! !

!SystemDictionary class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon! !
!SystemDictionary class categoriesFor: #icon!constants!public! !


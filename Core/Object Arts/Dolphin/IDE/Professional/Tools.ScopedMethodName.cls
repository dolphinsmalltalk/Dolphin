"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RBMethodName subclass: #'Tools.ScopedMethodName'
	instanceVariableNames: 'methodClass originalArguments originalSelector scope scopes'
	classVariableNames: ''
	imports: #(#{Refactory.Browser})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ScopedMethodName guid: (Core.GUID fromString: '{50a0d881-8784-4db2-b798-817a44da9e38}')!
Tools.ScopedMethodName comment: 'Dolphin extension of RBMethodName. Holds a scope (a BrowserEnvironment) that defines the context within which the rename is performed.

Instance Variables:
	methodClass			<ClassDescription>. Class of the method being (re)named.
	originalArguments	<OrderedCollection> of <String>. Original argument list.
	originalSelector		<Symbol>. Original selector.
	scope				<BrowserEnvironment>. Rename scope.
	scopes				<LookupTable> mapping <String> name to <BrowserEnvironment>. Possible rename scopes.

'!
!Tools.ScopedMethodName categoriesForClass!Refactory-Support! !
!Tools.ScopedMethodName methodsFor!

addScope: aBrowserEnvironment 
	^scopes at: aBrowserEnvironment label put: aBrowserEnvironment!

addScope: aBrowserEnvironment name: aString 
	aBrowserEnvironment label: aString.
	^self addScope: aBrowserEnvironment!

addScopesForMethod: aCompiledMethod
	| package env |
	self addScope: (BrowserEnvironment new
				forClasses: {aCompiledMethod methodClass. aCompiledMethod methodClass class})
		name: 'Class'.
	self
		addScope: (BrowserEnvironment new forClass: self methodClass selectors: {aCompiledMethod selector})
		name: 'Method'.
	self addScope: (BrowserEnvironment new forClassHierarchyFrom: aCompiledMethod methodClass)
		name: 'Hierarchy'.
	package := aCompiledMethod owningPackage.
	package isNil ifTrue: [^self].
	env := (BrowserEnvironment new forPackages: {package})
				label: 'Package';
				yourself.
	self addScope: env!

defaultScope
	^scopes at: 'Global'!

hasNewSignature
	^self selector ~= self originalSelector or: [self arguments ~= self originalArguments]!

initializeForMethod: aCompiledMethod 
	selector := originalSelector := aCompiledMethod selector.
	methodClass := aCompiledMethod methodClass.
	originalArguments := aCompiledMethod parseTree argumentNames asOrderedCollection.
	arguments := originalArguments copy.
	self addScopesForMethod: aCompiledMethod.
	scope := self defaultScope.
	self assert: [self isValid]!

methodClass
	^methodClass!

originalArguments
	^originalArguments!

originalSelector
	^originalSelector!

packages: aCollectionOfPackages
	aCollectionOfPackages isEmpty ifTrue: [^self].
	scope := (BrowserEnvironment new forPackages: aCollectionOfPackages)
				label: (aCollectionOfPackages size > 1 ifTrue: ['Packages'] ifFalse: ['Package']);
				yourself.
	self addScope: scope!

permutation
	^arguments collect: [:a | originalArguments indexOf: a]!

scope
	^scope!

scope: aBrowserEnvironment 
	scope := aBrowserEnvironment!

scopeNames
	^scopes asSortedCollection: [:a :b | a label <= b label]!

setSelector: aSymbol arguments: anArray
	super setSelector: aSymbol arguments: anArray.
	scopes := LookupTable new.
	self addScope: BrowserEnvironment new name: 'Global'! !
!Tools.ScopedMethodName categoriesFor: #addScope:!adding!public! !
!Tools.ScopedMethodName categoriesFor: #addScope:name:!adding!public! !
!Tools.ScopedMethodName categoriesFor: #addScopesForMethod:!initializing!private! !
!Tools.ScopedMethodName categoriesFor: #defaultScope!initializing!public! !
!Tools.ScopedMethodName categoriesFor: #hasNewSignature!commands!private! !
!Tools.ScopedMethodName categoriesFor: #initializeForMethod:!initializing!private! !
!Tools.ScopedMethodName categoriesFor: #methodClass!accessing!public! !
!Tools.ScopedMethodName categoriesFor: #originalArguments!accessing!public! !
!Tools.ScopedMethodName categoriesFor: #originalSelector!accessing!public! !
!Tools.ScopedMethodName categoriesFor: #packages:!accessing!public! !
!Tools.ScopedMethodName categoriesFor: #permutation!accessing!public! !
!Tools.ScopedMethodName categoriesFor: #scope!accessing!public! !
!Tools.ScopedMethodName categoriesFor: #scope:!accessing!public! !
!Tools.ScopedMethodName categoriesFor: #scopeNames!constants!public! !
!Tools.ScopedMethodName categoriesFor: #setSelector:arguments:!initializing!private! !

!Tools.ScopedMethodName class methodsFor!

fromMethod: aCompiledMethod
	^(self new)
		initializeForMethod: aCompiledMethod;
		yourself! !
!Tools.ScopedMethodName class categoriesFor: #fromMethod:!instance creation!public! !


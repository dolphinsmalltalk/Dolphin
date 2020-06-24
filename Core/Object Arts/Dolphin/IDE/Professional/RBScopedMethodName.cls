"Filed out from Dolphin Smalltalk 7"!

RBMethodName subclass: #RBScopedMethodName
	instanceVariableNames: 'methodClass originalArguments originalSelector scope scopes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBScopedMethodName guid: (GUID fromString: '{50a0d881-8784-4db2-b798-817a44da9e38}')!
RBScopedMethodName comment: 'Dolphin extension of RBMethodName. Holds a scope (a BrowserEnvironment) that defines the context within which the rename is performed.

Instance Variables:
	methodClass			<ClassDescription>. Class of the method being (re)named.
	originalArguments	<OrderedCollection> of <String>. Original argument list.
	originalSelector		<Symbol>. Original selector.
	scope				<BrowserEnvironment>. Rename scope.
	scopes				<LookupTable> mapping <String> name to <BrowserEnvironment>. Possible rename scopes.

'!
!RBScopedMethodName categoriesForClass!Refactory-Support! !
!RBScopedMethodName methodsFor!

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
!RBScopedMethodName categoriesFor: #addScope:!adding!public! !
!RBScopedMethodName categoriesFor: #addScope:name:!adding!public! !
!RBScopedMethodName categoriesFor: #addScopesForMethod:!initializing!private! !
!RBScopedMethodName categoriesFor: #defaultScope!initializing!public! !
!RBScopedMethodName categoriesFor: #hasNewSignature!commands!private! !
!RBScopedMethodName categoriesFor: #initializeForMethod:!initializing!private! !
!RBScopedMethodName categoriesFor: #methodClass!accessing!public! !
!RBScopedMethodName categoriesFor: #originalArguments!accessing!public! !
!RBScopedMethodName categoriesFor: #originalSelector!accessing!public! !
!RBScopedMethodName categoriesFor: #packages:!accessing!public! !
!RBScopedMethodName categoriesFor: #permutation!accessing!public! !
!RBScopedMethodName categoriesFor: #scope!accessing!public! !
!RBScopedMethodName categoriesFor: #scope:!accessing!public! !
!RBScopedMethodName categoriesFor: #scopeNames!constants!public! !
!RBScopedMethodName categoriesFor: #setSelector:arguments:!initializing!private! !

!RBScopedMethodName class methodsFor!

fromMethod: aCompiledMethod
	^(self new)
		initializeForMethod: aCompiledMethod;
		yourself! !
!RBScopedMethodName class categoriesFor: #fromMethod:!instance creation!public! !


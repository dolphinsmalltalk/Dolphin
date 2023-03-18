"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RBMethodName
	subclass: #'Tools.ScopedMethodName'
	instanceVariableNames: 'methodClass originalArguments originalSelector scopeName scopes'
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

addScope: aBrowserEnvironment name: aString
	"aBrowserEnvironment label: aString."

	^scopes at: aString put: aBrowserEnvironment!

addScopesForMethod: aCompiledMethod
	| globalEnv |
	globalEnv := self scopeNamed: 'Global'.
	self
		addScope: (globalEnv forClasses: {aCompiledMethod methodClass. aCompiledMethod methodClass class})
		name: 'Class'.
	self addScope: (globalEnv forClass: self methodClass selectors: {aCompiledMethod selector})
		name: 'Method'.
	self addScope: (globalEnv forClassHierarchyFrom: aCompiledMethod methodClass) name: 'Hierarchy'.
	aCompiledMethod owningPackage
		ifNotNil: [:package | self addScope: (globalEnv forPackages: {package}) name: 'Package']!

defaultScope
	^'Global'!

hasNewSignature
	^self selector ~= self originalSelector or: [self arguments ~= self originalArguments]!

initializeForMethod: aCompiledMethod
	selector := originalSelector := aCompiledMethod selector.
	methodClass := aCompiledMethod methodClass.
	originalArguments := aCompiledMethod parseTree argumentNames asOrderedCollection.
	arguments := originalArguments copy.
	self addScopesForMethod: aCompiledMethod.
	scopeName := self defaultScope.
	self assert: [self isValid]!

methodClass
	^methodClass!

originalArguments
	^originalArguments!

originalSelector
	^originalSelector!

packages: aCollectionOfPackages
	| scope |
	aCollectionOfPackages isEmpty ifTrue: [^self].
	scopeName := aCollectionOfPackages size > 1 ifTrue: ['Packages'] ifFalse: ['Package'].
	scope := BrowserEnvironment new forPackages: aCollectionOfPackages.
	self addScope: scope name: scopeName!

permutation
	^arguments collect: [:a | originalArguments indexOf: a]!

scope
	^self scopeNamed: scopeName!

scopeName
	^scopeName!

scopeName: aString
	scopeName := aString.
	self trigger: #scopeChanged!

scopeNamed: aString
	^aString ifNotNil: [scopes at: aString]!

scopeNames
	^scopes keys asSortedArray!

setSelector: aSymbol arguments: anArray
	super setSelector: aSymbol arguments: anArray.
	scopes := LookupTable new.
	self addScope: BrowserEnvironment new name: 'Global'! !
!Tools.ScopedMethodName categoriesForMethods!
addScope:name:!adding!public! !
addScopesForMethod:!initializing!private! !
defaultScope!initializing!public! !
hasNewSignature!commands!private! !
initializeForMethod:!initializing!private! !
methodClass!accessing!public! !
originalArguments!accessing!public! !
originalSelector!accessing!public! !
packages:!accessing!public! !
permutation!accessing!public! !
scope!accessing!public! !
scopeName!accessing!public! !
scopeName:!accessing!public! !
scopeNamed:!constants!public! !
scopeNames!constants!public! !
setSelector:arguments:!initializing!private! !
!

!Tools.ScopedMethodName class methodsFor!

fromMethod: aCompiledMethod
	^(self new)
		initializeForMethod: aCompiledMethod;
		yourself! !
!Tools.ScopedMethodName class categoriesForMethods!
fromMethod:!instance creation!public! !
!


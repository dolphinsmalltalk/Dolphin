"Filed out from Dolphin Smalltalk"!

WebView2.Tests.WebViewEnvironmentTest
	subclass: #'WebView2.Tests.ICoreWebView2ObjectCollectionTest'
	instanceVariableNames: 'objects'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.Tests.ICoreWebView2ObjectCollectionTest guid: (Core.GUID fromString: '{a9435ba7-abcb-4ba6-a664-10ac1c4d99ca}')!

WebView2.Tests.ICoreWebView2ObjectCollectionTest comment: ''!

!WebView2.Tests.ICoreWebView2ObjectCollectionTest methodsFor!

createCollection
	^webviewEnvironment createObjectCollection: objects!

minimumEnvironmentVersion
	^ICoreWebView2Environment14!

setUp
	super setUp.
	objects := { Examples.RandomStream new. #[1 2 3] readStream. LOGFONTW }!

testAdd
	| subject view |
	subject := self createCollection.
	view := subject queryInterface: ICoreWebView2ObjectCollectionView.
	self assert: subject size equals: objects size.
	self assert: view size equals: objects size.
	self assert: (subject add: RECTL) equals: (RECTL queryInterface: IUnknown).
	self assert: subject size equals: objects size + 1.
	self assert: view size equals: objects size + 1.
	objects := objects , { RECTL }.
	1 to: subject size
		do: 
			[:i |
			| unk |
			unk := (objects at: i) queryInterface: IUnknown.
			self assert: ((subject at: i) isSameCOMObject: unk).
			self assert: ((view at: i) isSameCOMObject: unk)]!

testAddAll
	| subject extras |
	subject := self createCollection.
	self assert: subject size equals: objects size.
	extras := { RECTL. POINTL }.
	self assert: (subject addAll: extras)
		equals: (extras collect: [:each | each queryInterface: IUnknown]).
	self assert: subject size equals: objects size + extras size.
	subject with: objects , extras
		do: [:unk :obj | self assert: (unk isSameCOMObject: (obj queryInterface: IUnknown))]!

testAt
	| subject offEnd view |
	subject := self createCollection.
	view := subject queryInterface: ICoreWebView2ObjectCollectionView.
	1 to: objects size
		do: 
			[:i |
			| unk |
			unk := (objects at: i) queryInterface: IUnknown.
			self assert: ((subject at: i) isSameCOMObject: unk).
			self assert: ((view at: i) isSameCOMObject: unk)].
	offEnd := subject size + 1.
	self
		should: [subject at: offEnd]
		raise: BoundsError
		matching: [:ex | ex tag = offEnd].
	self
		should: [view at: offEnd]
		raise: BoundsError
		matching: [:ex | ex tag = offEnd]!

testAtAllPut
	| subject unk |
	subject := self createCollection.
	self assert: subject size equals: objects size.
	unk := RECTL queryInterface: IUnknown.
	self assert: (subject atAllPut: RECTL) equals: unk.
	self assert: subject size equals: objects size.
	1 to: objects size do: [:i | self assert: (subject at: i) equals: unk].
	self assert: unk referenceCount > objects size!

testAtPut
	| subject offEnd |
	subject := self createCollection.
	self assert: (subject at: 1 put: RECTL) equals: (RECTL queryInterface: IUnknown).
	self assert: subject size equals: 3.
	self assert: (subject at: 1) equals: (RECTL queryInterface: IUnknown).
	2 to: 3
		do: [:i | self assert: ((subject at: i) isSameCOMObject: ((objects at: i) queryInterface: IUnknown))].
	self assert: (subject at: 3 put: POINTL) equals: (POINTL queryInterface: IUnknown).
	self assert: subject size equals: 3.
	self assert: (subject at: 1) equals: (RECTL queryInterface: IUnknown).
	self assert: (subject at: 2) equals: ((objects at: 2) queryInterface: IUnknown).
	self assert: (subject at: 3) equals: (POINTL queryInterface: IUnknown).
	offEnd := subject size + 1.
	self
		should: [subject at: offEnd put: (subject at: 1)]
		raise: BoundsError
		matching: [:ex | ex tag = offEnd]!

testCreate
	| subject view |
	subject := self createCollection.
	self deny: subject isNull.
	self assert: subject size equals: objects size.
	subject with: objects
		do: [:unk :obj | self assert: (unk isSameCOMObject: (obj queryInterface: IUnknown))].
	"Can also access via read-only view"
	view := subject queryInterface: ICoreWebView2ObjectCollectionView.
	self assert: (view isSameCOMObject: subject).
	view with: objects
		do: [:unk :obj | self assert: (unk isSameCOMObject: (obj queryInterface: IUnknown))]!

testFirstSecondThird
	| subject view |
	subject := self createCollection.
	self assert: subject first equals: (objects first queryInterface: IUnknown).
	self assert: subject second equals: (objects second queryInterface: IUnknown).
	self assert: subject third equals: (objects third queryInterface: IUnknown).
	view := subject queryInterface: ICoreWebView2ObjectCollectionView.
	self assert: view first equals: (objects first queryInterface: IUnknown).
	self assert: view second equals: (objects second queryInterface: IUnknown).
	self assert: view third equals: (objects third queryInterface: IUnknown).
	subject removeFirst.
	self assert: subject first equals: (objects second queryInterface: IUnknown).
	self assert: subject second equals: (objects third queryInterface: IUnknown).
	self should: [subject third] raise: BoundsError.
	self assert: view first equals: (objects second queryInterface: IUnknown).
	self assert: view second equals: (objects third queryInterface: IUnknown).
	self should: [view third] raise: BoundsError.
	subject removeAll.
	self should: [subject first] raise: BoundsError.
	self should: [view first] raise: BoundsError!

testRemoveAll
	| subject |
	subject := self createCollection.
	self assert: subject size equals: objects size.
	subject removeAll.
	self assert: subject isEmpty!

testRemoveFirst
	| subject |
	subject := self createCollection.
	self deny: subject isNull.
	self assert: subject size equals: objects size.
	1 to: objects size
		do: 
			[:i |
			| unknown |
			unknown := subject removeFirst.
			self assert: (unknown isSameCOMObject: ((objects at: i) queryInterface: IUnknown)).
			self assert: subject size equals: objects size - i].
	self assert: subject isEmpty.
	self should: [subject removeFirst] raise: BoundsError!

testRemoveLast
	| subject |
	subject := self createCollection.
	self deny: subject isNull.
	self assert: subject size equals: objects size.
	objects size to: 1
		by: -1
		do: 
			[:i |
			| unknown |
			unknown := subject removeLast.
			self assert: (unknown isSameCOMObject: ((objects at: i) queryInterface: IUnknown)).
			self assert: subject size equals: i - 1].
	self assert: subject isEmpty.
	self should: [subject removeFirst] raise: BoundsError! !

!WebView2.Tests.ICoreWebView2ObjectCollectionTest categoriesForMethods!
createCollection!private!unit tests! !
minimumEnvironmentVersion!constants!private! !
setUp!public! !
testAdd!public!unit tests! !
testAddAll!public!unit tests! !
testAt!public!unit tests! !
testAtAllPut!public!unit tests! !
testAtPut!public!unit tests! !
testCreate!public!unit tests! !
testFirstSecondThird!public!unit tests! !
testRemoveAll!public!unit tests! !
testRemoveFirst!public!unit tests! !
testRemoveLast!public!unit tests! !
!


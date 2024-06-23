"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'UI.Tests.CommandAnnotationsRegisterTest'
	instanceVariableNames: 'subclass subclass2'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.CommandAnnotationsRegisterTest guid: (Core.GUID fromString: '{bb1256fb-74b5-4d7e-8c95-35e18d66c311}')!

UI.Tests.CommandAnnotationsRegisterTest comment: ''!

!UI.Tests.CommandAnnotationsRegisterTest methodsFor!

canA
	^false!

cmdA
!

cmdB
	<acceleratorKey: 'Ctrl+B'>
	<commandQuery: #queryB:>
	!

cmdC
	<acceleratorKey: 'Ctrl+C'>
	<commandQuery: #queryC:>
	!

cmdD
	<commandQuery: #queryD:foo:>
	!

menuA
	<commandQuery: #canA>
	<menuPopulator: #populateMenuA:>!

menuD
	<menuPopulator: #foo>
	<menuPopulator: #bar:>
	!

populateMenuA: aMenu
	aMenu addCommand: #foo description: 'Foo'!

queryB: aCommandQuery
	aCommandQuery
		beEnabled;
		text: 'Do B'!

queryCommand: aCommandQuery
	^self class commandAnnotations queryCommand: aCommandQuery ofTarget: self!

setUp
	super setUp.
	subclass := self class newAnonymousSubclass.
	subclass2 := subclass newAnonymousSubclass.
	subclass addSubclass: subclass2.
	subclass
		compile: 'populateMenuB: aMenu aMenu addCommand: #bar description: ''Bar''';
		compile: 'menuB <menuPopulator: #populateMenuB:>';
		compile: 'cmdA <commandQuery: #canA>';
		compile: 'queryD: q q isEnabled: true; text: ''subclass.queryD''';
		compile: 'cmdD <commandQuery: #queryD:>'.
	self assert: subclass selectors asSortedArray equals: #(#cmdA #cmdD #menuB #populateMenuB: #queryD:)!

tearDown
	CommandAnnotationsRegister.Current
		onClassRemoved: self class;
		onClassRemoved: subclass;
		onClassRemoved: subclass2.
	^super tearDown!

testAcceleratorKeys
	| notifications |
	notifications := OrderedCollection new.
	[self class acceleratorKeys] on: Notification
		do: 
			[:ex |
			notifications add: ex description.
			ex resume].
	self assert: notifications asArray equals: #().
	self assert: (self class acceleratorKeys asSortedArray: [:a :b | a first <= b first])
		equals: #(#(#cmdB 'CTRL+B') #(#cmdC 'CTRL+C'))!

testCommandQueries
	| notifications querySelectors query |
	notifications := OrderedCollection new.
	[self class commandQueries] on: Notification
		do: 
			[:ex |
			notifications add: ex description.
			ex resume].
	self assert: notifications asSortedArray
		equals: #('Ignoring invalid command query selector #queryC:' 'Ignoring invalid command query selector #queryD:foo:').
	"Note that cmdA is not present"
	querySelectors := #(#cmdB #cmdC #cmdD #menuA).
	self assert: self class commandQueries keys asSortedArray equals: querySelectors.
	query := CommandQuery new.
	(self class commandQueries at: #cmdB) value: self value: query.
	self assert: query isEnabled.
	self assert: query text equals: 'Do B'.
	self assert: query receiver isNil.
	query := CommandQuery new.
	(self class commandQueries at: #menuA) value: self value: query.
	self deny: query isEnabled.
	self assert: query receiver isNil.
	#(#cmdC #cmdD) do: [:each | self verifyNullingQuery: each for: self class].
	"Now test out the inheritance mechanism"
	querySelectors := #(#cmdA #cmdB #cmdC #cmdD #menuA).
	self assert: subclass commandQueries keys asSortedArray equals: querySelectors.
	self assert: subclass2 commandQueries keys asSortedArray equals: querySelectors.
	self assert: ((subclass commandQueries at: #menuA) at: 1) identicalTo: #canA.
	"Redefinition of command method should prevent inheritance of any query, even if none defined"
	subclass compile: 'menuA'.
	self assert: subclass commandQueries keys asSortedArray equals: querySelectors.
	self assert: subclass2 commandQueries keys asSortedArray equals: querySelectors.
	self verifyEnablingQuery: #menuA for: subclass.
	self verifyEnablingQuery: #menuA for: subclass2.
	"Removing again should unshadow the inherited annotation once more"
	subclass removeSelector: #menuA.
	self assert: subclass commandQueries keys asSortedArray equals: querySelectors.
	self assert: subclass2 commandQueries keys asSortedArray equals: querySelectors.
	self assert: ((subclass commandQueries at: #menuA) at: 1) identicalTo: #canA.
	"Now override"
	subclass
		compile: 'queryMenuA: q q isEnabled: true; text: ''subclass.MenuA''';
		compile: 'menuA <commandQuery: #queryMenuA:>'.
	self assert: subclass commandQueries keys asSortedArray equals: querySelectors.
	self assert: (subclass commandQueries at: #menuA) selector equals: #queryMenuA:.
	self assert: subclass2 commandQueries keys asSortedArray equals: querySelectors.
	"Not remove one that is again shadowing"
	subclass removeSelector: #cmdD.
	self assert: subclass commandQueries keys asSortedArray equals: querySelectors.
	self assert: subclass2 commandQueries keys asSortedArray equals: querySelectors.
	self verifyNullingQuery: #cmdD for: subclass.
	self verifyNullingQuery: #cmdD for: subclass2.
	"Remove one where none inherited"
	subclass removeSelector: #cmdA.
	querySelectors := #(#cmdB #cmdC #cmdD #menuA).
	self assert: subclass commandQueries keys asSortedArray equals: querySelectors.
	self assert: subclass2 commandQueries keys asSortedArray equals: querySelectors.
!

testMenuPopulators
	| notifications subclassPopulators basePopulators |
	notifications := OrderedCollection new.
	[self class menuPopulators] on: Notification
		do: 
			[:ex |
			notifications add: ex description.
			ex resume].
	self assert: notifications asArray
		equals: #('Ignoring invalid menu populator selector #foo' 'Ignoring invalid menu populator selector #bar:').
	basePopulators := IdentityDictionary withAll: { #menuA -> #populateMenuA:. #menuD -> nil }.
	self assert: self class menuPopulators equals: basePopulators.
	"Now test out the inheritance mechanism"
	subclassPopulators := IdentityDictionary
				withAll: { #menuA -> #populateMenuA:. #menuD -> nil. #menuB -> #populateMenuB: }.
	self assert: subclass menuPopulators equals: subclassPopulators.
	self assert: subclass2 menuPopulators equals: subclassPopulators.
	subclass
		compile: 'populateMenuC: aMenu';
		compile: 'menuC <menuPopulator: #populateMenuC:>'.
	"The newly added populators should now be visible"
	subclassPopulators := IdentityDictionary withAll: {
						#menuA -> #populateMenuA:.
						#menuD -> nil.
						#menuB -> #populateMenuB:.
						#menuC -> #populateMenuC:
					}.
	self assert: subclass menuPopulators equals: subclassPopulators.
	"The subclass of the subclass should also pick up the new populator."
	self assert: subclass2 menuPopulators equals: subclassPopulators.
	"Now remove one"
	subclass removeSelector: #menuB.
	subclassPopulators := IdentityDictionary
				withAll: { #menuA -> #populateMenuA:. #menuD -> nil. #menuC -> #populateMenuC: }.
	self assert: subclass menuPopulators equals: subclassPopulators.
	self assert: subclass2 menuPopulators equals: subclassPopulators.
	"Adding an empty override should shadow out inherited populator, bad or not"
	subclass compile: 'menuA'.
	subclassPopulators := IdentityDictionary
				withAll: { #menuA -> nil. #menuD -> nil. #menuC -> #populateMenuC: }.
	self assert: subclass menuPopulators equals: subclassPopulators.
	"The subclass of the subclass should also pick up the new populator."
	self assert: subclass2 menuPopulators equals: subclassPopulators.
	"Shadow inherited (bad) populator"
	subclass compile: 'menuD <menuPopulator: #populateMenuA:>'.
	subclassPopulators := IdentityDictionary withAll: {
						#menuA -> nil.
						#menuD -> #populateMenuA:.
						#menuC -> #populateMenuC:
					}.
	self assert: subclass menuPopulators equals: subclassPopulators.
	"The subclass of the subclass should also pick up the new populator."
	self assert: subclass2 menuPopulators equals: subclassPopulators!

testOnAboutToDisplayMenu
	| menu |
	menu := Menu new
				name: #menuA;
				yourself.
	[self class commandAnnotations onAboutToDisplayMenu: menu for: self] on: Notification
		do: [:ex | ex resume	"suppress any notifications from discovery"].
	self assert: (menu items asArray collect: [:each | each command]) equals: #(#foo).
	menu := Menu new
				name: #menuB;
				yourself.
	subclass commandAnnotations onAboutToDisplayMenu: menu for: subclass new.
	self assert: (menu items asArray collect: [:each | each command]) equals: #(#bar)!

testOnAboutToDisplayMenuBadPopulators
	| menu |
	menu := Menu new
				name: #menuD;
				yourself.
	[self class commandAnnotations onAboutToDisplayMenu: menu for: self] on: Notification
		do: [:ex | ex resume	"suppress any notifications from discovery"].
	self assert: menu items isEmpty.
	self class commandAnnotations onAboutToDisplayMenu: menu for: subclass new.
	self assert: menu items isEmpty!

testQueryCommand
	| query |
	query := CommandQuery commandDescription: (CommandDescription command: #cmdB) source: self.
	self assert: ([self queryCommand: query] on: Notification
				do: [:ex | ex resume	"suppress trace from discovery"]).
	self assert: query isEnabled.
	self assert: query text equals: 'Do B'.
	"Doesn't set receiver explicitly, but will be set by command routing for enabled commands"
	self assert: query receiver identicalTo: nil.
	"Query for cmdC is malformed, so explicitly disabled and prevented from further routing."
	query := CommandQuery commandDescription: (CommandDescription command: #cmdC) source: self.
	self assert: (self queryCommand: query).
	self deny: query isEnabled.
	self assert: query receiver identicalTo: self.
	"menuA queried with #canA, which answers false."
	query := CommandQuery commandDescription: (CommandDescription command: #menuA) source: self.
	self assert: (self queryCommand: query).
	self deny: query isEnabled.
	"Will continue along command route"
	self assert: query receiver identicalTo: nil!

verifyEnablingQuery: aSymbol for: aClass
	| query |
	query := CommandQuery new.
	(aClass commandQueries at: aSymbol) value: #rcvr value: query.
	self assert: query isEnabled.
	self assertIsNil: query receiver!

verifyNullingQuery: aSymbol for: aClass
	| query |
	query := CommandQuery new.
	(aClass commandQueries at: aSymbol) value: #rcvr value: query.
	self deny: query isEnabled.
	self assert: query receiver identicalTo: #rcvr! !

!UI.Tests.CommandAnnotationsRegisterTest categoriesForMethods!
canA!private!testing / examples! !
cmdA!private!testing / examples! !
cmdB!private!testing / examples! !
cmdC!private!testing / examples! !
cmdD!private!testing / examples! !
menuA!private!testing / examples! !
menuD!private!testing / examples! !
populateMenuA:!private!testing / examples! !
queryB:!private!testing / examples! !
queryCommand:!public! !
setUp!public!unit tests! !
tearDown!public!running! !
testAcceleratorKeys!public!unit tests! !
testCommandQueries!public!unit tests! !
testMenuPopulators!public!unit tests! !
testOnAboutToDisplayMenu!public!unit tests! !
testOnAboutToDisplayMenuBadPopulators!public!unit tests! !
testQueryCommand!public!unit tests! !
verifyEnablingQuery:for:!helpers!private! !
verifyNullingQuery:for:!helpers!private! !
!

UI.Tests.CommandAnnotationsRegisterTest methodProtocol: #commandTarget attributes: #(#readOnly) selectors: #(#queryCommand:)!

!UI.Tests.CommandAnnotationsRegisterTest class methodsFor!

acceleratorKeys
	^self commandAnnotations acceleratorKeys!

commandAnnotations
	^CommandAnnotationsRegister.Current annotationsFor: self!

commandQueries
	^self commandAnnotations commandQueries!

menuPopulators
	^self commandAnnotations menuPopulators! !

!UI.Tests.CommandAnnotationsRegisterTest class categoriesForMethods!
acceleratorKeys!accessing!public!unit tests! !
commandAnnotations!public! !
commandQueries!accessing!public!unit tests! !
menuPopulators!accessing!public!unit tests! !
!


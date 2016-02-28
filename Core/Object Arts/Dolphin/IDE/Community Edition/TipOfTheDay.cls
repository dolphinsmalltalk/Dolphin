"Filed out from Dolphin Smalltalk 7"!

Object subclass: #TipOfTheDay
	instanceVariableNames: ''
	classVariableNames: 'NextTipIndex ShowTipsAtStartup'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
TipOfTheDay guid: (GUID fromString: '{1BAE8EA1-C3F2-443D-8317-AE3C74C7CB93}')!
TipOfTheDay comment: 'TipOfTheDay is a <SmalltalkToolShell> that implements a window displaying helpful usage tips about Dolphin Smalltalk. The tips are taken from a number of .tip files found in the Resources directory. Addtional tip files can be added if necessary; the files contain one tip per line and each tip may have HTML formatting if desired.

The development system is initially configured to display the TipOfTheDay window at image startup (after the splash screen has been dismissed). This can be turned on or off from within the TipOf TheDay window or by using the system options for this tool. A TipOfTheDay is also available at any time from the Help/Tip of the Day menu command.

Instance Variables:
	tipText		<URLPresenter> displaying the current tip as HTML.
	showTipsAtStartup	<BooleanPresenter> indicating whether the tip window should appear at startup.
	tipsFile		<ChoicePresenter> indicating the name of the tips file to use.

Class Variables:
	TipsFile		<readableString> indicating the name of the current tips file.
	ShowTipsAtStartup	<boolean> indicating whether the tip window will appear at startup.
	TipIndex		<SmallInteger> holding the index of the current tip within tips file.

'!
!TipOfTheDay categoriesForClass!Development!MVP-Presenters! !
!TipOfTheDay methodsFor!

isWinHelpAvailable
	VMLibrary default isWindowsVistaOrGreater ifFalse: [^true].
	File for: (File composePath: SessionManager current windowsDirectory subPath: 'WinHlp32.exe')
		do: [:each | each fileSize > 200000 ifTrue: [^true]].
	^false!

sessionManager
	^SessionManager current!

showTipId: anInteger 
	| position |
	self isWinHelpAvailable 
		ifFalse: 
			[| resp |
			resp := (MessageBox new)
						uniqueId: [self] method displayString;
						isSuppressible: true;
						caption: 'Tip of the Day...';
						buttonStyle: #yesNo;
						warning: ('Sorry but Dolphin may be unable to display Tips of the Day <1d> on your system because the operating system does not include the WinHelp engine used to display the popups. You can download WinHelp.exe from Microsoft; please see the following KB article for further information:<n><n><t>http://support.microsoft.com/kb/917607<n><n>In the meantime it is recommended that you disable tips of the day at startup in order to prevent Windows displaying a window informing you that you cannot get help from this program.

Would you like to disable Tip of the Day?' 
									expandMacrosWith: anInteger).
			resp == #yes 
				ifTrue: 
					[self class showTipsAtStartup: false.
					^self]].
	position := SystemMetrics current virtualScreenRectangle 
				constrain: View active rectangle center - (0 @ 100).
	^View active 
		winHelpPopup: self sessionManager popupHelpFile
		topic: anInteger
		at: position! !
!TipOfTheDay categoriesFor: #isWinHelpAvailable!private!queries! !
!TipOfTheDay categoriesFor: #sessionManager!private! !
!TipOfTheDay categoriesFor: #showTipId:!operations!public! !

!TipOfTheDay class methodsFor!

chooseRandomTip
	"Private - Answers a randomly chosen tip id"

	^self tipIds at: (Random new next * self tipIds size) truncated + 1!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver.

		self initialize.
	"

	self showTipsAtStartup: true.
	SessionManager current 
		when: #sessionReady
		send: #tipOfTheDayAtStartup
		to: Smalltalk developmentSystem!

nextTipId
	NextTipIndex 
		ifNil: 
			["Returning here prevents 1st Tip of Day being shown immediately after the unlock"
			^NextTipIndex := 0].
	NextTipIndex := NextTipIndex + 1.
	NextTipIndex > self tipIds size ifTrue: [NextTipIndex := 1].
	^self tipIds at: NextTipIndex!

previousTipId
	NextTipIndex ifNil: [NextTipIndex := 0].
	NextTipIndex := NextTipIndex - 1.
	NextTipIndex < 1 ifTrue: [NextTipIndex := self tipIds size].
	^self tipIds at: NextTipIndex!

publishedAspects
	"Private - Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		add: (Aspect boolean: #showTipsAtStartup);
		yourself!

reset
	"
	self reset
	"
	NextTipIndex := nil!

showNextTip
	"
	self showNextTip
	"

	| id |
	id := self nextTipId.
	id = 0 
		ifTrue: 
			["Prevent first tip after unlock from appearing"
			^self].
	^self new showTipId: id!

showPreviousTip
	"
	self showPreviousTip
	"

	^self new showTipId: self previousTipId!

showRandomTip
	"
	self showRandomTip
	"
	
	^self new showTipId: self chooseRandomTip!

showTipsAtStartup
	"Answer true if the TipOfTheDay window should appear when the image starts"

	^ShowTipsAtStartup
	

	!

showTipsAtStartup: aBoolean
	"Set whether the TipOfTheDay window should appear when the image starts according to aBoolean"

	ShowTipsAtStartup := aBoolean
	

	!

tipIds
	"Answers an <Array> of help ids for the tips available"

	^#(10627 10628 10633 10634 10635 10636 10637 10638 10639 10640 10641 10642 10643 10644 10645 10646 10647 10648 10649 10650 10651 10652 10653 10654 10655 10656 10657 10658 10659 10660 10661 10662 10663 10664 10665 10666 10667 10668 10669 10670 10671 10672 10673 10674 10675 10676 10677 10678 10679 10680 10681 10682 10683 10684 10685 10686 10687 10688 10689 10690 10691 10692 10693 10694 10695 10696 10697 10698 10699 10700)!

uninitialize
	"Private - Un-register the system tools folder icon for the receiver to allow clean
	removal of this class from the system.

	self uninitialize
	"

	(SessionManager current events at: #sessionReady) removeMessagesFor: Smalltalk developmentSystem! !
!TipOfTheDay class categoriesFor: #chooseRandomTip!private! !
!TipOfTheDay class categoriesFor: #icon!constants!public! !
!TipOfTheDay class categoriesFor: #initialize!initializing!private! !
!TipOfTheDay class categoriesFor: #nextTipId!private! !
!TipOfTheDay class categoriesFor: #previousTipId!private! !
!TipOfTheDay class categoriesFor: #publishedAspects!development!private! !
!TipOfTheDay class categoriesFor: #reset!public! !
!TipOfTheDay class categoriesFor: #showNextTip!public! !
!TipOfTheDay class categoriesFor: #showPreviousTip!public! !
!TipOfTheDay class categoriesFor: #showRandomTip!public! !
!TipOfTheDay class categoriesFor: #showTipsAtStartup!accessing!public! !
!TipOfTheDay class categoriesFor: #showTipsAtStartup:!accessing!public! !
!TipOfTheDay class categoriesFor: #tipIds!public! !
!TipOfTheDay class categoriesFor: #uninitialize!class hierarchy-removing!private! !

